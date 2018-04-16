# gcp_network.tf

resource "google_compute_network" "test-network" {
  name = "test-network-${terraform.workspace}"
}

resource "google_compute_subnetwork" "development" {
  name          = "development-${terraform.workspace}"
  ip_cidr_range = "10.30.0.0/16"

  network     = "${google_compute_network.test-network.name}"
  description = "development"
  region      = "${var.region}"
}
