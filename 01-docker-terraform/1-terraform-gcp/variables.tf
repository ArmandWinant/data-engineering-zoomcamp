variable "project_id" {
  description = "My Project ID"
  default     = "durable-cacao-448302-v7"
}

variable "location" {
  description = "My project location"
  default     = "EU"
}

variable "region" {
  description = "My project region"
  default     = "europe-west3"
}

variable "bq_dataset_name" {
  description = "My BigQuery dataset name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "durable-cacao-448302-v7-terraform-bucket"
}

variable "gcs_storage_class" {
  description = "My Storage Bucket Class"
  default     = "STANDARD"
}