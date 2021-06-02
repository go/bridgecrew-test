locals {
access_info=<<ACCESSINFO

Terraformed sample EC2 configuration!!

To access instance, plase use below access information.

# ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_instance.demo.public_ip}
ACCESSINFO
}

output "access_info" {
  value = "${local.access_info}"
}
