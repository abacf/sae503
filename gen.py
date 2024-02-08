#!/usr/bin/env python3

from jinja2 import Environment, PackageLoader, select_autoescape
env = Environment(
    loader=PackageLoader("gen"),
    autoescape=select_autoescape()
)
template = env.get_template("app-helm.yaml.j2")


env = {
  "dev": {
    "queues": ["rubis", "emeraude", "saphir", "diamant"]
  },
  "prod": {
    "queues": ["rubis", "emeraude", "saphir", "diamant"]
  },
  "test": {
    "queues": ["rubis", "emeraude", "saphir", "diamant"]
  }
}


for namespace in env:
  with open(f"deploy-{namespace}.yaml", "wt") as f:
    f.write(template.render(env={namespace: env[namespace]}, image="ghcr.io/abacf/sae503:1.1.0", base_domain="172.18.200.33.nip.io",))
    