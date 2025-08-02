

resource "aws_security_group" "rds_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-rds-sg"
    }
  )
}

# Certs
module "app_domain_cert" {
  source = "../modules/acm/"

  domain_name = local.app_domain
  alternative_name = local.app_alternative_name
}

module "api_domain_cert" {
  source = "../modules/acm/"

  domain_name = local.api_domain
  alternative_name = local.api_alternative_name
}

# #vpc
module "vpc" {
  source              = "../modules/vpc"
  name_prefix         = local.name_prefix
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.0.0/24"
  private_subnet_cidr = "10.0.1.0/24"
}

#s3_bucket
module "s3" {
  source         = "../modules/s3"
  region         = var.region
  bucket_name    = var.bucket_name
  cloudfront_arn = module.cloudfront.cloudfront_arn
}
#cloudfront

module "cloudfront" {
  source              = "../modules/cloudfront"
  # s3_bucket           = module.s3.bucket_name
  # aliases             = [local.app_domain]
  dns_domain_name     = module.s3.dns_domain_name
  domain_name         = local.app_domain
  origin_id           = module.s3.origin_id
  acm_certificate_arn = module.app_domain_cert.acm_certificate_arn
}



# RDS module
module "rds" {
  source      = "../modules/rds"
  name_prefix = local.name_prefix
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_ids         = [aws_security_group.rds_sg.id]
}

# ECR module
module "ecr" {
  source      = "../modules/ecr"
  name_prefix = local.name_prefix

}

# ECS module
module "ecs" {
  source             = "../modules/ecs"
  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  ecr_repository_uri = module.ecr.ecr_repository_url
  acm_cert_arn       = module.api_domain_cert.acm_certificate_arn
  api_environment_variables = [
      { name = "DB_HOST", value = module.rds.rds_endpoint},
      { name = "DB_USER", value = var.db_username },
      { name = "DB_PASS", value = var.db_password }

  ]

  depends_on = [module.api_domain_cert]
}

