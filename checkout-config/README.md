# checkout-config: the environment repository

Owned by **team-checkout**. It says *what runs where*: which release of the
chart, with which settings, in which environment. Deploying is a pull request to
this repo. It is private: Argo CD reads it with a read-only deploy key.

| Path | Used in | What |
| --- | --- | --- |
| `manifests/` | modules 02 to 04 | Plain YAML: one Deployment, one Service. |
| `kustomize/base`, `dev`, `prod` | modules 05 and 06 | The same app as a Kustomize base with an overlay per environment. |
| `helm/dev.yaml`, `helm/prod.yaml` | module 07 on | Values for the chart released from `checkout-app`. |
| `secrets/dev`, `secrets/prod` | module 08 on | ExternalSecrets: references to team-checkout's store, safe to commit. |

The reference keeps every stage so each module can copy its folder; your repo
can delete a stage once you have moved past it.
