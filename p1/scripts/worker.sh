#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

check_status() {
    local status=$1
    local success_msg=$2
    local failure_msg=$3

    if [ "$status" -eq 0 ]; then
        echo -e "[INFO] ${success_msg}"
    else
        echo -e "${RED}[ERROR] ${failure_msg}${RESET}"
    fi
}

# Set the INSTALL_K3S_EXEC environment variable with multiple lines for readability
INSTALL_K3S_EXEC="
    agent --server https://192.168.56.110:6443
    -t $(cat /vagrant/token.env)
    --node-ip 192.168.56.110
"

export  INSTALL_K3S_EXEC
check_status $? "export INSTALL_K3S_EXEC SUCCEEDED" "export INSTALL_K3S_EXEC FAILED"

#install k3s
curl -sfL https://get.k3s.io | sh -
check_status $? "K3s installation SUCCEEDED" "K3s installation FAILED"