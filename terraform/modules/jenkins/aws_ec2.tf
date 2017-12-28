data "aws_ami" "centos" {
  most_recent = true
  owners = [
    "679593333241"]
  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }
  filter {
    name = "product-code"
    values = [
      "aw0evgkw8e5c1q413zgy5pjce"]
  }
}

resource "aws_instance" "instance" {
  ami = "${data.aws_ami.centos.id}"
  instance_type = "${var.aws_instance_type}"
  availability_zone = "${element(var.aws_elb_zones, 1)}"
  key_name = "Superadmins"
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.id}"
  security_groups = [
    "${data.aws_security_group.web_all.name}",
    "${data.aws_security_group.ssh_all.name}"
  ]
  tags {
    Name = "${var.aws_stack_name}"
    terraformed = "true"
  }

  provisioner "local-exec" {
    command = "../../jenkins.yml"
    interpreter = [
      "ansible-playbook",
      "-e",
      "jenkins=${self.public_ip}",
      "-i",
      "${self.public_ip},"
    ]
  }
}

output "instance_publick_ip" {
  value = "${aws_instance.instance.public_ip}"
}