terraform {
  backend "gcs" {
    //bucket = "terraform-test-bucket"

    bucket = "terraform-bucket-karino"
    prefix = "gcp/terraform.tfstate"
  }
}
