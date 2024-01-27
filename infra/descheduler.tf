resource "helm_release" "descheduler" {
  name = "descheduler"

  repository = "https://kubernetes-sigs.github.io/descheduler/"
  chart      = "descheduler"

  values = [
    <<EOT
nodeSelector:
  chaos/node-label: stuff
EOT
  ]
}
