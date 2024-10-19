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
	--set global.hosts.domain=ymori.jp \
	--set certmanager-issuer.email=ymori@student.42tokyo.jp \
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

argocd-login:
	$(eval ARGOCD_PASS := $(shell argocd admin initial-password -n argocd | awk 'NR==1 {print $1}'))
	argocd login localhost:8080 --insecure --username admin --password $(ARGOCD_PASS)
# argocd login localhost:8080 --insecure --username admin --password Z5P7-b0pH0Vlmpcq

deploy: deploy-cluster deploy-gitlab delete-traefik deploy-argocd print-gitlab-pw print-argocd-pw


up-gitlab:
	bash ./setup.sh

destroy-gitlab:
	helm uninstall -n gitlab gitlab
	kubectl delete namespace gitlab

destroy-cluster:
	k3d cluster delete $(CLUSTER_NAME)

destroy: destroy-gitlab destroy-cluster

add-gitlab-repo:
	argocd repo add http://gitlab-webservice-default.gitlab.svc.cluster.local:8080/root/42iot.git \
	--username root \
	--password $(shell kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

upload-app-gitlab:
	git clone http://gitlab.ymori.jp:8880/root/42iot.git
	cd 42iot && \
	git switch --create main && \
	mkdir manifests && \
	cp ../confs/for-gitlab-manifests/manifests/application.yaml manifests/ && \
	git add manifests/application.yaml && \
	git commit -m "add manifests/application.yaml" 

# git push --set-upstream origin main \
	--username root \
	--password $(shell kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)


# make re

re: destroy deploy

# bash ./setup.sh