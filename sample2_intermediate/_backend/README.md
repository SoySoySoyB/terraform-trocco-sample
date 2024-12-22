<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | 1.9.8 |
| google | 6.14.0 |

## Providers

| Name | Version | Alias |
| ---- | ------- | ----- |
| google | 6.14.0 | n/a |

## Resources

| Type | Name | File | Comment |
| ------------ | ---- | ---- | ------- |
| resource | [google_iam_workload_identity_pool.github_actions](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/iam_workload_identity_pool) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L36) | Workload Identity Poolを作成 https://console.cloud.google.com/iam-admin/workload-identity-pools |
| resource | [google_iam_workload_identity_pool_provider.terraform](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/iam_workload_identity_pool_provider) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L44) | Workload Identity Pool Providerを、GitHubの特定のリポジトリIDを指定する形で設定する https://console.cloud.google.com/iam-admin/workload-identity-pools/pool/github-actions |
| resource | [google_project.sample_project](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L8) | 具体のリソースを作成して試すためのプロジェクト なお、プロジェクトの状況は以下のリンクで確認できる ref: https://console.cloud.google.com/cloud-resource-manager |
| resource | [google_project.workload_identity](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L27) | Workload Identity Federationを設定するためのプロジェクト |
| resource | [google_project_iam_binding.tfaction_apply](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_binding) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L192) | このロールはこのサービスアカウントにしか付与しないのでbindingにする |
| resource | [google_project_iam_binding.tfaction_plan](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_binding) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L161) | このロールはこのサービスアカウントにしか付与しないのでbindingにする |
| resource | [google_project_iam_custom_role.adding_role_of_tfaction_apply](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_custom_role) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L178) | Applyの際に各種設定を確認するための権限その2 |
| resource | [google_project_iam_custom_role.adding_role_of_tfaction_plan](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_custom_role) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L150) | Planの際に各種設定を確認するための権限その2 |
| resource | [google_project_iam_member.tfaction_apply_editor](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_member) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L171) | Applyの際に各種設定を確認するための権限その1 ref: https://console.cloud.google.com/iam-admin/roles/details/roles%3Ceditor |
| resource | [google_project_iam_member.tfaction_plan_viewer](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_member) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L143) | Planの際に各種設定を確認するための権限その1 ref: https://console.cloud.google.com/iam-admin/roles/details/roles%3Cviewer |
| resource | [google_service_account.tfaction_apply](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/service_account) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L79) | Workload Identity Federationを通してGitHub ActionsでtfactionのApplyを実行するためのサービスアカウント |
| resource | [google_service_account.tfaction_plan](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/service_account) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L60) | Workload Identity Federationを通してGitHub ActionsでtfactionのPlanを実行するためのサービスアカウント |
| resource | [google_service_account_iam_binding.tfaction_apply](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/service_account_iam_binding) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L87) | サービスアカウントの権限借用を利用するために、Workload Identity Userの権限を付与する |
| resource | [google_service_account_iam_binding.tfaction_plan](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/service_account_iam_binding) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L70) | サービスアカウントの権限借用を利用するために、Workload Identity Userの権限を付与する 「注: 別のプロジェクトのサービス アカウントは、Workload Identity プールの [接続済みサービス アカウント] セクションに表示されません。」 ref: https://cloud.google.com/iam/docs/workload-download-cred-and-grant-access?hl=ja#diffProject |
| resource | [google_storage_bucket.terraform_backend](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L110) | バックエンドとして利用するGCSのバケット force_destroy = falseにするとTerraform経由で削除しようとしてもブロックされる |
| resource | [google_storage_bucket_iam_binding.service_accounts_for_tfaction](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket_iam_binding) | [sample2_intermediate/_backend/_resources.tf](/sample2_intermediate/_backend/_resources.tf#L125) | サービスアカウントに管理権限を付与する |

<!-- END_TF_DOCS -->