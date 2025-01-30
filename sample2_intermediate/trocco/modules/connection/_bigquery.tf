# サンプルのBigQUery接続情報その1
# JSON Keyは別途作成してGUIで登録する
resource "trocco_connection" "bigquery_sample_project" {
  connection_type = "bigquery"
  name            = "${var.sample_version}_${var.google.sample_project_id}__trocco@${var.google.sample_project_id}.iam.gserviceaccount.com"
  description     = "プロジェクト${var.google.sample_project_id}に対してサービスアカウントtrocco@${var.google.sample_project_id}.iam.gserviceaccount.comで接続するときの接続情報"
  project_id      = var.google.sample_project_id
  service_account_json_key = jsonencode(
    {
      project_id = "${var.google.sample_project_id}"
      info       = "dummy json key: please replace after creation for not to ingest credential into state file"
    }
  )
}

# 今回は利用しないが、dataブロックを利用することで読み取り専用でリソースを利用できる
# 将来的に1.10.0から導入されたephemeralリソースを利用して、ここからKEYを発行する形にすると良さそうに考えている
# data "google_service_account" "trocco" {
#   account_id = "projects/${var.google.sample_project_id}/serviceAccounts/trocco@${var.google.sample_project_id}.iam.gserviceaccount.com"
# }

# サービスアカウントのキーを生成する
# サンプルなのでキーを生成するが、秘密鍵がstateファイルに平文で入ってしまうため本運用では非推奨
# IAM Service Account Credentials API: iamcredentials.googleapis.com
# resource "google_service_account_key" "trocco" {
#   service_account_id = google_service_account.trocco.name
# }

# サンプルのBigQUery接続情報その2
resource "trocco_connection" "bigquery_sample_project2" {
  connection_type = "bigquery"
  name            = "${var.sample_version}_${var.google.sample_project_id}2__trocco@${var.google.sample_project_id}2.iam.gserviceaccount.com"
  description     = "プロジェクト${var.google.sample_project_id}2に対してサービスアカウントtrocco@${var.google.sample_project_id}2.iam.gserviceaccount.comで接続するときの接続情報"
  project_id      = "${var.google.sample_project_id}2"
  service_account_json_key = jsonencode(
    {
      project_id = "${var.google.sample_project_id}2"
      info       = "dummy json key: please replace after creation for not to ingest credential into state file"
    }
  )
}

output "bigquery_connections" {
  value = {
    "bigquery_sample_project"  = trocco_connection.bigquery_sample_project.id
    "bigquery_sample_project2" = trocco_connection.bigquery_sample_project2.id
  }
  description = "BigQueryの接続情報のID一覧：リソース名＝IDの形になっているので、リソース名を指定することで接続情報のIDが特定できる"
}
