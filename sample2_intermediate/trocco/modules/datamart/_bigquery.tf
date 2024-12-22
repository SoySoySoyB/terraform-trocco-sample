# 作成した接続情報を利用する
resource "trocco_bigquery_datamart_definition" "dm_trocco_sample__sample" {
  name                     = "dm_trocco_sample__sample"
  is_runnable_concurrently = true
  query_mode               = "insert"
  bigquery_connection_id   = var.bigquery_connections.bigquery_sample_project
  query                    = "select '転送設定を心待ちにしながら、Terraformでデータマートを作ってみよう' as sample_column"
  destination_dataset      = "dm_trocco_sample"
  destination_table        = "dm_trocco_sample__sample"
  write_disposition        = "truncate"
  labels = [
    {
      name = "Terraform Managed"
    }
  ]
}
