/*
- アカウント設定／ユーザー／チーム／リソースグループの管理を想定
*/


/*
- ユーザーリストを記載する
*/

# サンプルユーザーの作成のため、自分のメールアドレスにエイリアスを付与してアドレスを生成する
locals {
  # 疑似的に複数のユーザーを作成するために、エイリアスを追加したメールアドレスを作成する
  # 以下のそれぞれのリストにメールアドレスを追加／削除すると、TROCCO側もユーザーが追加／削除される
  # 参考までにsample1よりも複雑な構成にしている
  your_email_before_at = split("@", var.your_email)[0]
  your_email_domain    = split("@", var.your_email)[1]
  super_admin          = "${local.your_email_before_at}+super_admin@${local.your_email_domain}"
  departments = {
    marketing = {
      managers = [
        "${local.your_email_before_at}+marketing__manager@${local.your_email_domain}"
      ],
      members = [
        "${local.your_email_before_at}+marketing__member@${local.your_email_domain}"
      ]
    },
    sales = {
      managers = [
        "${local.your_email_before_at}+sales__manager@${local.your_email_domain}"
      ],
      members = [
        "${local.your_email_before_at}+sales__member@${local.your_email_domain}"
      ]
    },
    product = {
      managers = [
        "${local.your_email_before_at}+product__manager@${local.your_email_domain}"
      ],
      members = [
        "${local.your_email_before_at}+product__member@${local.your_email_domain}"
      ]
    },
    corporate = {
      managers = [
        "${local.your_email_before_at}+corporate__manager@${local.your_email_domain}"
      ],
      members = [
        "${local.your_email_before_at}+corporate__member@${local.your_email_domain}"
      ]
    },
    data_management = {
      managers = [
        "${local.your_email_before_at}+data_management__manager@${local.your_email_domain}"
      ],
      members = [
        "${local.your_email_before_at}+data_management__member@${local.your_email_domain}"
      ]
    },
    technical_admins = {
      managers = [],
      members = [
        "${local.your_email_before_at}+technical_admin__member@${local.your_email_domain}"
      ]
    }
  }
  department_users = {
    for department_name, role_members in local.departments :
    department_name => toset(concat(role_members.managers, role_members.members))
  }
  managers = flatten([
    for department_key, department in local.departments :
    department.managers
  ])
  members = flatten([
    for department_key, department in local.departments :
    department.members
  ])
  users = toset(concat(
    local.managers,
    local.members
  ))
  admins = toset(concat(
    tolist(local.managers),
    tolist(local.department_users.technical_admins)
  ))
  connection_managers = toset(concat(
    tolist(local.admins),
    tolist(local.department_users.data_management)
  ))
}


/*
- ユーザーを作成する
*/

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

# for_eachを使ってユーザーをまとめて生成する
# 初期パスワードはstateファイルに残ってしまうので、招待後にパスワードを変更してもらうこと
# 特権管理者でないとユーザーの削除ができないので、それで困る場合はコメントアウトする
resource "trocco_user" "users" {
  for_each                        = local.users
  email                           = each.key
  password                        = random_password.user_passwords[each.key].result
  role                            = contains(local.admins, each.key) ? "admin" : "member"
  is_restricted_connection_modify = contains(local.connection_managers, each.key) ? false : true
  # 監査ログが使えないアカウントではtrueにするとエラーになる
  # can_use_audit_log              = contains(local.departments.technical_admins.managers, each.key) ? true : false
}
