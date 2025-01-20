variable "project_id" {
  description = "Project ID"
  default     = "durable-cacao-448302-v7"
}

variable "credentials" {
  description = "Credentials"
  default = "./keys/my-creds.json"
}

variable "location" {
  description = "Project location"
  default     = "EU"
}

variable "region" {
  description = "Project region"
  default     = "europe-west3"
}

variable "bq_dataset_name" {
  description = "BigQuery dataset name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "Storage Bucket Name"
  default     = "durable-cacao-448302-v7-terraform-bucket"
}

variable "gcs_storage_class" {
  description = "Storage Bucket Class"
  default     = "STANDARD"
}