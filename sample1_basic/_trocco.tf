locals {
  # 疑似的に複数のユーザーを作成するために、エイリアスを追加したメールアドレスを作成する
  # 以下のそれぞれのリストにメールアドレスを追加／削除すると、TROCCO側もユーザーが追加／削除される
  your_email_before_at = split("@", local.your_email)[0]
  your_email_domain    = split("@", local.your_email)[1]
  admins = [
    "${local.your_email_before_at}+admin1@${local.your_email_domain}",
  ]
  developers = [
    "${local.your_email_before_at}+dev1@${local.your_email_domain}",
    "${local.your_email_before_at}+dev2@${local.your_email_domain}",
  ]
  operators = [
    "${local.your_email_before_at}+user1@${local.your_email_domain}",
    "${local.your_email_before_at}+user2@${local.your_email_domain}",
  ]
  users = toset(concat(
    local.admins,
    local.developers,
    local.operators
  ))
}

# ユーザーごとに初期パスワードを生成する
# random_passwordで生成するとsensitive = trueの扱いになってTerraformからの出力では(sensitive value)と表示されるようになるが、stateには平文で残るので注意
resource "random_password" "user_passwords" {
  for_each    = local.users
  length      = 16
  lower       = true
  min_lower   = 2
  upper       = true
  min_upper   = 2
  numeric     = true
  min_numeric = 2
  special     = true
  min_special = 2
}

# 初期パスワードはstateファイルに残ってしまうので、招待後にパスワードを変更してもらうこと
# 特権管理者でないとユーザーの削除ができないので、それで困る場合はコメントアウトする
resource "trocco_user" "users" {
  for_each                        = local.users
  email                           = each.key
  password                        = random_password.user_passwords[each.key].result
  role                            = contains(local.admins, each.key) ? "admin" : "member"
  is_restricted_connection_modify = contains(concat(local.admins, local.developers), each.key) ? false : true
  # 監査ログが使えないアカウントではtrueにするとエラーになる
  # can_use_audit_log               = contains(local.admins, each.key) ? true : false
}

# 生成したサービスアカウント、サービスアカウントキーを利用する
resource "trocco_connection" "bigquery" {
  connection_type          = "bigquery"
  name                     = "${local.google.project_id}__${google_service_account.trocco.email}"
  description              = "プロジェクト${local.google.project_id}に対してサービスアカウントの${google_service_account.trocco.email}で接続するための接続情報"
  project_id               = local.google.project_id
  service_account_json_key = base64decode(google_service_account_key.trocco.private_key)
}

# 転送設定のリソースは現在開発中で、近日中にリリース予定
# resource "trocco_job_definition"? "dl_trocco_sample__sample" {
# }

# 作成した接続情報を利用する
resource "trocco_bigquery_datamart_definition" "dm_trocco_sample__sample" {
  name                     = "dm_trocco_sample__sample"
  is_runnable_concurrently = true
  query_mode               = "insert"
  bigquery_connection_id   = trocco_connection.bigquery.id
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
