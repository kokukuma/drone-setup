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

variable "static_ip" {
  description = "static ip address"
}

resource "null_resource" "kubernetes_credentials" {
  triggers {
    cluster_name = "${var.cluster_name}"
  }

  // get credentials
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name}"
  }
}

resource "null_resource" "kubernetes_namespace" {
  depends_on = ["null_resource.kubernetes_credentials"]

  // namespace
  provisioner "local-exec" {
    command = "kubectl create ns ${var.namespace}"
  }
}

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
}

resource "null_resource" "kubernetes_volume" {
  depends_on = ["null_resource.kubernetes_config"]

  // 接続先は DRONE_DATABASE_DATASOURCEで定義
  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/volume"
  }
}

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

resource "null_resource" "kubernetes_deployment" {
  depends_on = ["null_resource.kubernetes_create_table"]

  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/drone"
  }
}

resource "null_resource" "kubernetes_lb" {
  depends_on = ["null_resource.kubernetes_deployment"]

  provisioner "local-exec" {
    command = "kubectl --namespace ${var.namespace} apply -f ${var.k8spath}/lb"
  }
}

// 他の奴らはcluster削除で一緒に消えるからこれだけ
resource "null_resource" "kubernetes_lb_destory" {
  depends_on = ["null_resource.kubernetes_lb"]

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --namespace ${var.namespace} delete ing drone"
  }

  // 消えるまで雰囲気待つ
  // これかなり微妙だから, ちゃんとしたprovider使いたい
  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 60"
  }
}
