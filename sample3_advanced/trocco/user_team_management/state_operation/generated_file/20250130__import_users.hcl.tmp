# tfmigrateでユーザーをまとめてimportするための定義；ファイル名末尾の.tmpを削除してtfmigrateディレクトリに配置することで処理可能になる
migration "state" "import_users" {
  actions = [
    "import trocco_user.users[\\\"your.mail+dummy1@example.com\\\"] 1",
    "import trocco_user.users[\\\"your.mail+dummy2@example.com\\\"] 2",
    "import trocco_user.users[\\\"your.mail+dummy3@example.com\\\"] 3",
    "import trocco_user.users[\\\"your.mail+dummy4@example.com\\\"] 4",
  ]
}
