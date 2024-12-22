/*
- 注：以下のリソースの操作はAPIが有効化されていないと使えないので、事前に有効化しておく
  - コンソールの場合
    - https://console.cloud.google.com/apis/dashboard
  - CLIの場合
    - gcloud config set project {プロジェクトID}
    - gcloud services enable {APIのドメイン; ex. iam.googleapis.com}
  - 有効化されているAPIは、gcloud services listで確認できる
  - なお、APIの有効化のためのモジュールがあるが、今回は利用しない
    - https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
*/


/*
- 転送設定／データマート定義で使うサービスアカウントを作成する
*/

# TROCCOで利用するサービスアカウントを作成する
# Identity and Access Management (IAM) API: iam.googleapis.com
resource "google_service_account" "trocco" {
  project      = local.google.project_id
  account_id   = "trocco-sample"
  display_name = "TROCCO Sample"
  description  = "TROCCOの接続で利用するためのサービスアカウント"
}

# サービスアカウントのキーを生成する
# サンプルなのでキーを生成するが、秘密鍵がstateファイルに平文で入ってしまうため本運用では非推奨
# IAM Service Account Credentials API: iamcredentials.googleapis.com
resource "google_service_account_key" "trocco" {
  service_account_id = google_service_account.trocco.name
}


/*
- BigQueryのデータセットの作成とサービスアカウントへの権限付与
*/

# 転送設定からテーブルを作成するデータセットを作成する
# BigQuery API: bigquery.googleapis.com
resource "google_bigquery_dataset" "dl_trocco_sample" {
  project     = local.google.project_id
  dataset_id  = "dl_trocco_sample"
  location    = local.google.default_location
  description = "データレイク層のテーブルを作成するためのデータセット"
}

# データマート定義からテーブルを作成するデータセットを作成する
# BigQuery API: bigquery.googleapis.com
resource "google_bigquery_dataset" "dm_trocco_sample" {
  project     = local.google.project_id
  dataset_id  = "dm_trocco_sample"
  location    = local.google.default_location
  description = "データマート層のテーブルを作成するためのデータセット"
}

# BigQueryでジョブを実行する権限を付与する
# Cloud Resource Manager API: cloudresourcemanager.googleapis.com
resource "google_project_iam_member" "bigquery_job_user" {
  project = local.google.project_id
  role    = "roles/bigquery.jobUser"
  member  = google_service_account.trocco.member
}

# BigQueryでジョブを実行する権限を付与する
# Cloud Resource Manager API: cloudresourcemanager.googleapis.com
resource "google_project_iam_member" "bigquery_data_editor" {
  project = local.google.project_id
  role    = "roles/bigquery.dataEditor"
  member  = google_service_account.trocco.member
}


/*
- Google Cloud Storageのバケットの作成とサービスアカウントへの権限付与
*/

# ソースデータを格納するバケットを作成する
# Cloud Storage API: storage.googleapis.com
resource "google_storage_bucket" "trocco_sample_datasource" {
  project                     = local.google.project_id
  name                        = local.google.sample_gcs_bucket_name_datasource
  location                    = local.google.default_location
  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
}

# ソースデータとしてファイルを配置する
# Cloud Storage API: storage.googleapis.com
# ref: https://www.kaggle.com/competitions/titanic/data?select=train.csv
resource "google_storage_bucket_object" "trocco_sample_datasource" {
  name    = "titanic_train.csv"
  bucket  = google_storage_bucket.trocco_sample_datasource.name
  content = file("./train.csv")
}

# 後でバックエンドを移してみるときに利用するバケットを作成する
# Cloud Storage API: storage.googleapis.com
resource "google_storage_bucket" "trocco_sample" {
  project                     = local.google.project_id
  name                        = local.google.sample_gcs_bucket_name_backend
  location                    = local.google.default_location
  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
}

# サービスアカウントにバケットの管理権限を付与する
# バケット名はプロジェクトによらずグローバルに一意なので、プロジェクトの指定は不要
resource "google_storage_bucket_iam_member" "google_service_account_trocco" {
  bucket = google_storage_bucket.trocco_sample.name
  role   = "roles/storage.admin"
  member = google_service_account.trocco.member
}
