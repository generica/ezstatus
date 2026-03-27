# ezstatus

Go service listens on **8080**, Python on **8081** (override with `PORT`). Example Helm installs from repo root:

```bash
helm upgrade --install ezstatus-golang ./deploy/helm/golang --namespace default
helm upgrade --install ezstatus-python ./deploy/helm/python --namespace default
```

## Images and Kubernetes

A bare name like `ezstatus-golang` is interpreted as **`docker.io/library/ezstatus-golang`**, which is Docker Hub’s public “library” org — not your image. You must either use a **full registry path** after you push, or run only on nodes that already have the image with `imagePullPolicy: Never` (unusual).

**Typical flow** (from repo root; replace `YOUR_REGISTRY` and tags):

```bash
# Golang (ARM64 nodes, e.g. Raspberry Pi)
docker buildx build --platform linux/arm64 -f services/golang/Dockerfile \
  -t YOUR_REGISTRY/ezstatus-golang:latest --push services/golang

# Python
docker buildx build --platform linux/arm64 -f services/python/Dockerfile \
  -t YOUR_REGISTRY/ezstatus-python:latest --push services/python

helm upgrade --install ezstatus-golang ./deploy/helm/golang --namespace default \
  --set image.repository=YOUR_REGISTRY/ezstatus-golang --set image.tag=latest
helm upgrade --install ezstatus-python ./deploy/helm/python --namespace default \
  --set image.repository=YOUR_REGISTRY/ezstatus-python --set image.tag=latest
```

`YOUR_REGISTRY` can be Docker Hub (`docker.io/youruser`), [GHCR](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry) (`ghcr.io/youruser`), or any registry your cluster can reach. If the registry is private, create a pull secret and reference it from the pod spec (`imagePullSecrets`); the chart does not wire that in by default, so use `--set`/values patches or extend the chart templates if needed.

Alternatively, edit each chart’s `deploy/helm/*/values.yaml` and set `image.repository` and `image.tag` to match what you pushed.

Build images from `services/golang` and `services/python` when not using the commands above.
