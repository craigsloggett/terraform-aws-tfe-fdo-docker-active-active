provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "terraform-enterprise"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}

provider "random" {}
