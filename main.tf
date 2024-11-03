resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "jenkins_master" {
  ami           = var.image_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install java-openjdk11 -y
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum install jenkins -y
    systemctl enable jenkins
    systemctl start jenkins
  EOF

  tags = {
    Name = "Jenkins-Master"
  }
}


resource "aws_instance" "jenkins_agent" {
  ami           = var.image_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.jenkins_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install java-openjdk11 -y
    useradd jenkins
  EOF

  tags = {
    Name = "Jenkins-Agent"
  }
}