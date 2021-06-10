resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.bridgecrew-demo.id
}

resource "aws_security_group" "bridgecrew-demo" {
  name        = "bridgecrew-demo"
  description = "Security group for demo"
  vpc_id      = aws_vpc.bridgecrew-demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = (tomap({
    "Name"    = "bridgecrew-demo-sg",
    "owner"   = "g-chiba",
    "service" = "bridgecrew-demo"
  }))
}

resource "aws_security_group_rule" "bridgecrew-demo-secure-ssh" {
  description       = "Secure SSH Access from Home"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bridgecrew-demo.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["180.59.50.250/32"]
}

resource "aws_security_group_rule" "bridgecrew-demo-ingress-ssh" {
  description       = "SSH Access from Labs"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bridgecrew-demo.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["157.2.48.247/32"]
}

resource "aws_security_group_rule" "bridgecrew-demo-ingress-http" {
  description       = "HTTP Access for instance"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.bridgecrew-demo.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
