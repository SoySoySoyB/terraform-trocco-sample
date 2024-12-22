# terraform-trocco-sample

これはTerraformとTROCCO®を利用する際のサンプルリポジトリです。QiitaにTerraform自体およびリポジトリで提供しているサンプルについての説明があるので、そちらの内容を参考にしていただければと思います。

## sample1_basic

Terraformの基礎から、ローカルでのリソース作成／操作について取り上げています。

- Terraformの概要
- ローカルでのTerraformの利用
- init／plan／apply／destroyおよびstateファイルの操作


## sample2_intermediate

tfactionを中心とした、CI／CDについてまとめています。

- CI/CDの概要
- GitHub Actionsの設定
- Workload Identity Federationによる認証認可
- plan／applyの運用整備
- 設定のLint／セキュリティチェック
- パッケージのアップデート検知／自動アップデート
- 管理リソースのドキュメント自動生成