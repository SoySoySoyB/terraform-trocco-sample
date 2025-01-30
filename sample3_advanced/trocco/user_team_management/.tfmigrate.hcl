tfmigrate {
  migration_dir = "./state_operation/tfmigrate"
  history {
    storage "gcs" {
      bucket = "{YOUR_BUCKET_NAME_BACKEND}"
      name   = "sample3_advanced/trocco/user_team_management/tfmigrate_history.json"
    }
  }
}
