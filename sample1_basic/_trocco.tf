locals {
  # 疑似的に複数のユーザーを作成するために、エイリアスを追加したメールアドレスを作成する
  # 以下のそれぞれのリストにメールアドレスを追加／削除すると、TROCCO側もユーザーが追加／削除される
  your_email_before_at = split("@", local.your_email)[0]
  your_email_domain    = split("@", local.your_email)[1]
  admins = [
    "${local.your_email_before_at}+${local.sample_version}_admin1@${local.your_email_domain}",
  ]
  developers = [
    "${local.your_email_before_at}+${local.sample_version}_dev1@${local.your_email_domain}",
    "${local.your_email_before_at}+${local.sample_version}_dev2@${local.your_email_domain}",
  ]
  operators = [
    "${local.your_email_before_at}+${local.sample_version}_user1@${local.your_email_domain}",
    "${local.your_email_before_at}+${local.sample_version}_user2@${local.your_email_domain}",
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
# 監査ログが使えないアカウントでは、can_use_audit_logをtrueにするとエラーになる
resource "trocco_user" "users" {
  for_each                        = local.users
  email                           = each.key
  password                        = random_password.user_passwords[each.key].result
  role                            = contains(local.admins, each.key) ? "admin" : "member"
  is_restricted_connection_modify = contains(concat(local.admins, local.developers), each.key) ? false : true
  # can_use_audit_log               = contains(local.admins, each.key) ? true : false
}

# 生成したサービスアカウント、サービスアカウントキーを利用する
resource "trocco_connection" "bigquery" {
  connection_type          = "bigquery"
  name                     = "${local.sample_version}_${local.google.project_id}__${google_service_account.trocco.email}"
  description              = "プロジェクト${local.google.project_id}に対してサービスアカウントの${google_service_account.trocco.email}で接続するための接続情報"
  project_id               = local.google.project_id
  service_account_json_key = base64decode(google_service_account_key.trocco.private_key)
}

# 転送設定のリソースは後日紹介します

# 作成した接続情報を利用する
# ラベルは事前に作成しておく必要がある
resource "trocco_bigquery_datamart_definition" "dm_trocco_sample__sample" {
  name                     = "dm_trocco_sample__${local.sample_version}"
  bigquery_connection_id   = trocco_connection.bigquery.id
  query                    = "select 'sample' as sample_column"
  destination_dataset      = "dm_trocco_sample"
  destination_table        = "dm_trocco_sample__${local.sample_version}"
  query_mode               = "insert"
  write_disposition        = "truncate"
  is_runnable_concurrently = true
  labels = [
    {
      name = "Terraform Managed"
    },
    {
      name = "${local.sample_version}"
    }
  ]
}
