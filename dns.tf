data "aws_route53_zone" "public_zone" {
  zone_id = var.public_zone_id
  private_zone = false
}

resource "aws_route53_zone" "private_zone" {
  name = "jenkins"
  vpc {
    vpc_id = aws_vpc.cicd_vpc.id
  }
}

resource "aws_route53_record" "jenkins_efs_private_dns" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "efs"
  ttl     = 60
  type    = "CNAME"
  records = [data.aws_efs_file_system.fs.dns_name]
}

resource "aws_route53_record" "jenkins_public_dns" {
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name    = "jenkins"
  ttl     = 30
  type    = "CNAME"
  records = [aws_instance.jenkins_instance.public_ip]
}