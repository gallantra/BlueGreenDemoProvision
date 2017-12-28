variable "aws_region" {
  description = "AWS region to use for deployment"
  default = "use-east-1"
}

variable "instance_az" {
  description = "The AZ to start the instance in"
  default = "us-east-1a"
}

variable "aws_stack_name" {
  description = "Name of the provision stack"
  type = "string"
}

variable "aws_vpc_id" {
  description = "VPC for our infrastructure."
  type = "string"
}

variable "aws_elb_zones" {
  description = "Availability zones for load balancer"
  type = "list"
}

variable "aws_instance_type" {
  description = "Instance type for jenkins server"
  default = "t2.micro"
}

variable "ssh-sg" {
  description = "Variable for module dependencies"
  type = "string"
}

variable "aws_route53_zone_id" {
  description = "Zone, where to create a record"
  type = "string"
}