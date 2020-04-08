

variable "aws_region" {
  default = "us-east-1"
}

variable "toplevel_domain" {
  description = "Top level domain that is registered with Route53 in the same cd . This top level domain will be combined with the project name (default is grocy) to register the fully qualified domain name. If empty, it will "
}

variable "project_name" {
  default = "grocy"
}

variable "ami_key_pair_name" {
  default = "grocy-ssh-keypair"
  description = "SSH key pair name for the EC2 instance"
}


variable "email_address_to_use_with_letsencrypt" {
  default = "aaaa@aaa.com"
  description = "email address to use to register with letsencrypt"
}

