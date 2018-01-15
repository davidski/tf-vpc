variable "cidr" {}

variable "name" {}

variable "project" {}

variable "logging_role" {
  description = "ARN of IAM Role with CloudWatch logging permissions."
}

variable "flowlog_retention_days" {
  description = "Number of days to retain VPC flowlogs"
  default     = 60
}
