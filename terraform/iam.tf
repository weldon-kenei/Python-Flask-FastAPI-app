# Dedicated Service Account for Cloud Run
resource "google_service_account" "cloudrun_sa" {
  account_id   = "insight-agent-sa"
  display_name = "Cloud Run runtime service account"
}

# Allow Cloud Run SA to write logs
resource "google_project_iam_member" "logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

# Allow Cloud Run SA to access Artifact Registry
resource "google_project_iam_member" "artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

# Grant CI/CD service account (terraform-deployer) permissions
# Note: This SA must be created manually before Terraform runs
data "google_service_account" "ci_cd_sa" {
  account_id = "113946165348459910896" # Must match your pre-created SA
}

resource "google_project_iam_member" "ci_cd_cloudrun_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${data.google_service_account.ci_cd_sa.email}"
}

resource "google_project_iam_member" "ci_cd_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_service_account.ci_cd_sa.email}"
}