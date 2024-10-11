CLUSTER_NAME := ymoriCluster

deploy-cluster:
	k3d cluster create $(CLUSTER_NAME) \
	--port "8888:8888@loadbalancer" \
	--port "8880:80@loadbalancer" \
	--port "22:22@loadbalancer"

deploy-gitlab:
	kubectl create namespace gitlab
	helm upgrade --install -n gitlab gitlab gitlab/gitlab \
	--timeout 600s \
	--set global.hosts.https=false \
	--set global.hosts.domain=example.com \
	--set certmanager-issuer.email=me@example.com \
	--set gitlab.webservice.ingress.tls.enabled=false
	kubectl wait --for=condition=ready --timeout=15m pod -l app=webservice -n gitlab

delete-traefik:
	kubectl delete svc traefik -n kube-system

deploy-argocd:
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl wait --for=condition=ready pod --all -n argocd --timeout=3m

print-gitlab-pw:
	kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode

print-argocd-pw:
	argocd admin initial-password -n argocd
# kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode

argocd-port-forward:
	kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 127.0.0.1

deploy: deploy-cluster deploy-gitlab delete-traefik deploy-argocd print-gitlab-pw print-argocd-pw


up-gitlab:
	bash ./setup.sh

destroy-gitlab:
	helm uninstall -n gitlab gitlab
	kubectl delete namespace gitlab

destroy-cluster:
	k3d cluster delete $(CLUSTER_NAME)

destroy: destroy-gitlab destroy-cluster

# make re

re: destroy deploy

# bash ./setup.sh