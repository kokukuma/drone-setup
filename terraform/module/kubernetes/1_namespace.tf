resource "null_resource" "kubernetes_namespace" {
  depends_on = ["null_resource.kubernetes_credentials"]

  // namespace
  provisioner "local-exec" {
    command = "kubectl create ns ${var.namespace}"
  }

  // destroy
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete ns ${var.namespace}"
  }
}
