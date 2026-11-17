module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "garage_flow_eks"
  kubernetes_version = "1.33"

  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true
  # SCP da conta bloqueia iam:CreateOpenIDConnectProvider; pods usam o papel dos nós.
  enable_irsa = false

  # O criador (credencial do pipeline) já recebe admin; o usuário github é mantido para acesso legado.
  access_entries = {
    github = {
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/github"
      policy_associations = {
        admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id = aws_vpc.garage_flow_vpc.id
  subnet_ids = [
    aws_subnet.garage_flow_subnet_az_a.id,
    aws_subnet.garage_flow_subnet_az_b.id,
    aws_subnet.garage_flow_private_subnet_az_a.id,
    aws_subnet.garage_flow_private_subnet_az_b.id,
  ]

  tags = {
    Environment = "Prod"
    Tenant      = "fiap"
    Terraform   = "true"
  }
}