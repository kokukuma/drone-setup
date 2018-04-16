terraform {
  backend "gcs" {
    bucket = "terraform-test-bucket"
    prefix = "gcp/terraform.tfstate"
  }
}
