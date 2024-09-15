#!/bin/bash

kubectl create namespace dev

kubectl apply -f ../confs/application.yaml

kubectl wait --for=condition=ready pod --all -n dev --timeout=3m

# Port Forwarding
kubectl port-forward svc/wil42-playground-service -n dev 8888:8888 --address 0.0.0.0 >/dev/null 2>&1 &