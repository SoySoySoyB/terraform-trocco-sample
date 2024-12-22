/*
- データ基盤のGoogle Cloud StorageやBigQueryを構築するプロジェクトを作成する
*/

# 具体のリソースを作成して試すためのプロジェクト
# なお、プロジェクトの状況は以下のリンクで確認できる
# ref: https://console.cloud.google.com/cloud-resource-manager
resource "google_project" "sample_project" {
  project_id          = local.google.sample_project_id
  name                = local.google.sample_project_name
  billing_account     = local.google.billing_account
  auto_create_network = false
}


/*
- Workload Identity Federationで認証をかけるための設定を行う
- ref: https://cloud.google.com/iam/docs/workload-identity-federation?hl=ja
- ref: https://cloud.google.com/iam/docs/best-practices-for-using-workload-identity-federation?hl=ja
- GitHub - Workload Identity Pool - Workload Identity Pool Provider - Service Account - API - Target Resourceという流れで機能している
- Principalにroles/iam.workloadIdentityUserを付与するとサービスアカウントの権限を借用できる
- サービスアカウントを介さない設定も可能だが、管理するリソースによっては以下のエラーとなり、このユースケースでは利用不可であると思われた
  - "Caller must use first-party authentication in order to accept terms of service and use this API."
*/

# Workload Identity Federationを設定するためのプロジェクト
resource "google_project" "workload_identity" {
  project_id          = "${local.google.sample_project_id}-wif"
  name                = "${local.google.sample_project_name} WIF"
  billing_account     = local.google.billing_account
  auto_create_network = false
}

# Workload Identity Poolを作成
# https://console.cloud.google.com/iam-admin/workload-identity-pools
resource "google_iam_workload_identity_pool" "github_actions" {
  project                   = google_project.workload_identity.number
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
}

# Workload Identity Pool Providerを、GitHubの特定のリポジトリIDを指定する形で設定する
# https://console.cloud.google.com/iam-admin/workload-identity-pools/pool/github-actions
resource "google_iam_workload_identity_pool_provider" "terraform" {
  project                            = google_project.workload_identity.number
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "${lower(local.github.user_name)}-${lower(local.github.terraform_repository_name)}"
  display_name                       = "${local.github.user_name}-${local.github.terraform_repository_name}"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_condition = "assertion.repository_id == '${local.github.terraform_repository_id}'"
  attribute_mapping = {
    "google.subject"          = "assertion.sub"
    "attribute.repository_id" = "assertion.repository_id"
  }
}

# Workload Identity Federationを通してGitHub ActionsでtfactionのPlanを実行するためのサービスアカウント
resource "google_service_account" "tfaction_plan" {
  project      = google_project.sample_project.project_id
  account_id   = "github-actions-tfaction-plan"
  display_name = "GitHub Actions tfaction Plan"
  description  = "Workload Identity Federationを通してGitHub ActionsでtfactionのPlanを実行するためのサービスアカウント"
}

# サービスアカウントの権限借用を利用するために、Workload Identity Userの権限を付与する
# 「注: 別のプロジェクトのサービス アカウントは、Workload Identity プールの [接続済みサービス アカウント] セクションに表示されません。」
# ref: https://cloud.google.com/iam/docs/workload-download-cred-and-grant-access?hl=ja#diffProject
resource "google_service_account_iam_binding" "tfaction_plan" {
  service_account_id = google_service_account.tfaction_plan.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    local.terraform_principal.plan
  ]
}

# Workload Identity Federationを通してGitHub ActionsでtfactionのApplyを実行するためのサービスアカウント
resource "google_service_account" "tfaction_apply" {
  project      = google_project.sample_project.project_id
  account_id   = "github-actions-tfaction-apply"
  display_name = "GitHub Actions tfaction Apply"
  description  = "Workload Identity Federationを通してGitHub ActionsでtfactionのApplyを実行するためのサービスアカウント"
}

# サービスアカウントの権限借用を利用するために、Workload Identity Userの権限を付与する
resource "google_service_account_iam_binding" "tfaction_apply" {
  service_account_id = google_service_account.tfaction_apply.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    local.terraform_principal.apply
  ]
}


/*
- Terraformのバックエンドとして利用するGCSを作成し、サービスアカウントに権限を付与する
- なお、ここにstateファイルが保持されることになり、機密情報も多く入るので、アクセスできるユーザーは最小限に絞ること
*/

# 本来は別でプロジェクトを作成した方がよいが、個人環境だと課金を有効化できるデフォルト上限が5なので、プロジェクト数を削減するため同一にする
# resource "google_project" "terraform_backend" {
#   project_id = "${local.google.sample_project_id}-backend"
#   name       = "${local.google.sample_project_name} Backend"
#   auto_create_network = false
# }

# バックエンドとして利用するGCSのバケット
# force_destroy = falseにするとTerraform経由で削除しようとしてもブロックされる
resource "google_storage_bucket" "terraform_backend" {
  # 本当はプロジェクトを分けたい
  # project                     = google_project.terraform_backend.project_id
  project                     = google_project.workload_identity.project_id
  name                        = local.google.gcs_bucket_name_backend
  location                    = "ASIA1"
  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}

# サービスアカウントに管理権限を付与する
resource "google_storage_bucket_iam_binding" "service_accounts_for_tfaction" {
  bucket  = google_storage_bucket.terraform_backend.name
  role    = "roles/storage.admin"
  members = local.terraform_principal_service_accounts
}


/*
- Terraformで実行する内容に応じてサービスアカウントに必要な権限を付与する
- roles/viewer, roles/editorでは権限が大きすぎるので、本番運用時は権限を限定すること
- ref: https://cloud.google.com/iam/docs/choose-predefined-roles
- ref: https://cloud.google.com/iam/docs/understanding-roles
- またiam_member / iam_binding / iam_policyで挙動が違うので注意すること
- ref: https://qiita.com/NateRive/items/9d9126ab5758dee724f4
*/

# Planの際に各種設定を確認するための権限その1
# ref: https://console.cloud.google.com/iam-admin/roles/details/roles%3Cviewer
resource "google_project_iam_member" "tfaction_plan_viewer" {
  project = google_project.sample_project.project_id
  role    = "roles/viewer"
  member  = google_service_account.tfaction_plan.member
}

# Planの際に各種設定を確認するための権限その2
resource "google_project_iam_custom_role" "adding_role_of_tfaction_plan" {
  project     = google_project.sample_project.project_id
  role_id     = "customRoleOfPrincipalsForTfactionPlan"
  title       = "Custom: Adding Role of tfaction Plan"
  description = "GitHub Actionsでtfactionのplanを実行するにあたりroles/viewerのほかに追加で付与する権限"
  permissions = [
    "storage.buckets.getIamPolicy",
  ]
}

# このロールはこのサービスアカウントにしか付与しないのでbindingにする
resource "google_project_iam_binding" "tfaction_plan" {
  project = google_project.sample_project.project_id
  role    = "projects/${google_project.sample_project.project_id}/roles/${google_project_iam_custom_role.adding_role_of_tfaction_plan.role_id}"
  members = [
    google_service_account.tfaction_plan.member
  ]
}

# Applyの際に各種設定を確認するための権限その1
# ref: https://console.cloud.google.com/iam-admin/roles/details/roles%3Ceditor
resource "google_project_iam_member" "tfaction_apply_editor" {
  project = google_project.sample_project.project_id
  role    = "roles/editor"
  member  = google_service_account.tfaction_apply.member
}

# Applyの際に各種設定を確認するための権限その2
resource "google_project_iam_custom_role" "adding_role_of_tfaction_apply" {
  project     = google_project.sample_project.project_id
  role_id     = "customRoleOfPrincipalsForTfactionApply"
  title       = "Custom: Adding Role of tfaction Apply"
  description = "GitHub ActionsでtfactionのApplyを実行するにあたりroles/editorのほかに追加で付与する権限"
  permissions = [
    "storage.buckets.getIamPolicy",
    "storage.buckets.setIamPolicy",
    # roles/editorにはIAMを付与する権限はないので、別途付与が必要
    "resourcemanager.projects.setIamPolicy",
  ]
}

# このロールはこのサービスアカウントにしか付与しないのでbindingにする
resource "google_project_iam_binding" "tfaction_apply" {
  project = google_project.sample_project.project_id
  role    = "projects/${google_project.sample_project.project_id}/roles/${google_project_iam_custom_role.adding_role_of_tfaction_apply.role_id}"
  members = [
    google_service_account.tfaction_apply.member
  ]
}
