variable "sample_version" {
  type        = string
  description = "sample2で作ったリソースだと分かりやすくするための文字列"
}

variable "google" {
  type        = map(string)
  description = "Googleの設定情報"
}

variable "snowflake" {
  type        = map(string)
  description = "Snowflakeの設定情報"
}
