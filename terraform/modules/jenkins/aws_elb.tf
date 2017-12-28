data "aws_acm_certificate" "certificate" {
  domain = "*.dev.vdk.od.ua"
}

resource "aws_elb" "lb" {
  name_prefix = "${var.aws_stack_name}"
  availability_zones = "${var.aws_elb_zones}"
  security_groups = [
    "${data.aws_security_group.web_all.id}"
  ]

  "listener" {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  "listener" {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${data.aws_acm_certificate.certificate.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/login"
    interval            = 10
  }

  cross_zone_load_balancing = false

  tags {
    Name = "${var.aws_stack_name}-elb",
    terraformed = "true"
  }
}

resource "aws_elb_attachment" "jenkins" {
  elb      = "${aws_elb.lb.id}"
  instance = "${aws_instance.instance.id}"
}