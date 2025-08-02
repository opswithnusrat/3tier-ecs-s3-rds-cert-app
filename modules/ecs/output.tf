output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "cluster_name" {
  description = "ECS Cluster Name"
    value = aws_ecs_cluster.this.name
}

output "ecs_security_group_id" {
  description = "The security group ID for the ECS service"
  value       = aws_security_group.ecs_sg.id
}

output "ecs_lb_url" {
  description = "ECS LB URL"
  value       = aws_lb.ecs_lb.dns_name
}

# output "lb_cf_url" {
#   description = "ALB CloudFront URL"
#   value       = aws_cloudfront_distribution.alb_distribution.domain_name
# }
#
