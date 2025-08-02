variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    Project     = "ECS"
    Environment = "Dev"
  }
}
variable "ecr_repository" {
  default = "ecs-ecr-repo"
}
