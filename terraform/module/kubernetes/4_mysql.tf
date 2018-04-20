resource "null_resource" "kubernetes_mysql" {
  depends_on = ["null_resource.kubernetes_volume"]

  // 接続先は DRONE_DATABASE_DATASOURCEで定義
  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/mysql"
  }

  // mysql側の準備が整うまで待つ必要がある....
  // これかなり微妙だから, ちゃんとしたprovider使いたい
  provisioner "local-exec" {
    command = "sleep 60"
  }

  // destroy
  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete deploy mysql"
  }
}

// これかなり微妙だから, ちゃんとしたprovider使いたい
data "external" "mysql_pod_name" {
  depends_on = ["null_resource.kubernetes_mysql"]

  program = ["bash", "${path.module}/podname.sh"]

  query = {
    name = "mysql"
  }
}

resource "null_resource" "kubernetes_create_table" {
  depends_on = ["null_resource.kubernetes_mysql"]

  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} exec -it ${data.external.mysql_pod_name.result["pod_name"]} -- mysql -u root -ppassword -e 'create database if not exists drone;'"
  }
}
