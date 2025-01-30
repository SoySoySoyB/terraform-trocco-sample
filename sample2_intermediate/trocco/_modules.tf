# アカウント管理系のリソース
module "account_management" {
  source = "./modules/account_management"
  providers = {
    trocco = trocco
  }
  sample_version = local.sample_version
  your_email     = local.your_email
}

# 接続情報
module "connection" {
  source = "./modules/connection"
  providers = {
    trocco = trocco
  }
  sample_version = local.sample_version
  google         = local.google
  snowflake      = local.snowflake
}

# 転送設定
# 接続情報はここで連携するよう設定する
module "transfer" {
  source = "./modules/transfer"
  providers = {
    trocco = trocco
  }
  sample_version        = local.sample_version
  bigquery_connections  = module.connection.bigquery_connections
  snowflake_connections = module.connection.bigquery_connections
}

# データマート定義
# 接続情報はここで連携するよう設定する
module "datamart" {
  source = "./modules/datamart"
  providers = {
    trocco = trocco
  }
  sample_version        = local.sample_version
  bigquery_connections  = module.connection.bigquery_connections
  snowflake_connections = module.connection.bigquery_connections
}
