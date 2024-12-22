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
| bigquery_connections | BigQueryの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる | `any` | yes | n/a | [sample2_intermediate/trocco/modules/datamart/variables.tf](/sample2_intermediate/trocco/modules/datamart/variables.tf#L1) |
| snowflake_connections | Snowflakeの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる | `any` | yes | n/a | [sample2_intermediate/trocco/modules/datamart/variables.tf](/sample2_intermediate/trocco/modules/datamart/variables.tf#L5) |

## Resources

| Type | Name | File | Comment |
| ------------ | ---- | ---- | ------- |
| resource | [trocco_bigquery_datamart_definition.dm_trocco_sample__sample](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample2_intermediate/trocco/modules/datamart/_bigquery.tf](/sample2_intermediate/trocco/modules/datamart/_bigquery.tf#L2) | 作成した接続情報を利用する |

<!-- END_TF_DOCS -->