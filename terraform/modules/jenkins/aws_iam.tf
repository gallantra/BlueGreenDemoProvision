resource "aws_iam_instance_profile" "iam_instance_profile" {
  name_prefix  = "${var.aws_stack_name}-jenkins-profile"
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

data "aws_iam_policy_document" "CodeDeployPolicyDocument" {
  statement {
    actions = [
      "codedeploy:Batch*",
      "codedeploy:CreateDeployment",
      "codedeploy:Get*",
      "codedeploy:List*",
      "codedeploy:RegisterApplicationRevision"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "CodeDeployPolicy" {
  name = "MyCodeDeployPolicy"
  policy = "${data.aws_iam_policy_document.CodeDeployPolicyDocument.json}"
}

resource "aws_iam_role" "role" {
  name_prefix = "${var.aws_stack_name}-jenkins-role"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.iam_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "role_attachment" {
  policy_arn = "${aws_iam_policy.CodeDeployPolicy.arn}"
  role = "${aws_iam_role.role.id}"
}

output "aws_iam_role" {
  value = "${aws_iam_role.role.name}"
}