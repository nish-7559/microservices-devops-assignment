resource "aws_security_group" "microservices_sg" {
  name        = "microservices-devops-sg"
  description = "Allow SSH and microservices ports"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "User Service"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Product Service"
    from_port   = 5002
    to_port     = 5002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Order Service"
    from_port   = 5003
    to_port     = 5003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecr_repository" "user_service" {
  name                 = "user-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_ecr_repository" "product_service" {
  name                 = "product-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_ecr_repository" "order_service" {
  name                 = "order-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_instance" "app_server" {
  ami                    = "ami-009a37f62c7ea3f0a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.microservices_sg.id]

  tags = {
    Name = "Microservices-DevOps-Host"
  }
}

output "ec2_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "Public IP of the server"
}

output "ecr_repository_urls" {
  value = {
    user    = aws_ecr_repository.user_service.repository_url
    product = aws_ecr_repository.product_service.repository_url
    order   = aws_ecr_repository.order_service.repository_url
  }
  description = "URLs of ECR repositories"
}