resource "null_resource" "kubernetes_credentials" {
  triggers {
    cluster_name = "${var.cluster_name}"
  }

  // get credentials
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name}"
  }
}
