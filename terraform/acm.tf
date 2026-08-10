resource "aws_acm_certificate" "atlas" {
  domain_name       = "malakaii.org"
  validation_method = "DNS"

  tags = {
    Name = "malakaii-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}