output "ec2_public_ip" {
    value = [
        for instance in aws_instance.my_instance : instance.public_ip

    ]
    
  
}

# output "ec2_public_dns" {
# value = aws_instance.my_instance[*].ec2_public_dns
  
#}

# output "ec2_public_private_ip" {
 #   value = aws_instance.my_instance[*].ec2_public_private_ip
  
#}