output "instance_id" {
  description = "ID of the virtual machine"
  value       = aws_instance.tf_aws.id
}

output "public_ip" {
  description = "Public IP address of the virtual machine"
  value       = aws_instance.tf_aws.public_ip
}

output "login_command" {
  description = "Command to log in to the virtual machine"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.tf_aws.public_ip}"
}
