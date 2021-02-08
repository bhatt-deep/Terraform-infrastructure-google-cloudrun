terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {

  credentials = file("credentials/dev.json")

  project = "course-project-1040"
  region  = "northamerica-northeast1"
  zone    = "northamerica-northeast1-a"
}

resource "google_cloud_run_service" "default" {
  name     = "terraform-serv2"
  location = "northamerica-northeast1"
  autogenerate_revision_name = true
  

  template {
    spec {
      containers {
        image = "gcr.io/course-project-1040/course-project"
        env {
          name = "ENV_PORT"
          value = "8080"
        }
        env {
          name = "DATABASE_USER"
          value = google_sql_user.users.name
        }
        env {
          name = "DATABASE_PASSWORD"
          value = google_sql_user.users.password
        }
        env {
          name = "DATABASE_SOCKET"
          value = format("/cloudsql/%s", google_sql_database_instance.instance.connection_name)
        }
        env {
          name = "DATABASE_NAME"
          value = google_sql_database.database.name
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "10"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

