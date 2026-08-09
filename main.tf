module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source  = "./modules/sg"
  sg_name = var.sg_name
}

module "ec2" {
  source            = "./modules/ec2"
  security_group_id = module.sg.sg_id
  instance_name     = var.instance_name
}
