variable "project_id" {
  description = "Project ID"
  default     = "sacred-choir-454809-s9"
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
  default     = "sacred-choir-454809-s9-terraform-bucket"
}

variable "gcs_storage_class" {
  description = "Storage Bucket Class"
  default     = "STANDARD"
}