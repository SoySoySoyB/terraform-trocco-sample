terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.19.0"
    }
  }
  # 初期リソースの作成はローカルで行うので、バックエンドのGCSを作成後にコメントアウトを外す
  # バケット名は自分で作成したものにすること
  # backend "gcs" {
  #   bucket = "{YOUR_BUCKET_NAME_BACKEND}"
  #   prefix = "sample2_intermediate/_backend"
  # }
}

provider "google" {
  project = local.google.sample_project_id
  region  = local.google.default_location
}
