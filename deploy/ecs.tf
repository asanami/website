
resource "aws_ecs_cluster" "main" {
  name = "tf-ecs-cluster"
}

resource "random_string" "random" {
  length = 16
  special = true
  override_special = "/@\" "
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"

  container_definitions = <<DEFINITION
[
  {
    "environment": [
      {
        "name": "APP_ADMIN",
        "value": "${var.app_admin_user}"
      },
      {
        "name": "APP_EMAIL",
        "value": "${var.app_admin_email}"
      },
      {
        "name": "PORT",
        "value": "${var.app_port}"
      },
      {
        "name": "DJANGO_DB_ENGINE",
        "value": "${var.db_engine}"
      },
      {
        "name": "DJANGO_DB_HOST",
        "value": "${aws_db_instance.postgresql.address}"
      },
      {
        "name": "DJANGO_SECRET_KEY",
        "value": "${random_string.random.result}"
      },
      {
        "name": "DJANGO_DB_NAME",
        "value": "${var.db_name}"
      },
      {
        "name": "DJANGO_DB_USER",
        "value": "${var.db_user}"
      },
      {
        "name": "DJANGO_DB_PASSWORD",
        "value": "${var.db_password}"
      },
      {
        "name": "DJANGO_DB_CONN_MAX_AGE",
        "value": "${var.db_max_age}"
      },
      {
        "name": "DJANGO_DB_PORT",
        "value": "${aws_db_instance.postgresql.port}"
      },
      {
        "name": "DJANGO_EMAIL_HOST",
        "value": "${var.email_host}"
      },
      {
        "name": "DJANGO_EMAIL_PORT",
        "value": "${var.email_port}"
      },
      {
        "name": "DJANGO_USE_AWS",
        "value": "1"
      },
      {
        "name": "DJANGO_AWS_ACCESS_KEY_ID",
        "value": "${var.s3_access_key}"
      },
      {
        "name": "DJANGO_AWS_SECRET_ACCESS_KEY",
        "value": "${var.s3_access_secret}"
      },
      {
        "name": "DJANGO_AWS_STORAGE_BUCKET_NAME",
        "value": "${var.s3_bucket_name}"
      },
      {
        "name": "DJANGO_AWS_S3_ENDPOINT_URL",
        "value": "${var.s3_endpoint}"
      },
      {
        "name": "DJANGO_DANGEROUS_DISABLE_AWS_USE_SSL",
        "value": "${var.disable_ssl}"
      },
      {
        "name": "DJANGO_AWS_S3_REGION_NAME",
        "value": "${aws_s3_bucket.botolphs_bucket.region}"
      },
      {
        "name": "DJANGO_AWS_S3_HOST",
        "value": "${var.s3_host}"
      }
    ],
    "cpu": ${var.fargate_cpu},
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name            = "tf-ecs-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = "${aws_subnet.private.*.id}"
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "app"
    container_port   = "${var.app_port}"
  }

  depends_on = [
    "aws_alb_listener.front_end",
  ]
}
