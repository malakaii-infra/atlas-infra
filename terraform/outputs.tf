output "vpc_id" {
  description = "Atlas VPC ID"
  value       = aws_vpc.atlas.id
}

output "public_subnet_ids" {
  description = "Atlas public subnet IDs"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "private_subnet_ids" {
  description = "Atlas private subnet IDs"
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "alb_dns_name" {
  description = "Temporary DNS name of the Atlas load balancer"
  value       = aws_lb.atlas.dns_name
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate for malakaii.org"
  value       = aws_acm_certificate.atlas.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}
