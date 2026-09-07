resource "aws_security_group" "elb_sg" {
  name        = "garage-flow-elb-sg"
  description = "Security group for the EKS LoadBalancer"
  vpc_id      = aws_vpc.garage_flow_vpc.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "garage-flow-elb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nodes_nodeport_from_elb" {
  security_group_id = module.eks.node_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 30000
  to_port           = 32767
  ip_protocol       = "tcp"
  description       = "Allow NLB to reach nodes on NodePort range"
}
