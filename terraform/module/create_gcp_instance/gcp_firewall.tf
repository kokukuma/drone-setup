# gcp_firewall.tf

resource "google_compute_firewall" "development" {
  name    = "development-${terraform.workspace}"
  network = "${google_compute_network.test-network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  target_tags = ["${google_compute_instance.terraform-test.tags}"]
}
