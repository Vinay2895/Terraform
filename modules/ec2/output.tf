output "instance_id" {
  value = aws_instance.kaz.id
}

output "public_ip" {
    value = aws_instance.kaz.public_ip
  
}
output "private_ip" {
    value = aws_instance.kaz.private_ip
  
}
