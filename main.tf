resource "aws_security_group" "EC2Jennkins" {
  vpc_id      = var.vpc_id

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
  tags = {
    Name = "EC2Jennkins"
  }
}

resource "aws_instance" "jenkins_master" {
  ami           = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.EC2Jenkins_securitygroup_id]

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
  vpc_security_group_ids= [var.EC2Jenkins_securitygroup_id]

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