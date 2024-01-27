resource "aws_fis_experiment_template" "kill_ec2" {
  description = "kills a single ec2 from main node group"
  role_arn    = aws_iam_role.kill_ec2_role.arn

  stop_condition {
    source = "none"
  }

  action {
    name      = "kill-ec2"
    action_id = "aws:ec2:terminate-instances"

    target {
      key   = "Instances"
      value = "main-instance"
    }
  }

  target {
    name           = "main-instance"
    resource_type  = "aws:ec2:instance"
    selection_mode = "COUNT(1)"

    resource_tag {
      key   = "node-label"
      value = "main"
    }
  }

  tags = {
    Name  = "${local.username}-kill-ec2"
    Owner = local.username
  }
}

resource "aws_iam_role" "kill_ec2_role" {
  name = "kill_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "fis.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Owner = local.username
  }
}

resource "aws_iam_role_policy_attachment" "kill_pod_ec2_perms" {
  role       = aws_iam_role.kill_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorEC2Access"
}
