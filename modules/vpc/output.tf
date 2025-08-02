output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "The ID of the public subnet"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "The ID of the private subnet"
  value       = [for subnet in aws_subnet.private : subnet.id]
}


