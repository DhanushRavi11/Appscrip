#!/usr/bin/env bash
set -e

# Config
GIT_BRANCH="main"
IMAGE_NAME="helloworld"
IMAGE_TAG="latest"
NAMESPACE="hello-namespace"

echo "1) Pull latest code"
git pull origin "$GIT_BRANCH"

echo "2) Build Docker image"
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" ./app

echo "3) Push Docker image"
docker push "${IMAGE_NAME}:${IMAGE_TAG}"

echo "4) Apply Kubernetes manifests"
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "5) Apply ArgoCD Application (if not already applied)"
kubectl apply -f application.yaml

echo "Done. Application should be accessible via NodePort 30080 on any cluster node."
