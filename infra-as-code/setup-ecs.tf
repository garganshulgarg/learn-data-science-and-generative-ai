resource "aws_ecs_cluster" "cluster" {
  name = "learn-ml-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "learn-ml-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "learn-ml-container",
      image     = "${var.image_path}:${var.image_tag}", # Replace with your DockerHub image
      cpu       = 1024,
      memory    = 2048,
      essential = true,
      portMappings = [
        {
          containerPort = 8888,
          hostPort      = 8888
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "service" {
  name            = "learn-ml-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "learn-ml-ecs-sg"
  description = "Allow web traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "learn_ml_ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}