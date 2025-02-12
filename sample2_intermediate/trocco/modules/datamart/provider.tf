# 公式プロバイダー以外はmodule側にもプロバイダー定義が必要になる
terraform {
  required_version = "1.9.8"
  required_providers {
    trocco = {
      source  = "registry.terraform.io/trocco-io/trocco"
      version = "0.6.0"
    }
  }
}
