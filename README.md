# terraform-trocco-sample

これはTerraformとTROCCO®を利用する際のサンプルリポジトリです。QiitaにTerraform自体およびリポジトリで提供しているサンプルについての説明があるので、そちらの内容を参考にしていただければと思います。

## sample1_basic

Terraformの基礎から、ローカルでのリソース作成／操作について取り上げています。

- Terraformの概要
- ローカルでのTerraformの利用
- init／plan／apply／destroyおよびstateファイルの操作

[GitHub Actionsを月2,000分動かして学んだTerraform + TROCCO入門　前半：基礎から分かるTerraform](https://qiita.com/SoySoySoyB/items/16ceae5dad35fedad132)

## sample2_intermediate

tfactionを中心とした、CI／CDについてまとめています。

- CI/CDの概要
- GitHub Actionsの設定
- Workload Identity Federationによる認証認可
- plan／applyの運用整備
- 設定のLint／セキュリティチェック
- パッケージのアップデート検知／自動アップデート
- 管理リソースのドキュメント自動生成

[GitHub Actionsを月2,000分動かして学んだTerraform + TROCCO入門　後半：GitHub ActionsでのCI／CD](https://qiita.com/SoySoySoyB/items/05e4d31d3e372790c775)

## sample3_advanced

ひとまずユーザー／チーム管理についてまとめています。

- ユーザーの新規作成
- 部門に応じた権限管理／チームへの登録
- ユーザーの部門変更
- 既存ユーザーの取り込み

[続・Terraform + TROCCO入門　その1: tfmigrateによる既存取込も含めたユーザー／チームの堅牢な管理](https://qiita.com/SoySoySoyB/items/4f64e6dfcf028fae9140)