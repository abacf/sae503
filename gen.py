#!/usr/bin/env python3

import argparse

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
}


with open("deploy.yaml", "wt") as f:
  f.write(template.render(env=env, image="ghcr.io/abacf/sae503:1.0.0", base_domain="192.168.1.52.nip.io",))
