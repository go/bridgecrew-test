#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "bridgecrew-demo" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = (tomap({
    "Name" = "bridgecrew-demo-vpc",
  }))
}

resource "aws_subnet" "bridgecrew-demo" {
  count = 3

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.bridgecrew-demo.cidr_block, 2, count.index)
  vpc_id                  = aws_vpc.bridgecrew-demo.id
  map_public_ip_on_launch = true

  tags = (tomap({
    "Name" = "bridgecrew-demo-subnet0${count.index}",
  }))
}

resource "aws_internet_gateway" "bridgecrew-demo" {
  vpc_id = aws_vpc.bridgecrew-demo.id
}

resource "aws_route_table" "bridgecrew-demo" {
  vpc_id = aws_vpc.bridgecrew-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bridgecrew-demo.id
  }
}

resource "aws_route_table_association" "bridgecrew-demo" {
  count = 3

  subnet_id      = aws_subnet.bridgecrew-demo.*.id[count.index]
  route_table_id = aws_route_table.bridgecrew-demo.id
}

resource "aws_iam_role" "bridgecrew-demo" {
  name = "bridgecrew-demo"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_flow_log" "bridgecrew-demo" {
  iam_role_arn    = aws_iam_role.bridgecrew-demo.arn
  log_destination = "arn:aws:logs:ap-northeast-1:682277861596:log-group:vpc-flowlogs:*"
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.bridgecrew-demo.id
}
