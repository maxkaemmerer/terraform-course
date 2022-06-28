terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "region" {
  type = string
  default = "eu-central-1"
}

variable "queue_name" {
  type = string
  default = "terraform-example-queue.fifo"
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret
}

resource "aws_iam_user" "queue-client" {
  name = "queue-client"
  path = "/system/"

  tags = {
    environment = "test"
  }
}

resource "aws_iam_access_key" "queue-client" {
  user = aws_iam_user.queue-client.name
}

resource "local_sensitive_file" "credentials" {
  filename = "${path.module}/credentials"
  content = <<EOT
[default]
aws_access_key_id = ${aws_iam_access_key.queue-client.id}
aws_secret_access_key = ${aws_iam_access_key.queue-client.secret}
EOT
}

resource "local_file" "queue_url" {
  filename = "${path.module}/queue_url.txt"
  content = aws_sqs_queue.terraform_queue.url
}

resource "aws_sqs_queue" "terraform_queue" {
  name                        = var.queue_name
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_sqs_queue_policy" "terraform_queue_policy" {
  queue_url = aws_sqs_queue.terraform_queue.id

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.account_id}"
      },
      "Action": [
        "SQS:*"
      ],
      "Resource": "${aws_sqs_queue.terraform_queue.arn}"
    },
    {
      "Sid": "__sender_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${var.arn}",
          "${aws_iam_user.queue-client.arn}"
        ]
      },
      "Action": [
        "SQS:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.terraform_queue.arn}"
    },
    {
      "Sid": "__receiver_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${var.arn}",
          "${aws_iam_user.queue-client.arn}"
        ]
      },
      "Action": [
        "SQS:ChangeMessageVisibility",
        "SQS:DeleteMessage",
        "SQS:ReceiveMessage"
      ],
      "Resource": "${aws_sqs_queue.terraform_queue.arn}"
    }
  ]
}
EOF
}