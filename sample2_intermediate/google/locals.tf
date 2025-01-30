/*
- 作成者が試したい環境設定を記載する
*/

locals {
  sample_version = "sample2"
  google = {
    sample_project_id                 = "{YOUR_SAMPLE_PROJECT_ID}"
    default_location                  = "asia-northeast1"
    sample_gcs_bucket_name_datasource = "{YOUR_BUCKET_NAME_DATASOURCE}" # グローバルに一意である必要がある
  }
}
