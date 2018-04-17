resource "google_compute_global_address" "default" {
  name = "drone-static-ip"
}

output "static_ip" {
  value = "${google_compute_global_address.default.address}"
}
