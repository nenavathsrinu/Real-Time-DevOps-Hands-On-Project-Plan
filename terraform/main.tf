
# VPC Module
module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = "10.0.0.0/16"
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  azs              = ["ap-south-1a", "ap-south-1b"]
}

# IAM Role for Jenkins
module "iam" {
  source         = "./modules/iam"
  iam_role_name  = "jenkins-role"
}

# EC2 Instance for Jenkins
module "jenkins_ec2" {
  source             = "./modules/ec2"
  ami_id             = "ami-00b7ea845217da02c"  # Amazon Linux 2 AMI (update as needed)
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.public_subnet_ids[0]
  key_name           = "linux-test"
  instance_name      = "jenkins-server"
  iam_instance_profile = module.iam.iam_instance_profile_name
  vpc_id = module.vpc.vpc_id
}

# RDS MySQL Database
module "rds" {
  source                 = "./modules/rds"
  db_name                = "mydb"
  db_user                = "admin"
  db_password            = "MyStrongPassword123"
  db_instance_class      = "db.t3.micro"
  subnet_ids             = module.vpc.private_subnet_ids
  vpc_security_group_ids = [] # Optional: Add a security group module if needed
}

# S3 Bucket for Artifacts
module "s3" {
  source       = "./modules/s3"
  bucket_name  = "srinu-devops-artifacts"
}

# ECR Repository for Docker Images
module "ecr" {
  source           = "./modules/ecr"
  repository_name  = "devops-app-repo"
}