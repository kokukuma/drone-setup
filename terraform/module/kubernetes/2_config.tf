resource "null_resource" "kubernetes_config" {
  depends_on = ["null_resource.kubernetes_namespace"]

  // configmap
  provisioner "local-exec" {
    command = "envsubst < ${var.k8spath}/config/configmap.yaml | kubectl --namespace ${var.namespace} apply -f -"

    environment {
      DRONE_HOST = "http://${var.static_ip}"
    }
  }

  // secret
  provisioner "local-exec" {
    command = "envsubst < ${var.k8spath}/config/secret.yaml | kubectl --namespace ${var.namespace} apply -f -"
  }

  // destroy config map
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete cm drone-config-map"
  }

  // destroy secrets
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete secret drone-secrets"
  }
}
