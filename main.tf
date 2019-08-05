provider "aws" {
  region = "ap-south-1"
}

data "aws_efs_file_system" "fs" {
  file_system_id = var.efs_id
}

resource "aws_efs_mount_target" "efs_target" {
  count           = local.az_count
  file_system_id  = "${data.aws_efs_file_system.fs.id}"
  subnet_id       = "${aws_subnet.public.*.id[count.index]}"
  security_groups = [aws_security_group.sg_efs_target.id]
}

resource "aws_instance" "jenkins_instance" {
  ami                         = "ami-009110a2bf8d7dd0a"
  instance_type               = "t3.medium"
  key_name                    = "jenkins_ssh_key"
  vpc_security_group_ids      = [aws_security_group.sg_jenkins_instance.id]
  subnet_id                   = aws_subnet.public.*.id[0]
  associate_public_ip_address = true
  user_data                   = <<EOT
#!/bin/bash
apt-get update -y && apt-get install -y nfs-common docker.io
mount_point=/efs
mkdir $mount_point
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \
${data.aws_efs_file_system.fs.dns_name}:/ $mount_point
chmod -R 777 $mount_point
service docker start
sleep 15
docker run --rm --name jenkins -p 80:8080 -p 50000:50000 -v $mount_point/jenkins_home:/var/jenkins_home jenkinsci/blueocean:1.18.0

EOT
}
