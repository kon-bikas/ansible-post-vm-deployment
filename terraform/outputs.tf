output "ec2_public_ips" {
  value = {
    for ec2 in aws_instance.ec2_instance : ec2.tags.Name => ec2.public_ip
  }
}

output "ec2_private_ips" {
  value = {
    for ec2 in aws_instance.ec2_instance : ec2.tags.Name => ec2.private_ip
  }
}