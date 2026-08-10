# Atlas

Atlas is the infrastructure behind my portfolio website, built to demonstrate practical AWS and DevOps engineering.

The infrastructure is provisioned with Terraform. The application is containerized with Docker, deployed to Amazon ECS Fargate, and exposed through an Application Load Balancer with HTTPS.

## Architecture

GitHub → GitHub Actions → Amazon ECR → Amazon ECS Fargate → Application Load Balancer → Portfolio

GitHub Actions authenticates to AWS through OIDC, builds the Docker image, pushes it to ECR, registers a new ECS task definition, and updates the ECS service.

## Infrastructure

Terraform provisions:
- VPC with public and private subnets
- Security groups
- Application Load Balancer
- ECS cluster, task definition, and service
- Amazon ECR repository
- IAM roles and policies
- GitHub Actions OIDC authentication
- CloudWatch Logs
- ACM certificate for HTTPS

## Infrastructure as Code

All AWS infrastructure is defined in Terraform and stored in version control.

The project is structured so the AWS environment can be provisioned and updated through Terraform rather than manually configuring individual resources.

## CI/CD

A push to `main` triggers the GitHub Actions deployment pipeline.

The workflow:

1. Authenticates to AWS using GitHub OIDC.
2. Builds the Docker image.
3. Pushes the image to Amazon ECR.
4. Registers a new ECS task definition.
5. Updates the ECS service.

AWS credentials are not stored as long-lived GitHub secrets.

## Future Improvements

- Add automated Terraform validation and plan checks to pull requests.
- Add deployment health checks before completing CI/CD runs.
- Add CloudWatch alarms for ECS service or application failures.
