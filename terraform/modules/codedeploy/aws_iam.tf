resource "aws_iam_instance_profile" "iam_instance_profile" {
  name_prefix  = "${var.aws_stack_name}-bgd-profile"
  role = "${aws_iam_role.role.name}"
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}


resource "aws_iam_role" "role" {
  name_prefix = "${var.aws_stack_name}-BGDapp-role"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.iam_policy_document.json}"
}

output "aws_iam_role" {
  value = "${aws_iam_role.role.name}"
}