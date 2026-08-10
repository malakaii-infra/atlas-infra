resource "aws_ecs_cluster" "atlas" {
  name = "atlas"

  tags = {
    Name = "atlas-cluster"
  }
}

resource "aws_cloudwatch_log_group" "atlas" {
  name              = "/ecs/atlas"
  retention_in_days = 7

  tags = {
    Name = "atlas-logs"
  }
}

resource "aws_ecs_service" "atlas" {
  name    = "atlas"
  cluster = aws_ecs_cluster.atlas.id

  lifecycle {
    ignore_changes = [task_definition]
  }

  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.atlas.arn
    container_name   = "atlas"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.http
  ]

  tags = {
    Name = "atlas-service"
  }
}