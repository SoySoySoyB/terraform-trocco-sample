/*
- 作成者が試したい環境設定を記載する
- 一意性条件や文字数制限、課金プロジェクトの作成数制限（個人のデフォルトは5）でリソース作成時にエラーとなることがあるので注意
- やり直そうとするときに、以下の点に注意
  - プロジェクトとバックエンド用のGCSバケットはデフォルトで削除制限が付与されている
  - Workload Identity Pool / Pool Providerは削除してもアーカイブとして残る挙動になっている
*/

locals {
  # Billing Accountは権限があれば以下で確認可能 https://console.cloud.google.com/billing
  # 基本的に新規でプロジェクトを作る形を想定しており、既存プロジェクトを利用する場合は設定をよく確認の上対応すること
  google = {
    sample_project_id       = "{YOUR_SAMPLE_PROJECT_ID}" # "-"は利用可／"_"は利用不可
    sample_project_name     = "{YOUR_SAMPLE_PROJECT_NAME}"
    billing_account         = "{YOUR_BILLING_ACCOUNT}"
    default_location        = "asia-northeast1"
    gcs_bucket_name_backend = "{YOUR_BUCKET_NAME_BACKEND}"
  }

  # リポジトリIDはリポジトリ画面のHTMLに対して、"repository_id"で検索すると確認可能
  github = {
    user_name                 = "{YOUR_USER_NAME}"
    terraform_repository_name = "{YOUR_REPOSITORY_NAME}"
    terraform_repository_id   = "{YOUR_REPOSITORY_ID}"
  }

  # 以下は作成したリソースから取得するため変更不要
  terraform_principal = {
    plan  = "principal://iam.googleapis.com/projects/${google_project.workload_identity.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/subject/repo:${local.github.user_name}/${local.github.terraform_repository_name}:pull_request"
    apply = "principal://iam.googleapis.com/projects/${google_project.workload_identity.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions.workload_identity_pool_id}/subject/repo:${local.github.user_name}/${local.github.terraform_repository_name}:ref:refs/heads/main"
  }
  terraform_principal_service_accounts = [
    google_service_account.tfaction_plan.member,
    google_service_account.tfaction_apply.member
  ]
}
