#
# Variables Configuration
#

variable "vpc_cidr_block" {
  default = "192.168.10.0/24"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  default = "g-chiba-key"
  type    = string
}

variable "instance_name" {
  type = string
}
