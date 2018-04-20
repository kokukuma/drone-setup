resource "null_resource" "kubernetes_volume" {
  depends_on = ["null_resource.kubernetes_config"]

  // 接続先は DRONE_DATABASE_DATASOURCEで定義
  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/volume"
  }

  // destroy
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete pvc,pv --all"
  }
}
