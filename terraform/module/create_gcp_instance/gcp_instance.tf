# gcp_instance.tf

resource "google_compute_instance" "terraform-test" {
  name         = "development-${terraform.workspace}"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  description  = "${var.project}"
  tags         = ["development", "mass"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  // Local SSD disk
  scratch_disk {}

  network_interface {
    access_config {
      // Ephemeral IP
    }

    subnetwork = "${google_compute_subnetwork.development.name}"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro", "bigquery", "monitoring"]
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = true
  }
}
