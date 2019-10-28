resource "aws_s3_bucket" "build-bucket" {
  bucket = "codebuild-botolphs"
  acl    = "private"
}

resource "aws_s3_bucket" "deploy-bucket" {
  bucket = "codedeploy-botolphs"
  acl    = "private"
}