output "sql_arn_id" {
  value = aws_db_instance.sql_server.arn
}

output "eks_cluster_name"{
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint"{
  value = module.eks.cluster_endpoint
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}

output "elb_security_group_id" {
  value = aws_security_group.elb_sg.id
}