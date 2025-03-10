terraform {
  required_providers {
    trocco = {
      source  = "registry.terraform.io/trocco-io/trocco"
      version = "0.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
  # バックエンドとして作成したバケットを指定する
  backend "gcs" {
    bucket = "{YOUR_BUCKET_NAME_BACKEND}"
    prefix = "sample3_advanced/trocco/user_team_management"
  }
}
