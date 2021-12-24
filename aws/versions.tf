terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.7"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 3.1"
    }
  }
}