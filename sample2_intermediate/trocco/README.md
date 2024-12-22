<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | 1.9.8 |
| trocco | 0.2.1 |

## Modules

| Name | Source | Version | File | Comment |
| ---- | ------ | ------- | ---- | ------- |
| account_management | [./modules/account_management](./modules/account_management) | n/a | [sample2_intermediate/trocco/_modules.tf](/sample2_intermediate/trocco/_modules.tf#L2) | アカウント管理系のリソース
| connection | [./modules/connection](./modules/connection) | n/a | [sample2_intermediate/trocco/_modules.tf](/sample2_intermediate/trocco/_modules.tf#L11) | 接続情報
| datamart | [./modules/datamart](./modules/datamart) | n/a | [sample2_intermediate/trocco/_modules.tf](/sample2_intermediate/trocco/_modules.tf#L33) | データマート定義 接続情報はここで連携するよう設定する
| transfer | [./modules/transfer](./modules/transfer) | n/a | [sample2_intermediate/trocco/_modules.tf](/sample2_intermediate/trocco/_modules.tf#L22) | 転送設定 接続情報はここで連携するよう設定する

<!-- END_TF_DOCS -->