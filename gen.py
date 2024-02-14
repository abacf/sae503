#!/usr/bin/env python3

from jinja2 import Environment, PackageLoader, select_autoescape
import pathlib

SCRIPT_PATH = pathlib.Path(__file__).parent.resolve()

env = Environment(loader=PackageLoader("gen"), autoescape=select_autoescape())
template = env.get_template("app-template.yaml.j2")


# Define the environment
# Must be dev, prod and staging ! No change of name
env = {
  "dev": {"queues": ["rubis", "emeraude", "saphir", "diamant"]},
  "prod": {"queues": ["rubis", "emeraude", "saphir", "diamant"]},
  "staging": {"queues": ["rubis", "emeraude", "saphir", "diamant"]},
}

# Generate the files
for namespace in env:
  pathlib.Path(f'{SCRIPT_PATH}/kube/app').mkdir(parents=True, exist_ok=True)
  with open(f"{SCRIPT_PATH}/kube/app/deploy-{namespace}.yaml", "wt") as f:
    f.write(
      template.render(
        env={namespace: env[namespace]},
        image="ghcr.io/abacf/sae503:2.1.1",
        base_domain="192.168.1.52.nip.io",
      )
    )
