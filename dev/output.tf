# output "bucket_name" {
  # description = "S3 Bucket Name"
  # value       = module.s3.site_bucket.bucket
# }

output "cloudfront_url" {
  description = "CloudFront URL"
  value       = module.cloudfront.cloudfront_domain_name
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.rds_endpoint
}

output "api_lb" {
  description = "API LB URL"
  value       = module.ecs.ecs_lb_url
}
