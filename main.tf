module "network" {
  source   = "./network"
  BeatStar = "BeatStar"

}

module "security" {
  source   = "./security"
  BeatStar = "BeatStar"
  vpc_id   = module.network.vpc_id
}

module "compute" {
  source                    = "./compute"
  BeatStar                  = "BeatStar"
  vpc_id                    = module.network.vpc_id
  ecs_security_group_id     = module.security.ecs_security_group_id
  target_group_arn          = module.compute.target_group_arn
  listener_arn              = module.compute.listener_arn
  cpu                       = "256"
  memory                    = "512"
  container_port            = 80
  desired_count             = 2
  private_subnet_ids        = module.network.private_subnet_ids
  public_subnet_ids         = module.network.public_subnet_ids
  task_execution_role_arn   = module.security.ecs_task_execution_role_arn
  alb_security_group_id     = module.security.alb_security_group_id
  jenkins_security_group_id = module.security.jenkins_security_group_id
  aws_region                = "aws_region"
}