This folder contains the code for creating the infrastructure and deploying the web application to AWS.

The infrastructure is currently tested under version `0.12.12` of terraform.

## Prerequisites

### Building the botolph docker image

The infrastructure is using AWS ECS and pulls the botolph application from dockerhub.io and uses `asanami/botolphs:1.2` by default.  You can replace the repository with an private one or use an alternative:

```
docker login --username <user> --password <password>
docker build -t botolphs:1.0 ../Dockerfile
docker tag botolphs:1.0 <namespace>/botolphs:1.2
docker push <namespace>/botolphs:1.2
```

### Registering an AWS Simple Email Service (SES) domain

The application relies on a re-registered SES domain name to be registered.

### Creating the AWS infrastructure

Set the AWS environment variables for authenicating against the provider:

```
export AWS_ACCESS_KEY_ID=<VALUE>
export AWS_SECRET_KEY=<VALUE>
```

Executing terraform:

```
terraform init
terraform plan
terraform apply [-var app_image=<namespace>/botolphs:1.2] -var s3_access_key=<AWS_ACCESS_KEY_ID> -var s3_access_secret=<AWS_SECRET_KEY>
```

After the application has been provisioned, terraform will output the address of the ALB, along with some other useful infrastructure endpoints.

```
Apply complete! Resources: 26 added, 0 changed, 0 destroyed.

Outputs:

alb_hostname = <hostname>.us-east-1.elb.amazonaws.com
bucket_domain_name = <bucket-name>.s3.amazonaws.com
db_endpoint = <db-host>.us-east-1.rds.amazonaws.com:5432
```

### Creating admin user

Once the application is up, I used a debug container to create the password for the application.

```
./manage.py createsuperuser --username <admin-user --email <email>
```

## Deploying updates

Application updates can be deployed by re-running terraform and bumping the docker tag version. E.g.

```
terraform apply -var app_image=asanami/botolphs:<next-tag>
```

This will create a new task definition, mark the previous task as inactive, and once the connections have drained, it gets garbage collected.

<b>Note</b>: This makes assumptions that updating the application will not have breaking schema changes on the DB or S3 store and multiple revisions of the application can happily load balance across these external resources.  If the application makes breaking changes, we would need to:
- Snapshot DBs and S3 stores
- Bring up side-by-side instances or S3, db, and container instance.
- Mark previous as readonly whilst upgrade is happening.

### Destroying the infrastructure

```
terraform destroy
```

### TODO

-  SSL (HTTPS)

The application currently is configured using HTTP and unfortunately, have not had time to configured SSL for https.  As a PoC, I could cut a self-sighed cert with a wildcard sans for amazon's host dns.  For production, I would use Route53.

```
resource "aws_acm_certificate" "cert" {
  domain_name       = "example.com"
  validation_method = "DNS"
}
```

- Email sending

As a prerequisite on route53, email sending can be configured using AWS' Simple Email Service (SES).  Unfortunately, I didn't have a chance for my email domain registration to complete, but I've included a template example terraform file `email.tf.todo` which would demostrate the idea.

## Vendor lock-in evaluation

A lot of the terraform code here is aws specific.  Whilst the concepts can be applied across multiple cloud providers (E.g. networking, security groups, instances etc), the code and underlining API calls are cloud specific.  This would have to be rewritten using different terraform configuration code.

For example, security groups in terraform.

AWS:

```
data "aws_security_group" "default" {
  name = "default"
}
```

Openstack:

```
# create the security group
resource "openstack_networking_secgroup_v2" "default" {
  name = "default"
}
```

In terms of specific services used here,  other cloud providers provide similar services which are analogues to AWS'.  E.g for an Azure comparison:

Amazon Container Service (ECS) ( Fargate) ~= Azure Container Instances

Simple Storage Services (S3) ~= Azure Blob storage

RDS ~= Azure Database for PostgreSQL

CodePipeline ~= Azure DevOps

Route 53 ~= Azure DNS

However, the configuration management of setting up and deploying to these services differ greatly, and for a large part would have to be re-written.

## CI/CD

There is a WIP for using AWS CodeBuild to create a build pipeline for deploying the application to ECS.
