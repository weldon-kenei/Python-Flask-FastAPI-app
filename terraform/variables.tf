variable "project_id" {
    description = "The GCP project ID"
    type        = sring
}

variable "region" {
    description = "The GCP region to deploy resources"
    type        = string
    default     = "us-central1"
}

variable "image_tag" {
    description = "The Docker image tag to deploy"
    type        = string
    default     = "latest"
}
