data "aws_region" "current" {
  current = true
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name       = "${var.name}"
    project    = "${var.project}"
    managed_by = "Terraform"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name       = "main"
    project    = "${var.project}"
    managed_by = "Terraform"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name       = "main"
    project    = "${var.project}"
    managed_by = "Terraform"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.r.id}"
}

# Establish private S3 endpoint

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id          = "${aws_vpc.vpc.id}"
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = ["${aws_route_table.r.id}"]
}

# Sestup VPC flow logs

resource "aws_flow_log" "vpc_flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_log.name}"
  iam_role_arn = "${var.logging_role}"
  vpc_id = "${aws_vpc.vpc.id}"
  traffic_type = "ALL"
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
    name = "${var.project}/vpc/flowlog_group"
    retention_in_days = "${var.flowlog_retention_days}"
}
