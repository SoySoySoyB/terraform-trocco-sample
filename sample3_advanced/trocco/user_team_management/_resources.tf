/*
- ユーザーリストを記載する
*/

# サンプルユーザーの作成のため、自分のメールアドレスにエイリアスを付与してアドレスを生成する
locals {
  sample_label         = "sample3"
  your_email           = "{YOUR_EMAIL}"
  your_email_before_at = split("@", local.your_email)[0]
  your_email_domain    = split("@", local.your_email)[1]

  # チーム追加前にメールアドレスの認証が必要なので、ユーザーを追加する際はまずここに追加して、移動する
  newly_created_users = [
    "${local.your_email_before_at}+${local.sample_label}_marketing__manager@${local.your_email_domain}",
    "${local.your_email_before_at}+${local.sample_label}_marketing__member@${local.your_email_domain}",
    "${local.your_email_before_at}+${local.sample_label}_product__manager@${local.your_email_domain}",
    "${local.your_email_before_at}+${local.sample_label}_product__member@${local.your_email_domain}",
    "${local.your_email_before_at}+${local.sample_label}_data_management__manager@${local.your_email_domain}",
    "${local.your_email_before_at}+${local.sample_label}_data_management__member@${local.your_email_domain}",
  ]

  # 既存ユーザーの取込時には以下にメールアドレスを記載しつつ、./state_operation/script/state_operation.ipynbを実行して生成されたファイルを./state_operation/tfmigrateに配置する
  imported_users = [
  ]
  imported_super_admin_user = [
  ]
  imported_admin_users = [
  ]
  imported_connection_modify_not_restricted_users = [
  ]

  # ここからチームを生成／登録するための階層管理のための設定
  super_admin_user = ""
  departments = {
    marketing = {
      department_name_ja = "マーケティング本部"
      managers = [
        # "${local.your_email_before_at}+${local.sample_label}_marketing__manager@${local.your_email_domain}",
      ],
      members = [
        # "${local.your_email_before_at}+${local.sample_label}_marketing__member@${local.your_email_domain}",
      ],
    }
    product = {
      department_name_ja = "プロダクト本部"
      managers = [
        # "${local.your_email_before_at}+${local.sample_label}_product__manager@${local.your_email_domain}",
      ],
      members = [
        # "${local.your_email_before_at}+${local.sample_label}_product__member@${local.your_email_domain}",
      ],
    }
    data_management = {
      department_name_ja = "データマネジメント本部"
      managers = [
        # "${local.your_email_before_at}+${local.sample_label}_data_management__manager@${local.your_email_domain}",
      ],
      members = [
        # "${local.your_email_before_at}+${local.sample_label}_data_management__member@${local.your_email_domain}",
      ],
    }
  }
  # 部門とは別に技術担当者が存在している想定
  technical_admins = [
    # "${local.your_email_before_at}+${local.sample_label}_product__member@${local.your_email_domain}",
  ]
  # 部門ごとのマネージャー／メンバーを問わない所属者一覧
  department_users = {
    for department_name, role_members in local.departments :
    department_name => toset(concat(role_members.managers, role_members.members))
  }
  # 部門を問わないマネージャー一覧
  managers = flatten([
    for department_key, department in local.departments :
    department.managers
  ])
  # 部門を問わないメンバー一覧
  members = flatten([
    for department_key, department in local.departments :
    department.members
  ])
  # 上記のマネージャー／メンバーに加えて、新規追加者／既存取込者を追加
  users = toset(concat(
    local.managers,
    local.members,
    local.newly_created_users,
    local.imported_users,
  ))
  # マネージャーおよび技術管理者にアカウントの管理権限を付与する
  admins = toset(concat(
    tolist(local.managers),
    tolist(local.technical_admins)
  ))
  # 上記に加えてデータマネジメントチームに接続情報の作成権限を付与する
  connection_managers = toset(concat(
    tolist(local.admins),
    tolist(local.department_users.data_management)
  ))
  # チームに登録するための、ユーザーごとのEmailに対するユーザーIDの一覧を作成
  user_email_ids = { for email, user in trocco_user.users : email => user.id }
}


/*
- ユーザーを作成する
*/

# 初期パスワードはstateファイルに残ってしまうので、招待後にパスワードを変更してもらうこと
# 特権管理者でないとユーザーの削除ができないので、それで困る場合はコメントアウトする
# 監査ログが使えないアカウントでは、can_use_audit_logをtrueにするとエラーになる
resource "trocco_user" "users" {
  for_each = local.users
  email    = each.key
  password = contains(local.newly_created_users, each.key) ? random_password.newly_created_user_passwords[each.key].result : "Th1s_1s_Dummy_Passw0rd!"
  role    = (contains(toset(concat(local.imported_super_admin_user, [local.super_admin_user])), each.key) ? "super_admin" :
             contains(toset(concat(local.imported_admin_users, tolist(local.admins))), each.key) ? "admin" : "member")
  is_restricted_connection_modify = (contains(toset(concat(local.imported_connection_modify_not_restricted_users, tolist(local.connection_managers))), each.key) ? false : true)
  can_use_audit_log               = false # (contains(toset(concat(local.imported_can_use_audit_log_users, local.departments.data_management.managers)), each.key) ? true : false)
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}

# 新規ユーザー用にパスワードを生成する
# random_passwordで生成するとsensitive = trueの扱いになってTerraformからの出力では(sensitive value)と表示されるが、stateには初期パスワードが平文で残るので注意
resource "random_password" "newly_created_user_passwords" {
  for_each    = toset(local.newly_created_users)
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


/*
- チームを作成する
*/

# # 部門マネージャー＋技術管理者による部門ごとの管理者チームを生成
# # メールアドレスの認証前にはチームを作成できないので注意
# resource "trocco_team" "department_managers" {
#   for_each = local.departments
#   name     = "${local.departments[each.key].department_name_ja} 管理者"
#   members = concat(
#     [
#       for email in each.value["managers"] : {
#         user_id = local.user_email_ids[email],
#         role    = "team_admin"
#       }
#       ], [
#       for email in local.technical_admins : {
#         user_id = local.user_email_ids[email],
#         role    = "team_admin"
#       }
#     ]
#   )
#   depends_on = [
#     trocco_user.users
#   ]
# }

# # 部門マネージャー＋技術管理者をチーム管理者／部門メンバーをチームメンバーとした部門ごとのメンバーチームを生成
# resource "trocco_team" "department_members" {
#   for_each = local.departments
#   name     = "${local.departments[each.key].department_name_ja} メンバー"
#   members = concat(
#     [
#       for email in each.value["managers"] : {
#         user_id = local.user_email_ids[email],
#         role    = "team_admin"
#       }
#     ],
#     [
#       for email in local.technical_admins : {
#         user_id = local.user_email_ids[email],
#         role    = "team_admin"
#       }
#     ],
#     [
#       for email in each.value["members"] : {
#         user_id = local.user_email_ids[email],
#         role    = "team_member"
#       } if !contains(local.technical_admins, email)
#     ]
#   )
#   depends_on = [
#     trocco_user.users
#   ]
# }
