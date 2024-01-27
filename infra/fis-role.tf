resource "kubectl_manifest" "fis_sa" {
  yaml_body = <<YAML
kind: ServiceAccount
apiVersion: v1
metadata:
  namespace: default
  name: fis-sa
YAML

  depends_on = [module.eks]
}

resource "kubectl_manifest" "fis_role" {
  yaml_body = <<YAML
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: fis-role
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: [ "get", "create", "patch", "delete"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create", "list", "get", "delete", "deletecollection"]
- apiGroups: [""]
  resources: ["pods/ephemeralcontainers"]
  verbs: ["update"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get"]
YAML

  depends_on = [module.eks]
}

resource "kubectl_manifest" "fis_rb" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: fis-role-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: fis-sa
  namespace: default
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: fis-experiment
roleRef:
  kind: Role
  name: fis-role
  apiGroup: rbac.authorization.k8s.io
YAML

  depends_on = [module.eks]
}
