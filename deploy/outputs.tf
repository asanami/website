
output "alb_hostname" {
  value = "${aws_alb.main.dns_name}"
}

output "s3_region" {
  value = "${aws_s3_bucket.botolphs_bucket.region}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.botolphs_bucket.bucket_domain_name}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.botolphs_bucket.website_endpoint}"
}

output "db_endpoint" {
  value = "${aws_db_instance.postgresql.endpoint}"
}

