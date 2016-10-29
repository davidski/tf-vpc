output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "flowlog_log_group" {
  value = "${aws_cloudwatch_log_group.vpc_flow_log.arn}"
}
