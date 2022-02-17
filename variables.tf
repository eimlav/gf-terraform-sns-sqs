variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = "fake"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = "fake"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}