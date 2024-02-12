#!/usr/bin/env python3

from jinja2 import Environment, PackageLoader, select_autoescape

env = Environment(loader=PackageLoader("gen"), autoescape=select_autoescape())
template = env.get_template("app-template.yaml.j2")


env = {
  "dev": {"queues": ["rubis", "emeraude", "saphir", "diamant"]},
  "prod": {"queues": ["rubis", "emeraude", "saphir", "diamant"]},
  "test": {"queues": ["rubis", "emeraude", "saphir", "diamant"]},
}


for namespace in env:
  with open(f"deploy-{namespace}.yaml", "wt") as f:
    f.write(
      template.render(
        env={namespace: env[namespace]},
        image="ghcr.io/abacf/sae503:2.0.3",
        base_domain="192.168.1.52.nip.io",
      )
    )
