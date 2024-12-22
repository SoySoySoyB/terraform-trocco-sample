terraform {
  required_providers {
    trocco = {
      source  = "registry.terraform.io/trocco-io/trocco"
      version = "0.2.1"
    }
  }
  # バックエンドとして作成したバケットを指定する
  backend "gcs" {
    bucket = "{YOUR_BUCKET_NAME_BACKEND}"
    prefix = "sample2_intermediate/trocco"
  }
}

provider "trocco" {
  region = "japan"
}
