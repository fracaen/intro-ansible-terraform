provider "aws" {
   region = "us-east-1"
   access_key                   = "ACCESS-KEY"
   secret_key                   = "SECRET-KEY"
}

resource "aws_instance" "secsummit" {
   ami                          = "ami-049489b50a99d699e"
   instance_type                = "t3.medium"
   availability_zone            = "us-east-1a"
   subnet_id                    = "subnet-62369e3d"
   vpc_security_group_ids       = ["sg-b7b63388","sg-08a791265afb7bddf"]
   key_name                     = "FC_Key_Pair"
   associate_public_ip_address  = true 

   user_data = <<-EOF
       Section: IOS configuration
       hostname secsummit
       ip domain name cisco.local
       aaa new-model
       aaa authentication login default local
       crypto key generate rsa general-keys modulus 4096
       ip ssh version 2
       username cisco123 privilege 15 secret cisco123
       enable secret cisco123
       restconf
   EOF
   
   #provisioner "local-exec" {
   #   command = "ansible-playbook edge.yml --extra-vars 'edge_public=${aws_instance.clus.public_ip}'"
   #}
}

output "instance_public_ip" {
   value                        = aws_instance.secsummit.public_ip
}

output "instance_private_ip" {
   value                        = aws_instance.secsummit.private_ip
}
