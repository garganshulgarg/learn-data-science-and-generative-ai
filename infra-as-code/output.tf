# To Output Private Key locally use following command
# terraform output -raw private_key
# Post that create a file devex_key.pem. This facility is only for troubleshooting the EC2 Instance.
output "private_key" {
  value     = tls_private_key.ssh_private_key.private_key_pem
  sensitive = true
}

output "instance_id" {
  value       = aws_instance.setup-ec2-for-dev-activities.id
  description = "AWS EC2 Node Instance ID"
}

output "public_dns" {
  value       = aws_instance.setup-ec2-for-dev-activities.public_dns
  description = "AWS EC2 Node Public DNS"
}

output "public_ip" {
  value       = aws_instance.setup-ec2-for-dev-activities.public_ip
  description = "AWS EC2 Node Public IP"
}