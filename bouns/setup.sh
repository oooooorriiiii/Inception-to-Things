kubectl create namespace gitlab

# https://docs.gitlab.co.jp/charts/installation/deployment.html#deploy-using-helm
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  --set global.hosts.domain=k3d.localhost \
  --set global.ingress.enabled=true \
  --set global.ingress.configureCertmanager=false \
  --set global.ingress.tls.enabled=false \
  --set gitlab-runner.install=false \
  --set global.externalUrl=http://k3d.localhost \
  --timeout 600s

kubectl wait --for=condition=ready --timeout=10m pod -l app=webservice -n gitlab

# https://docs.gitlab.co.jp/charts/installation/deployment.html#initial-login
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode

# kubectl port-forward svc/gitlab-webservice-default -n gitlab 8880:8080