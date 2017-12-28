resource "aws_route53_record" "dns_record" {
  zone_id = "${var.aws_route53_zone_id}"
  name    = "app.dev"
  type    = "A"

  alias {
    name                   = "${aws_elb.lb.dns_name}"
    zone_id                = "${aws_elb.lb.zone_id}"
    evaluate_target_health = true
  }
}

output "dns" {
  value = "Application is now available on https://${aws_route53_record.dns_record.fqdn}"
}