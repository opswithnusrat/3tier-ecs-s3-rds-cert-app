variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default = {
    Owner       = "InNeed"
    Project     = "Esther Finance"
    Environment = "Dev"
  }
}

variable "acm_cert_arn" {
  type    = string
  default = null
}


variable "ecr_repository_uri" {
  description = "ECR repository URI"
  type        = string
}

variable "api_environment_variables" {
  description = "Envirmnet variable for API"
  type        = list(map(string))
  default     = []
}
