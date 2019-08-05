
resource "aws_security_group" "sg_jenkins_instance" {
  name        = "sg_jenkins_instance"
  description = "sg_jenkins_instance"
  vpc_id      = aws_vpc.cicd_vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Jenkins Website Port"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "SSH"
  #   from_port   = 22
  #   protocol    = "tcp"
  #   to_port     = 22
  # }
  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "Jenkins Agent Discover"
  #   from_port   = 50000
  #   protocol    = "tcp"
  #   to_port     = 50000
  # }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_efs_target" {
  vpc_id = aws_vpc.cicd_vpc.id
  ingress {
    cidr_blocks = []
    security_groups  = [aws_security_group.sg_jenkins_instance.id]
    description = "NFS Port"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
