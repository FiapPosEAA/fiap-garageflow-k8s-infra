data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "garage-flow-${data.aws_caller_identity.current.account_id}-terraform-state"
}
