output "instance_id" {
  value = aws_instance.tf-aws.id
  description = "ID of the virtual machine"
}

output "public_ip" {
  value = aws_instance.tf-aws.public_ip
  description = "Public IP address of the virtual machine"
}

output "login_command" {
  value = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.tf-aws.public_ip}"
  description = "Command to log in to the virtual machine"
}