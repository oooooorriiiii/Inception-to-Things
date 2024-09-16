#!/bin/bash

k3d cluster create ymoriCluster \
    --port "8888:8888@loadbalancer"