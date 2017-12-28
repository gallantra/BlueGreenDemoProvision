data "aws_acm_certificate" "certificate" {
  domain = "*.dev.vdk.od.ua"
}

resource "aws_elb" "lb" {
  name = "${var.aws_stack_name}-elb"
  availability_zones = "${var.aws_elb_zones}"
  security_groups = [
    "${data.aws_security_group.web_all.id}"
  ]

  "listener" {
    instance_port = 3000
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.certificate.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3000/"
    interval            = 10
  }

  cross_zone_load_balancing = false

  tags {
    Name = "${var.aws_stack_name}-elb",
    terraformed = "true"
  }
}
