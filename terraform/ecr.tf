resource "aws_ecr_repository" "atlas" {
  name                 = "atlas"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "atlas"
  }
}
output "ecr_repository_url" {
  description = "URL of the Atlas ECR repository"
  value       = aws_ecr_repository.atlas.repository_url
}