#!/usr/bin/env bash

set -e

sudo mkdir -p /etc/systemd/system/docker.service.d/
cat << EOF | sudo tee /etc/systemd/system/docker.service.d/clear_mount_propagtion_flags.conf
[Service]
MountFlags=
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker.service

mkdir -p /opt/tools/kubespray/dashboard

# apply.sh
cat <<EOF > /opt/tools/kubespray/01_apply.sh
#!/usr/bin/env bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
kubectl apply -f clusterrole.yaml
kubectl apply -f perms.yaml

exit 0
EOF

# clusterrole.yaml
cat <<EOF > /opt/tools/kubespray/dashboard/clusterrole.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: kubernetes-dashboard-anonymous
rules:
- apiGroups: [""]
  resources: ["services/proxy"]
  resourceNames: ["https:kubernetes-dashboard:"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- nonResourceURLs: ["/ui", "/ui/*", "/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/*"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-anonymous
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubernetes-dashboard-anonymous
subjects:
- kind: User
  name: system:anonymous
EOF

# perms.yaml
cat <<EOF > /opt/tools/kubespray/dashboard/perms.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
EOF

chmod +x /opt/tools/kubespray/dashboard/*.sh