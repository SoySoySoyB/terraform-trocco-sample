terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.14.0"
    }
  }
  # バックエンドとして作成したバケットを指定する
  backend "gcs" {
    bucket = "{YOUR_BUCKET_NAME_BACKEND}"
    prefix = "sample2_intermediate/google"
  }
}

provider "google" {
  project = local.google.sample_project_id
  region  = local.google.default_location
}
