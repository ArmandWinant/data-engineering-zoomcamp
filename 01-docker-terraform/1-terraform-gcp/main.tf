terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  project = "durable-cacao-448302-v7"
  region  = "europe-west3"
  credentials = "./keys/my-creds.json"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "durable-cacao-448302-v7-terraform-bucket"
  location      = "EU"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id                  = "demo_dataset"
  location                    = "EU"
}