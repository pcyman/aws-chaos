resource "aws_fis_experiment_template" "kill_pod" {
  description = "kills a single pod"
  role_arn    = aws_iam_role.kill_pod.arn

  stop_condition {
    source = "none"
  }

  action {
    name      = "kill-pod"
    action_id = "aws:eks:pod-delete"

    parameter {
      key   = "kubernetesServiceAccount"
      value = "fis-sa"
    }

    target {
      key   = "Pods"
      value = "sys-info"
    }
  }

  target {
    name           = "sys-info"
    resource_type  = "aws:eks:pod"
    selection_mode = "COUNT(1)"

    parameters = {
      clusterIdentifier = module.eks.cluster_arn
      namespace         = "default"
      selectorType      = "labelSelector"
      selectorValue     = "app=sysinfo"
    }
  }

  tags = {
    Name  = "${local.username}-kill-pod"
    Owner = local.username
  }
}

resource "aws_iam_role" "kill_pod" {
  name = "kill_pod"

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

resource "aws_iam_role_policy_attachment" "kill_pod_eks_perms" {
  role       = aws_iam_role.kill_pod.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSFaultInjectionSimulatorEKSAccess"
}
