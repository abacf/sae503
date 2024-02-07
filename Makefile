CTN=`which podman >/dev/null 2>&1 && echo podman || echo docker`
IMAGENAME="iut-stmalo-sae503"
VVERSION="1.0.0"


clean:
	$(CTN) rmi -f $(IMAGENAME):$(VVERSION)

build:
	$(CTN) build -t $(IMAGENAME):$(VVERSION) .

run:
	$(CTN) run \
  --rm=true \
  -p 127.0.0.1:8000:8000 \
  --detach=false \
  --name=iut-stmalo-sae503 \
  localhost/iut-stmalo-sae503:1.0.0

deploy-monitoring:
  kubectl apply --server-side -f kube-prometheus/manifests/setup
  kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring
  kubectl apply -f kube-prometheus/manifests/