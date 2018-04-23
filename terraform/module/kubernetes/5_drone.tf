resource "null_resource" "kubernetes_deployment" {
  // depends_on = ["null_resource.kubernetes_create_table"]

  depends_on = ["null_resource.kubernetes_volume"]

  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/drone"
  }

  // destroy
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete deploy drone-agent"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete deploy drone-server"
  }
}
