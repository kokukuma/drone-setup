# gcp_provider.tf

// variable
variable "project" {
  description = "GCP project id"
}

variable "region" {
  description = "GCP region"
}

variable "zone" {
  description = "GCP zone"
}

variable "credentials_file" {
  description = "GCP zone"
}

variable "cluster_name" {
  description = "GKE cluster name"
  default     = "drone-cluster"
}

variable "cloud_sql_name" {
  description = "Cloud SQL instance name"
  default     = "drone-db"
}

// Set GCP provider
provider "google" {
  credentials = "${file("${var.credentials_file}")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

// Create dist / static-ip
module "persistence" {
  source         = "module/persistence"
  project        = "${var.project}"
  region         = "${var.region}"
  zone           = "${var.zone}"
  cloud_sql_name = "${var.cloud_sql_name}"
}

// Create GKE cluster
module "cluster" {
  source       = "module/cluster"
  project      = "${var.project}"
  region       = "${var.region}"
  zone         = "${var.zone}"
  cluster_name = "${var.cluster_name}"
}

// Setup drone
module "kubernetes" {
  source              = "module/kubernetes"
  cluster_name        = "${module.cluster.cluster_name}"
  static_ip           = "${module.persistence.static_ip}"
  sql_connection_name = "${module.persistence.sql_connection_name}"
  namespace           = "drone"
  k8spath             = "k8s"
}

// Output
output "drone-url" {
  value = "http://${module.persistence.static_ip}"
}

output "kubectrl get command" {
  value = "kubectl --namespace drone get po,svc,ing"
}

output "sql_connection_name" {
  value = "${module.persistence.sql_connection_name}"
}
