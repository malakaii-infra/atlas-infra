# -------------------------
# VPC endpoints (replace the NAT gateway)
# -------------------------
# Fargate tasks in the private subnets need to reach:
#   ECR API     - auth + image manifests
#   ECR Docker  - image pulls
#   S3          - image layers (ECR stores them in S3)
#   Logs        - awslogs driver -> CloudWatch
#
# Interface endpoints live in one AZ (private_a) to keep cost down.
# Tasks in private_b reach them cross-AZ. Tradeoff: if us-east-1a is
# down, new tasks can't pull images.

locals {
  interface_endpoints = ["ecr.api", "ecr.dkr", "logs"]
}

resource "aws_security_group" "endpoints" {
  name        = "atlas-endpoints-sg"
  description = "Allow HTTPS from Atlas ECS tasks to interface endpoints"
  vpc_id      = aws_vpc.atlas.id

  ingress {
    # VPC CIDR instead of the ECS SG: referencing each other inline
    # would create a dependency cycle with atlas-ecs-sg's egress rule.
    description = "HTTPS from inside the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.atlas.cidr_block]
  }

  tags = {
    Name = "atlas-endpoints-sg"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(local.interface_endpoints)

  vpc_id              = aws_vpc.atlas.id
  service_name        = "com.amazonaws.${var.aws_region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private_a.id]
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = {
    Name = "atlas-${replace(each.value, ".", "-")}-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.atlas.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = {
    Name = "atlas-s3-endpoint"
  }
}
