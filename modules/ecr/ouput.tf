# Output for ECR Repository Name
output "ecr_repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.this.name
}

# Output for ECR Repository URL
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
}
