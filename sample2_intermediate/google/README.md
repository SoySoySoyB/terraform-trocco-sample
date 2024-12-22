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
| resource | [google_bigquery_dataset.dl_trocco_sample](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/bigquery_dataset) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L20) | 転送設定からテーブルを作成するデータセットを作成する |
| resource | [google_bigquery_dataset.dm_trocco_sample](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/bigquery_dataset) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L28) | データマート定義からテーブルを作成するデータセットを作成する |
| resource | [google_project_iam_binding.bigquery_data_editor](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_binding) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L47) | BigQueryでジョブを実行する権限を付与する |
| resource | [google_project_iam_binding.bigquery_job_user](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_binding) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L38) | BigQueryでジョブを実行する権限を付与する このロールの権限を持つのは該当サービスアカウントのみになるので注意（既存で権限付与されているものがあるときに剥奪される） なお、このときstate外での差分になるのでplan結果には表示されない |
| resource | [google_service_account.trocco](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/service_account) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L7) | TROCCOで利用するサービスアカウントを作成する Identity and Access Management (IAM) API: iam.googleapis.com |
| resource | [google_storage_bucket.trocco_sample_datasource](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L61) | # ソースデータを格納するバケットを作成する |
| resource | [google_storage_bucket_iam_binding.google_service_account_trocco](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket_iam_binding) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L80) | サービスアカウントにバケットの管理権限を付与する バケット名はプロジェクトによらずグローバルに一意なので、プロジェクトの指定は不要 |
| resource | [google_storage_bucket_object.trocco_sample_datasource](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket_object) | [sample2_intermediate/google/_resources.tf](/sample2_intermediate/google/_resources.tf#L72) | ソースデータとしてファイルを配置する ref: https://www.kaggle.com/competitions/titanic/data?select=train.csv |

<!-- END_TF_DOCS -->