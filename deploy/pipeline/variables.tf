variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "asanami/botolphs:1.3"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "3000"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "db_name" {
  description = "Database name"
  default     = "botolphsdata"
}

variable "db_user" {
  description = "Database username"
  default     = "botolphsuser"
}

variable "db_password" {
  description = "Database password"
  default     = "botolphspassword"
}

variable "db_max_age" {
  description = "Database mx age"
  default     = "60"
}

variable "db_engine" {
  description = "Database engine"
  default     = "django.db.backends.postgresql"
}

variable "app_secret" {
  description = "Django app secret key"
  default     = "some-secret-key-used-only-in-development"
}

# See https://docs.aws.amazon.com/ses/latest/DeveloperGuide/regions.html#region-endpoints
variable "email_host" {
  description = "Database name"
  default     = "email-smtp.us-east-1.amazonaws.com"
}

# The port you will connect to on the Amazon SES SMTP endpoint.
variable "email_port" {
  description = "Database name"
  default     = "587"
}

variable "s3_host" {
  description = "S3 host"
  default     = "s3.amazonaws.com"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  default     = "botolphs-data"
}

variable "s3_endpoint" {
  description = "S3 bucket endpoint"
  default     = "https://botolphs-data.s3.amazonaws.com"
}

variable "s3_access_key" {
  description = "S3 access key"
}

variable "s3_access_secret" {
  description = "S3 access secret"
}

variable "app_admin_user" {
  description = "Admin username to create"
  default     = "botolphs-admin"
}

variable "app_admin_email" {
  description = "Admin username to create"
  default     = "botolphs-admin@botolphs.com"
}

variable "disable_ssl" {
  description = "Disable AWS SSL"
  default     = "1"
}



