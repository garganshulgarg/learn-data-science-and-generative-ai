
resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}



resource "aws_instance" "setup-ec2-for-dev-activities" {
  // Attached the Image Ubuntu Server 22.04 LTS (HVM), SSD Volume Type because it has ssm-agent configured by default.
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.xlarge"

  root_block_device {
    volume_size = 20
  }

  // IAM instance profile
  iam_instance_profile = aws_iam_instance_profile.setup-ec2-for-dev-activities.name

  key_name = aws_key_pair.generated_key.key_name


  user_data = <<-EOT
   #!/bin/bash
   ### Installing anaconda ###
   sudo su
   apt update
   apt install unzip
   pwd
   ls -lart
   curl https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh -o $HOME/anaconda.sh
   ls -lart
   bash  $HOME/anaconda.sh -b -p $HOME/anaconda3
   
   echo "export PATH=$PATH:$HOME/anaconda3/bin" >> ~/.bashrc
   source ~/.bashrc
   conda create -n tf tensorflow pydotplus jupyter -y
  

   mkdir MLCourse
   cd MLCourse
   curl https://dw9ne0o7jcasn.cloudfront.net/ml/MLCourse.zip -o MLCourse.zip
   
   unzip MLCourse.zip
   jupyter notebook --generate-config
   echo "c.ServerApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
   jupyter notebook --allow-root --no-browser --port=80

  EOT

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.setup-ec2-for-dev-activities.id]
  tags                   = var.required_tags
}

resource "aws_security_group" "setup-ec2-for-dev-activities" {
  name        = "setup-apache-on-ec2-security-group"
  description = "Security group for inbound access to the node"

  vpc_id = var.vpc_id
  // Allow incoming SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_source_ranges
  }

  // Define your inbound rules to allow traffic from NLB's security group
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_source_ranges
  }

  // Add more ingress rules as needed

  // Egress rules can also be defined if necessary

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.required_tags
}

resource "aws_iam_instance_profile" "setup-ec2-for-dev-activities" {
  name = "setup-ec2-for-dev-activities-instance-profile" # Replace with the desired name for the IAM instance profile
  role = aws_iam_role.setup-ec2-for-dev-activities.name  # Use the name of the managed role
  tags = var.required_tags
}

resource "aws_iam_role" "setup-ec2-for-dev-activities" {
  name                = "setup-ec2-for-dev-activities-role" # Replace with the desired name for the IAM role
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags                = var.required_tags
}

