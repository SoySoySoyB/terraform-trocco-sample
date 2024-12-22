<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | 1.9.8 |
| trocco | 0.2.1 |

## Providers

| Name | Version | Alias |
| ---- | ------- | ----- |
| trocco | 0.2.1 | n/a |

## Inputs

| Name | description | Type | Required | Default | File |
| ---- | ----------- | ---- | -------- | ------- | ---- |
| google | Googleの設定情報 | `map(string)` | yes | n/a | [sample2_intermediate/trocco/modules/connection/variables.tf](/sample2_intermediate/trocco/modules/connection/variables.tf#L1) |
| snowflake | Snowflakeの設定情報 | `map(string)` | yes | n/a | [sample2_intermediate/trocco/modules/connection/variables.tf](/sample2_intermediate/trocco/modules/connection/variables.tf#L6) |

## Resources

| Type | Name | File | Comment |
| ------------ | ---- | ---- | ------- |
| resource | [trocco_connection.bigquery_sample_project](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample2_intermediate/trocco/modules/connection/_bigquery.tf](/sample2_intermediate/trocco/modules/connection/_bigquery.tf#L3) | サンプルのBigQUery接続情報その1 JSON Keyは別途作成してGUIで登録する |
| resource | [trocco_connection.bigquery_sample_project2](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample2_intermediate/trocco/modules/connection/_bigquery.tf](/sample2_intermediate/trocco/modules/connection/_bigquery.tf#L25) | サンプルのBigQUery接続情報その2 |
| resource | [trocco_connection.snowflake_sample](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample2_intermediate/trocco/modules/connection/_snowflake.tf](/sample2_intermediate/trocco/modules/connection/_snowflake.tf#L2) | 秘密鍵はGUIで登録する |
| resource | [trocco_connection.snowflake_sample2](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample2_intermediate/trocco/modules/connection/_snowflake.tf](/sample2_intermediate/trocco/modules/connection/_snowflake.tf#L13) |  |

## Outputs

| Name | Description | isSensitive | File |
| ---- | ----------- | ----------- | ---- |
| bigquery_connections | BigQueryの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる | no | [sample2_intermediate/trocco/modules/connection/_bigquery.tf](/sample2_intermediate/trocco/modules/connection/_bigquery.tf#L33) |
| snowflake_connections | Snowflakeの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる | no | [sample2_intermediate/trocco/modules/connection/_snowflake.tf](/sample2_intermediate/trocco/modules/connection/_snowflake.tf#L24) |

<!-- END_TF_DOCS -->