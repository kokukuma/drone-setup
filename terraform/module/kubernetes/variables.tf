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

variable "proxy_user_name" {
  description = "goole cloud sql proxy user"
}

variable "sql_connection_name" {
  description = "goole cloud sql connection name"
}
