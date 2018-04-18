# gcp_provider.tf
// Configure the Google Cloud provider

variable "project" {}
variable "region" {}
variable "zone" {}

variable "cluster_name" {
  default = "drone-cluster"
}

provider "google" {
  credentials = "${file("drone-sa.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

module "create_cluster" {
  source = "module/create_cluster"

  zone    = "${var.zone}"
  project = "${var.project}"
  region  = "${var.region}"

  cluster_name = "${var.cluster_name}"
}

module "kubernetes_apply" {
  source = "module/kubernetes"

  // clusterが出来たら実行
  cluster_name = "${module.create_cluster.cluster_name}"

  static_ip = "${module.create_cluster.static_ip}"
  namespace = "drone"
  k8spath   = "k8s"
}

// 表示するもの
output "drone-url" {
  value = "http://${module.create_cluster.static_ip}"
}

output "kubectrl get command" {
  value = "kubectl --namespace drone get po,svc,ing"
}
