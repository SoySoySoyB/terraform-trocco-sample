/*
- 作成者が試したい環境設定を記載する
*/

locals {
  sample_version = "sample2"
  google = {
    sample_project_id = "{YOUR_SAMPLE_PROJECT_ID}"
    default_location  = "asia-northeast1"
  }
  snowflake = {
    account_id   = "dummy_account_id"
    host         = "dummy.********.********.********.snowflakecomputing.com"
    user_name    = "TROCCO_USER_DUMMY"
    default_role = "TROCCO_ROLE_DUMMY"
  }

  # エイリアスを使ってTROCCOの複数のユーザー発行を疑似的に行うため、自分のメールアドレスを記載する
  your_email = "{YOUR_EMAIL}"
}
