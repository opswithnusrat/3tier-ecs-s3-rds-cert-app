output "alb-internet-sg-id" {
    value = aws_security_group.alb-internet-sg.id
}
output "web-tier-sg-id" {
    value = aws_security_group.web-tier-sg.id
}
output "alb-internal-sg-id" {
    value = aws_security_group.alb-internal-sg.id
}
output "app-tier-sg-id" {
  value = aws_security_group.app-tier-sg.id
}
output "db-tier-sg-id" {
    value = aws_security_group.db-tier-sg.id
}