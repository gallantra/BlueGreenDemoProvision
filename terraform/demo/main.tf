variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "..\/modules\/vpc"
  aws_vpc_id = "vpc-aaa3add3"
}

module "jenkins" {
  source = "..\/modules\/jenkins"
  aws_region = "${var.aws_region}"
  aws_stack_name = "BGDci"
  aws_vpc_id = "vpc-aaa3add3"
  aws_elb_zones = ["us-east-1a", "us-east-1b"]
  aws_instance_type = "t2.micro"
  ssh-sg = "${module.vpc.ssh_sg}"
  aws_route53_zone_id = "Z3GBFEBLJAQER4"
}

output "jenkins_url" {
  value = "${module.jenkins.dns}"
}

module "codedeploy" {
  source = "..\/modules\/codedeploy"
//  aws_region = "${var.aws_region}"
  aws_stack_name = "BGDapp"
  aws_vpc_id = "vpc-aaa3add3"
  aws_elb_zones = ["us-east-1a", "us-east-1b"]
  aws_instance_type = "t2.micro"
  ssh-sg = "${module.vpc.ssh_sg}"
  aws_route53_zone_id = "Z3GBFEBLJAQER4"
}

output "app_url" {
  value = "${module.codedeploy.dns}"
}

