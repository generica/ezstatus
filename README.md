# ezstatus

Go service listens on **8080**, Python on **8081** (override with `PORT`). Example Helm installs from repo root:

```bash
helm upgrade --install ezstatus-golang ./deploy/helm/golang --namespace default
helm upgrade --install ezstatus-python ./deploy/helm/python --namespace default
```

Build images from `services/golang` and `services/python` (set `image.repository` / `tag` in each chart’s `values.yaml` to match your registry).
