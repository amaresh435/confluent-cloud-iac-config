terraform {
  backend "gcs" {
    bucket = "gcp-tfm-resources"
    prefix = "Conflunet.Cloud.Iac.Config/pr"
  }
}
