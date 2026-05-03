module "vpc" {
  source = "../../modules/vpc"

    vpc_cidr = "10.0.0.0/16"
    name = "dsoapp-dev"
    availability_zones = ["us-east-1a", "us-east-1b"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    tags = {
        Environment = "dev"
        Project     = "vpc-alb-asg"
    }

}

module "security" {
  source = "../../modules/security"

    name = "dsoapp-dev"
    vpc_id = module.vpc.vpc_id
    bastion_sg_id = module.bastion.bastion_sg_id
    tags = {
        Environment = "dev"
        Project     = "vpc-alb-asg"
    }
}

module "alb" {
  source = "../../modules/alb"

    name = "dsoapp-dev"
    vpc_id = module.vpc.vpc_id
    public_subnets = module.vpc.public_subnet_ids
    alb_sg = module.security.alb_sg_id
    tags = {
        Environment = "dev"
        Project     = "vpc-alb-asg"
    }
}

module "asg" {
  source = "../../modules/asg"

    name = "dsoapp-dev"
    ami_id = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    key_name = "devops-key"
    max_size = 4
    min_size = 1
    desired_capacity = 2
    private_subnets = module.vpc.private_subnet_ids
    target_group_arn = module.alb.target_group_arn
    ec2_sg = module.security.ec2_sg_id
    instance_profile_name = module.iam.instance_profile_name
}

module "iam" {
  source = "../../modules/iam"

    name = "dsoapp-dev"
    tags = {
        Environment = "dev"
        Project     = "vpc-alb-asg"
    }
}

module "bastion" {
  source = "../../modules/bastion"

    name = "dsoapp-dev"
    ami_id = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    key_name = "devops-key"
    public_subnet_id = module.vpc.public_subnet_ids[0]
    allowed_ssh_cidr = "106.219.176.71/32"
    vpc_id = module.vpc.vpc_id
    tags = {
        Environment = "dev"
        Project     = "vpc-alb-asg"
    }
}