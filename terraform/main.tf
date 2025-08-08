provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable APIs (idempotent)
resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com"
  ])
  service = each.key
}

# Secure Artifact Registry
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "insight-agent"
  format        = "DOCKER"
  depends_on    = [google_project_service.apis]
}

# Cloud Run with internal-only access
resource "google_cloud_run_service" "api" {
  name     = "insight-agent-api"
  location = var.region
  depends_on = [
    google_project_service.apis,
    google_service_account.cloudrun_sa
  ]

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/insight-agent:${var.image_tag}"
        ports { container_port = 8080 }
      }
      service_account_name = google_service_account.cloudrun_sa.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Block all public access
resource "google_cloud_run_service_iam_binding" "private" {
  location = google_cloud_run_service.api.location
  service  = google_cloud_run_service.api.name
  role     = "roles/run.invoker"
  members  = [] # No members = private by default
}