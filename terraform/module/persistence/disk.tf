resource "google_compute_disk" "default" {
  name = "drone-disk"
  type = "pd-ssd"
  zone = "${var.zone}"
  size = "100"

  labels {
    environment = "dev"
  }
}
