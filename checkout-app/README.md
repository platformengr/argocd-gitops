# checkout-app: the application repository

Owned by **team-checkout**. In a real team this repo holds the service's source
code, its tests, the CI that builds and pushes the image, and the Helm chart that
says how to run it. Here the image is the public `podinfo`, so only the chart is
real.

| Path | What |
| --- | --- |
| `chart/` | The Helm chart. Released by tagging the repo (`v1.0.0`); Argo CD deploys a tag, never a branch. |

What does **not** belong here: per-environment settings (replicas, versions per
environment, secrets). Those live in `checkout-config`, so promoting a release is a
one-line change there and the chart stays the same everywhere.

Render it locally exactly like Argo CD does:

```bash
helm template checkout chart -f ../checkout-config/helm/dev.yaml
```
