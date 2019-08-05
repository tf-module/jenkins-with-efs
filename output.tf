
output "ec2_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.jenkins_instance.private_ip
}

output "efs_private_dns" {
  value = aws_route53_record.jenkins_efs_private_dns.fqdn
}

output "jenkins_url" {
  value = aws_route53_record.jenkins_public_dns.fqdn
}
