# 秘密鍵はGUIで登録する
resource "trocco_connection" "snowflake_sample" {
  connection_type = "snowflake"
  name            = "${var.sample_version}_${var.snowflake.account_id}"
  description     = "アカウントID: ${var.snowflake.account_id}に対する接続情報"
  host            = var.snowflake.host
  auth_method     = "key_pair"
  user_name       = var.snowflake.user_name
  private_key     = "-----BEGIN PRIVATE KEY-----\ndummy private key: please replace after creation for not to ingest credential into state file\n-----END PRIVATE KEY-----"
  role            = var.snowflake.default_role
}

resource "trocco_connection" "snowflake_sample2" {
  connection_type = "snowflake"
  name            = "${var.sample_version}_${var.snowflake.account_id}2"
  description     = "アカウントID: ${var.snowflake.account_id}2に対する接続情報"
  host            = "${var.snowflake.host}2"
  auth_method     = "key_pair"
  user_name       = var.snowflake.user_name
  private_key     = "-----BEGIN PRIVATE KEY-----\ndummy private key: please replace after creation for not to ingest credential into state file\n-----END PRIVATE KEY-----"
  role            = var.snowflake.default_role
}

output "snowflake_connections" {
  value = {
    "snowflake_sample"  = trocco_connection.snowflake_sample.id
    "snowflake_sample2" = trocco_connection.snowflake_sample2.id
  }
  description = "Snowflakeの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる"
}
