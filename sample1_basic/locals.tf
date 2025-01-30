/*
- 事前準備
*/

# 自分の環境で実行できるよう、ここの変数を調整しておく
locals {
  sample_version = "sample1"
  google = {
    project_id                        = "{YOUR_PROJECT_ID}"
    default_location                  = "asia-northeast1"
    sample_gcs_bucket_name_backend    = "{YOUR_BUCKET_NAME_BACKEND}" # グローバルに一意である必要がある
    sample_gcs_bucket_name_datasource = "{YOUR_BUCKET_NAME_DATASOURCE}"
  }

  # TROCCOのユーザー発行を疑似的に行うため、自分のメールアドレスを記載する
  your_email = "{YOUR_EMAIL}"
}
