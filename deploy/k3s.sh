#!/usr/bin/bash

# Install k3s
curl -sfL https://get.k3s.io | sh -s - --disable=traefik --disable=metrics-server
