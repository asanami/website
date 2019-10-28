
resource "aws_s3_bucket" "botolphs_bucket" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  tags = {
    Name        = "botolphs S3"
  }
}

