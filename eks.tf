module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "garage_flow_eks"
  kubernetes_version = "1.33"

  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = aws_vpc.garage_flow_vpc.id
  subnet_ids = [
    aws_subnet.garage_flow_subnet_az_a.id,
    aws_subnet.garage_flow_subnet_az_b.id,
    aws_subnet.garage_flow_private_subnet_az_a.id,
    aws_subnet.garage_flow_private_subnet_az_b.id,
  ]

  tags = {
    Environment = "Prod"
    Tenant     = "fiap"
    Terraform   = "true"
  }
}