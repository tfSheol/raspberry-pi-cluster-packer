#!/usr/bin/env bash

set -e

mkdir -p /opt/tools/k3s/dashboard

# dashboard.admin-user.yml
cat <<EOF > /opt/tools/k3s/dashboard/dashboard.admin-user.yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# dashboard.admin-user-role.yml
cat <<EOF > /opt/tools/k3s/dashboard/dashboard.admin-user-role.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# 03_init_dashboard.sh
cat <<EOF > /opt/tools/k3s/03_init_dashboard.sh
#!/usr/bin/env bash

GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=\$(curl -w '%{url_effective}' -I -L -s -S \${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/\${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml

k3s kubectl create -f /opt/tools/k3s/dashboard/dashboard.admin-user.yml
k3s kubectl create -f /opt/tools/k3s/dashboard/dashboard.admin-user-role.yml
k3s kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token' > /opt/k3s.dashboard.token

exit 0
EOF

chmod +x /opt/tools/k3s/*.sh