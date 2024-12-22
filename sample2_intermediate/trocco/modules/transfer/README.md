<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | 1.9.8 |
| trocco | 0.2.1 |

## Inputs

| Name | description | Type | Required | Default | File |
| ---- | ----------- | ---- | -------- | ------- | ---- |
| bigquery_connections | BigQueryの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる | `any` | yes | n/a | [sample2_intermediate/trocco/modules/transfer/variables.tf](/sample2_intermediate/trocco/modules/transfer/variables.tf#L1) |
| snowflake_connections | Snowflakeの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる | `any` | yes | n/a | [sample2_intermediate/trocco/modules/transfer/variables.tf](/sample2_intermediate/trocco/modules/transfer/variables.tf#L5) |

<!-- END_TF_DOCS -->