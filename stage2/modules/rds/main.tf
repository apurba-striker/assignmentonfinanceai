resource "aws_db_subnet_group" "default" {
  name       = "onfinance-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "onfinance-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "onfinance-rds-sg"
  description = "Allow DB access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For production, restrict this to specific IPs or security groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "onfinance-rds-sg"
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = "onfinance-db"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_user
  password          = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true

  tags = {
    Name = "onfinance-postgres-db"
  }
}
