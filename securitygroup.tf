resource "aws_security_group" "demo" {
  name        = "demo"
  description = "Security group for demo node"
  vpc_id      = aws_vpc.demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = (tomap({
    "Name" = "sg-demo",
  }))
}

resource "aws_security_group_rule" "demo-ingress-ssh" {
  description       = "SSH Access for worker nodes"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.demo.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["157.2.48.247"]
}

resource "aws_security_group_rule" "demo-ingress-http" {
  description       = "HTTP Access for worker nodes"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.demo.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
