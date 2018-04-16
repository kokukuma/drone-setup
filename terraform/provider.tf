# gcp_provider.tf
// Configure the Google Cloud provider

variable "project" {}
variable "region" {}
variable "zone" {}

provider "google" {
  credentials = "${file("drone-sa.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

module "create_gcp_instance" {
  source  = "module/create_gcp_instance"
  zone    = "${var.zone}"
  project = "${var.project}"
  region  = "${var.region}"
}
