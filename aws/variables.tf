

variable "aws_region" {
  default = "us-east-1"
}

variable "toplevel_domain" {
  description = "Top level domain that is registered with Route53 in the AWS account. This top level domain will be combined with the project name (default is grocy) to register the fully qualified domain name. For example, if the toplevel_domain entered is example.com, grocy.example.com will be the fully qualified domain name of the installed grocy server. This domain name is also used for SSL certificates with LetsEncrypt."

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

