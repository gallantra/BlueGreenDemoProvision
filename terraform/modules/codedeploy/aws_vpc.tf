data "aws_security_group" "web_all" {
  filter {
    name = "group-name"
    values = ["web_all"]
  }
  vpc_id = "${var.aws_vpc_id}"
}

data "aws_security_group" "ssh_all" {
  filter {
    name = "group-name"
    values = ["ssh_all"]
  }
  vpc_id = "${var.aws_vpc_id}"
}
