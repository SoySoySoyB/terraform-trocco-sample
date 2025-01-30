<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | 1.9.8 |
| google | 6.14.0 |
| random | 3.6.3 |
| trocco | 0.2.1 |

## Providers

| Name | Version | Alias |
| ---- | ------- | ----- |
| google | 6.14.0 | n/a |
| random | 3.6.3 | n/a |
| trocco | 0.2.1 | n/a |

## Resources

| Type | Name | File | Comment |
| ------------ | ---- | ---- | ------- |
| resource | [google_bigquery_dataset.dl_trocco_sample](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/bigquery_dataset) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L41) | 転送設定からテーブルを作成するデータセットを作成する BigQuery API: bigquery.googleapis.com |
| resource | [google_bigquery_dataset.dm_trocco_sample](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/bigquery_dataset) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L50) | データマート定義からテーブルを作成するデータセットを作成する BigQuery API: bigquery.googleapis.com |
| resource | [google_project_iam_member.bigquery_data_editor](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_member) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L67) | BigQueryでジョブを実行する権限を付与する Cloud Resource Manager API: cloudresourcemanager.googleapis.com |
| resource | [google_project_iam_member.bigquery_job_user](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/project_iam_member) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L59) | BigQueryでジョブを実行する権限を付与する Cloud Resource Manager API: cloudresourcemanager.googleapis.com |
| resource | [google_service_account.trocco](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/service_account) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L20) | TROCCOで利用するサービスアカウントを作成する Identity and Access Management (IAM) API: iam.googleapis.com |
| resource | [google_service_account_key.trocco](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/service_account_key) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L30) | サービスアカウントのキーを生成する サンプルなのでキーを生成するが、秘密鍵がstateファイルに平文で入ってしまうため本運用では非推奨 IAM Service Account Credentials API: iamcredentials.googleapis.com |
| resource | [google_storage_bucket.trocco_sample](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L100) | 後でバックエンドを移してみるときに利用するバケットを作成する Cloud Storage API: storage.googleapis.com |
| resource | [google_storage_bucket.trocco_sample_datasource](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L80) | ソースデータを格納するバケットを作成する Cloud Storage API: storage.googleapis.com |
| resource | [google_storage_bucket_iam_member.google_service_account_trocco](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket_iam_member) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L111) | サービスアカウントにバケットの管理権限を付与する バケット名はプロジェクトによらずグローバルに一意なので、プロジェクトの指定は不要 |
| resource | [google_storage_bucket_object.trocco_sample_datasource](https://registry.terraform.io/providers/hashicorp/google/6.14.0/docs/resources/storage_bucket_object) | [sample1_basic/_google.tf](/sample1_basic/_google.tf#L92) | ソースデータとしてファイルを配置する Cloud Storage API: storage.googleapis.com ref: https://www.kaggle.com/competitions/titanic/data?select=train.csv |
| resource | [random_password.user_passwords](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) | [sample1_basic/_trocco.tf](/sample1_basic/_trocco.tf#L27) | ユーザーごとに初期パスワードを生成する random_passwordで生成するとsensitive = trueの扱いになってTerraformからの出力では(sensitive value)と表示されるようになるが、stateには平文で残るので注意 |
| resource | [trocco_bigquery_datamart_definition.dm_trocco_sample__sample](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample1_basic/_trocco.tf](/sample1_basic/_trocco.tf#L65) | 作成した接続情報を利用する |
| resource | [trocco_connection.bigquery](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample1_basic/_trocco.tf](/sample1_basic/_trocco.tf#L53) | 生成したサービスアカウント、サービスアカウントキーを利用する |
| resource | [trocco_user.users](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample1_basic/_trocco.tf](/sample1_basic/_trocco.tf#L43) | 初期パスワードはstateファイルに残ってしまうので、招待後にパスワードを変更してもらうこと 特権管理者でないとユーザーの削除ができないので、それで困る場合はコメントアウトする 監査ログが使えないアカウントでは、can_use_audit_logをtrueにするとエラーになる |

<!-- END_TF_DOCS -->