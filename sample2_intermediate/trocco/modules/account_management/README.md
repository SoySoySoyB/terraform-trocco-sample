<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | 1.9.8 |
| trocco | 0.2.1 |

## Providers

| Name | Version | Alias |
| ---- | ------- | ----- |
| random | n/a | n/a |
| trocco | 0.2.1 | n/a |

## Inputs

| Name | description | Type | Required | Default | File |
| ---- | ----------- | ---- | -------- | ------- | ---- |
| your_email | エイリアスを使ってダミーユーザーを生成するときのベースとするメールアドレス | `string` | yes | n/a | [sample2_intermediate/trocco/modules/account_management/variables.tf](/sample2_intermediate/trocco/modules/account_management/variables.tf#L1) |

## Resources

| Type | Name | File | Comment |
| ------------ | ---- | ---- | ------- |
| resource | [random_password.user_passwords](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | [sample2_intermediate/trocco/modules/account_management/_resources.tf](/sample2_intermediate/trocco/modules/account_management/_resources.tf#L99) | ユーザーごとに初期パスワードを生成する random_passwordで生成するとsensitive = trueの扱いになってTerraformからの出力では(sensitive value)と表示されるようになるが、stateには平文で残るので注意 |
| resource | [trocco_user.users](https://registry.terraform.io/providers/trocco-io/trocco/0.2.1/docs/) | [sample2_intermediate/trocco/modules/account_management/_resources.tf](/sample2_intermediate/trocco/modules/account_management/_resources.tf#L115) | for_eachを使ってユーザーをまとめて生成する 初期パスワードはstateファイルに残ってしまうので、招待後にパスワードを変更してもらうこと 特権管理者でないとユーザーの削除ができないので、それで困る場合はコメントアウトする |

<!-- END_TF_DOCS -->