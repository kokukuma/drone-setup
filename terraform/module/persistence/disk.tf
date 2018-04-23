resource "google_compute_disk" "default" {
  name = "drone-disk"
  type = "pd-ssd"
  zone = "${var.zone}" // 必須
  size = "100"

  labels {
    environment = "dev"
  }
}
