# A module that can create Kubernetes resources from YAML file descriptions.
# https://github.com/terraform-providers/terraform-provider-kubernetes/issues/3

variable "cluster_name" {
  description = "GKE cluster name"
}

variable "namespace" {
  description = "GKE cluster namespace"
}

variable "k8spath" {
  description = "directory path"
}

resource "null_resource" "kubernetes_resource" {
  triggers {
    cluster_name = "${var.cluster_name}"
  }

  // get credentials
  // TODO: projectとかの設定
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name}"
  }

  // namespace
  provisioner "local-exec" {
    command = "kubectl create ns ${var.namespace}"
  }

  /* // configmap/secret */
  /* provisioner "local-exec" { */
  /*   command = "envsubst < ${var.k8spath}/config/configmap.yaml | kubectl --namespace ${var.namespace} apply -f -" */
  /*   command = "envsubst < ${var.k8spath}/config/secret.yaml | kubectl --namespace ${var.namespace} apply -f -" */
  /* } */
  /* // TODO: lbのIP取得して環境変数に渡す */
  /* provisioner "local-exec" { */
  /*   command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/lb" */
  /* } */
  /* provisioner "local-exec" { */
  /*   command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/volume" */
  /*   command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/mysql" */
  /*   command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/drone" */
  /* } */
  /* // TODO: mysqlのpod nameを取得 */
  /* provisioner "local-exec" { */
  /*   command = "kubectl --namespace ${var.namespace} exec -it mysql-84db84fb8d-wt5hk mysql -u root -ppassword -e 'create database if not exists drone;' " */
  /* } */
}
