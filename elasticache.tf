resource "aws_elasticache_serverless_cache" "tfe" {
  name                 = var.elasticache_serverless_cache_name
  description          = "Terraform Enterprise Redis Cache"
  engine               = "redis"
  major_engine_version = "7"
  security_group_ids   = [aws_security_group.elasticache.id]
  subnet_ids           = module.vpc.private_subnets
}
