resource "aws_ecr_repository" "this" {
  name                 = "${local.username}-app"
  image_tag_mutability = "MUTABLE"

  tags = {
    Owner = local.username
  }
}
