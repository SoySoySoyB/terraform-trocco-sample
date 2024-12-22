/*
- データ転送／データマート作成で使うサービスアカウントを作成する
*/

# TROCCOで利用するサービスアカウントを作成する
# Identity and Access Management (IAM) API: iam.googleapis.com
resource "google_service_account" "trocco" {
  project      = local.google.sample_project_id
  account_id   = "trocco"
  display_name = "TROCCO"
  description  = "TROCCOの接続で利用するためのサービスアカウント"
}


/*
- BigQueryのデータセットの作成とサービスアカウントへの権限付与
*/

# 転送設定からテーブルを作成するデータセットを作成する
resource "google_bigquery_dataset" "dl_trocco_sample" {
  project     = local.google.sample_project_id
  dataset_id  = "dl_trocco_sample"
  location    = local.google.default_location
  description = "データレイク層のテーブルを作成するためのデータセット"
}

# データマート定義からテーブルを作成するデータセットを作成する
resource "google_bigquery_dataset" "dm_trocco_sample" {
  project     = local.google.sample_project_id
  dataset_id  = "dm_trocco_sample"
  location    = local.google.default_location
  description = "データマート層のテーブルを作成するためのデータセット"
}

# BigQueryでジョブを実行する権限を付与する
# このロールの権限を持つのは該当サービスアカウントのみになるので注意（既存で権限付与されているものがあるときに剥奪される）
# なお、このときstate外での差分になるのでplan結果には表示されない
resource "google_project_iam_binding" "bigquery_job_user" {
  project = local.google.sample_project_id
  role    = "roles/bigquery.jobUser"
  members = [
    google_service_account.trocco.member
  ]
}

# BigQueryでジョブを実行する権限を付与する
resource "google_project_iam_binding" "bigquery_data_editor" {
  project = local.google.sample_project_id
  role    = "roles/bigquery.dataEditor"
  members = [
    google_service_account.trocco.member
  ]
}


/*
- Google Cloud Storageのバケットの作成とサービスアカウントへの権限付与
*/

# # ソースデータを格納するバケットを作成する
resource "google_storage_bucket" "trocco_sample_datasource" {
  project                     = local.google.sample_project_id
  name                        = local.google.sample_gcs_bucket_name_datasource
  location                    = local.google.default_location
  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
}

# ソースデータとしてファイルを配置する
# ref: https://www.kaggle.com/competitions/titanic/data?select=train.csv
resource "google_storage_bucket_object" "trocco_sample_datasource" {
  name    = "titanic_train.csv"
  bucket  = google_storage_bucket.trocco_sample_datasource.name
  content = file("./train.csv")
}

# サービスアカウントにバケットの管理権限を付与する
# バケット名はプロジェクトによらずグローバルに一意なので、プロジェクトの指定は不要
resource "google_storage_bucket_iam_binding" "google_service_account_trocco" {
  bucket = google_storage_bucket.trocco_sample_datasource.name
  role   = "roles/storage.admin"
  members = [
    google_service_account.trocco.member,
  ]
}
