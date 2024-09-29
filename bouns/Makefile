CLUSTER_NAME := ymoriCluster

deploy-cluster:
	k3d cluster create $(CLUSTER_NAME) \
	--port "8880:80@loadbalancer"

deploy-gitlab:
	kubectl create namespace gitlab
	helm upgrade --install -n gitlab gitlab gitlab/gitlab \
	--timeout 600s \
	--set global.hosts.https=false \
	--set global.hosts.domain=example.com \
	--set certmanager-issuer.email=me@example.com \
	--set gitlab.webservice.ingress.tls.enabled=false
	kubectl wait --for=condition=ready --timeout=15m pod -l app=webservice -n gitlab

# TODO: gitlab.webservice.ingress.tls.enabled=false が必要かどうかを確認する

delete-traefik:
	kubectl delete svc traefik -n kube-system

deploy: deploy-cluster deploy-gitlab delete-traefik

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