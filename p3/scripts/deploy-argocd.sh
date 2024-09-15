#!/bin/bash

# Argo CD 
# https://argo-cd.readthedocs.io/en/stable/
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=ready pod --all -n argocd --timeout=3m

kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode

# Port Forwarding
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0 >/dev/null 2>&1 &