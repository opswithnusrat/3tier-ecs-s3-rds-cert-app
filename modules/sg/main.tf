resource "aws_security_group" "alb-internet-sg" {
  name        = "security group of alb"
  description = "enable http/https "
  vpc_id      = var.vpc-id

  ingress {
    description      = "http accesss"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
ingress {
    description      = "https accesss"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-internet-sg"
  }
}

resource "aws_security_group" "web-tier-sg" {
  name        = "security group for web-tier"
  description = "enable communication of web tier through internet facing load balancer "
  vpc_id      = var.vpc-id

  ingress {
    description      = "ssh accesss"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    description      = "http accesss"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb-internet-sg.id]
  }
ingress {
    description      = "https accesss"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
   security_groups = [aws_security_group.alb-internet-sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-tier-sg"
  }
}



resource "aws_security_group" "alb-internal-sg" {
  name        = "security group of internal alb"
  description = "enable communiction of webtier to app tier usinf internal load balancer"
  vpc_id      = var.vpc-id

  ingress {
    description      = "custom"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.web-tier-sg.id]
  }
ingress {
    description      = "https accesss"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
   security_groups = [aws_security_group.web-tier-sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-internal-sg"
  }
}
resource "aws_security_group" "app-tier-sg" {
  name        = "security group for app tier"
  description = "enable between app and web through internal load balancer"
  vpc_id      = var.vpc-id
  
  ingress {
    description      = "ssh accesss"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
  ingress {
    description      = "custom protocol"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.alb-internal-sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "app-tier-sg"
  }
}


resource "aws_security_group" "db-tier-sg" {
  name        = "security group for db tier"
  description = "enable communication between app and mysql "
  vpc_id      = var.vpc-id

  ingress {
    description      = "custom protocol"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups = [aws_security_group.app-tier-sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db-tier-sg"
  }
}



