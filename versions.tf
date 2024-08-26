terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}
