terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }
  }
}
