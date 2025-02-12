terraform {
  required_version = "1.9.8"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.19.0"
    }
    trocco = {
      source  = "registry.terraform.io/trocco-io/trocco"
      version = "0.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
  # バケット作成後にコメントアウトを外すと、stateファイルをGCSで管理できる
  # {YOUR_BUCKET_NAME_BACKEND}/sample1_basic/default.tfstateとして保存される
  # ここではlocal変数は利用できず、またバケット名はグローバルに一意である必要がある
  # backend "gcs" {
  #   bucket = "{YOUR_BUCKET_NAME_BACKEND}"
  #   prefix = "sample1_basic"
  # }
}

provider "google" {
  project = local.google.project_id
  region  = local.google.default_location
}

provider "trocco" {
  region = "japan"
}
