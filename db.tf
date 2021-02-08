resource "google_sql_database" "database" {
  name     = "terra-example"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.instance.name
  host     = "%"
  password = var.db_pass
}

resource "google_sql_database_instance" "instance" {
  name   = "terraform-ex1"
  region = "northamerica-northeast1"
  settings {
    tier = "db-f1-micro"
  }
}