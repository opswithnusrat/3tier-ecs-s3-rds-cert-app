resource "aws_db_subnet_group" "this" {
  name       = "ecs-rds-subnet-group"
  subnet_ids = var.public_subnet_ids

}

resource "aws_db_instance" "my-db" {
  identifier             = var.identifier
  allocated_storage      = 10
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  multi_az               = false
  vpc_security_group_ids = var.rds_sg_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true

}

