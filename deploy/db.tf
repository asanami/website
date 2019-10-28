resource "aws_db_instance" "postgresql" {
  engine                   = "postgres"
  engine_version           = "9.6.11"
  name                     = "${var.db_name}"
  username                 = "${var.db_user}"
  password                 = "${var.db_password}"
  instance_class           = "db.t2.micro"
  allocated_storage    	   = 5
  storage_type             = "gp2"
  backup_retention_period  = 0
  skip_final_snapshot      = true
  publicly_accessible      = true
}