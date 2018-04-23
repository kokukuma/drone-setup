// 凄く時間かかるうえ, 同じ名前は7日間使えないから手動に..
// resource "google_sql_database_instance" "master" {
//   name = "drone-db"
// 
//   settings {
//     tier = "D0"
//   }
// }

resource "google_sql_database" "drone-db" {
  name      = "drone"
  instance  = "${var.cloud_sql_name}"
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "users" {
  name     = "proxyuser"
  instance = "${var.cloud_sql_name}"
  host     = "cloudsqlproxy~%"
}

output "sql_connection_name" {
  value = "${var.project}:${var.region}:${var.cloud_sql_name}"
}
