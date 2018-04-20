resource "null_resource" "kubernetes_lb" {
  depends_on = ["null_resource.kubernetes_deployment"]

  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/lb"
  }

  // destroy
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete ing --all"
  }

  // 消えるまで雰囲気待つ
  // これかなり微妙だから, ちゃんとしたprovider使いたい
  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 60"
  }
}
