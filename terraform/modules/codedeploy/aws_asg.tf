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

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"
}

resource "aws_launch_configuration" "launch-config" {
  name_prefix = "${var.aws_stack_name}-lc-"
  image_id = "${data.aws_ami.centos.id}"
  instance_type = "${var.aws_instance_type}"
  associate_public_ip_address = false
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.name}"

  root_block_device {
    volume_type = "standard"
    volume_size = "${var.aws_volume_size}"
    delete_on_termination = true
  }

  security_groups = [
    "${data.aws_security_group.web_all.id}",
    "${data.aws_security_group.ssh_all.id}"
  ]
  key_name = "${var.aws_key_name}"
  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.aws_stack_name}"
  max_size = 1
  min_size = 1
  desired_capacity = 1
  health_check_type = "EC2"
  health_check_grace_period = 900
  launch_configuration = "${aws_launch_configuration.launch-config.name}"
  load_balancers = [
    "${aws_elb.lb.name}"]

  # Instances must be in same AZ as ELB
  availability_zones = "${var.aws_elb_zones}"

  tag {
    key = "Name"
    value = "${var.aws_stack_name}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}