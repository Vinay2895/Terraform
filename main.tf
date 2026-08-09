# module "vpc" {
  source = "./modules/vpc"
}

# module "sg" {
  source  = "./modules/sg"
  sg_name = var.sg_name
}

# module "ec2" {
  source            = "./modules/ec2"
  security_group_id = module.sg.sg_id
  instance_name     = var.instance_name
}


############################################
# VPC


module "vpc" {
  source = "./modules/vpc"

  vpc_name = "kaz-vpc"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}



# SECURITY GROUPS

module "sg" {
  source = "./modules/sg"

  vpc_id = module.vpc.vpc_id

  alb_sg_name = "kaz-alb-sg"

  ec2_sg_name = "kaz-ec2-sg"
}


# APPLICATION LOAD BALANCER


module "alb" {
  source = "./modules/alb"

  alb_name = "kaz-alb"

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

  security_group_id = module.sg.alb_sg_id
}


# AUTO SCALING GROUP

module "asg" {
  source = "./modules/asg"

  ami = "ami-02b64aa047cb5edf5"

  instance_type = "t2.micro"

  key_name = "2026keypair"

  private_subnet_ids = module.vpc.private_subnet_ids

  security_group_id = module.sg.ec2_sg_id

  target_group_arn = module.alb.target_group_arn

  instance_name = "kaz-web-server"

  min_size = 1

  max_size = 3

  desired_capacity = 1
}
