variable "sample_version" {
  type        = string
  description = "sample2で作ったリソースだと分かりやすくするための文字列"
}

variable "bigquery_connections" {
  description = "BigQueryの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる"
}

variable "snowflake_connections" {
  description = "Snowflakeの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる"
}
