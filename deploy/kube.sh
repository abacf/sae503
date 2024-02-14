#!/usr/bin/bash

set -eu -o pipefail

# Install CRDs and RBACs

## Install Traefik Resource Definitions:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml

## Install RBAC for Traefik:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.10/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml

## Install Prometheus CRD
kubectl create -f kube-prometheus-custom/manifests/setup

# Create namespaces
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod

# Install Prometheus Operator
kubectl apply -f kube-prometheus-custom/manifests/

# Install Traefik
kubectl apply -f kube/traefik/

# Setup routes
kubectl apply -f kube/routes/

# Deploy application
# Check if poetry is installed
if type "poetry" > /dev/null; then
  # Install Jinja2
  poetry install --no-root --only main
  # Generate k8s manifests
  poetry run gen.py
  # Apply k8s manifests
  kubectl apply -f kube/app/
else
  echo "Poetry is not installed. Please install poetry and run the script again."
  exit 1
fi

# Configure AlertManager
# Modifiy appropriately depending on secret name, this is for SMTP
kubectl apply -f kube/prometheus/alertmanager/base/alertmanager-smtp.yml -f kube/prometheus/alertmanager/base/alertmanager-config.yml

# Enable alerts
kubectl apply -f kube/prometheus/alertmanager/alerts/alert-error.yaml
