#!/bin/bash

# docker
# https://docs.docker.com/engine/install/ubuntu/

if ! command -v "docker" >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl -y
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # https://docs.docker.com/engine/install/linux-postinstall/
    sudo usermod -aG docker $USER
else
    echo "docker is already installed."
fi

# kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

if ! command -v "kubectl" >/dev/null 2>&1; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
else
    echo "kubectl is already installed."
fi

# k3d
# https://k3d.io/v5.7.4/
if ! command -v "k3d" >/dev/null 2>&1; then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "k3s is already installed."
fi

k3d cluster create ymoriCluster