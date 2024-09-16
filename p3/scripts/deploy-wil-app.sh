#!/bin/bash

kubectl create namespace dev

kubectl apply -f ./confs/application.yaml

kubectl wait --for=condition=ready pod --all -n dev --timeout=3m