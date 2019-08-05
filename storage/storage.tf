
provider "aws" {
  region = "ap-south-1"
}

resource "aws_efs_file_system" "fs" {
  tags = {
    Name = "jenkins-master"
  }
}
