# argocd-platform: the shared platform repository

Owned by the **platform team**. Argo CD watches this repo through the root
Application; everything Argo CD does starts here.

| Path | What | Changes when |
| --- | --- | --- |
| `argocd/values.yaml` | Argo CD's own configuration: accounts, RBAC, ingress, health checks. | Access, exposure or behaviour of Argo CD changes. |
| `bootstrap/root.yaml` | The root Application, applied once by hand. | Almost never. |
| `apps/` | One file per Application: Argo CD itself, add-ons, product apps. | Something is added, removed, or a chart version is bumped. |
| `projects/` | AppProjects: the boundary of each team. | A team is onboarded or needs more. |
| `namespaces/` | Product namespaces. | A team or environment is added. |
| `secrets/` | SealedSecrets for repository credentials. | A repo becomes private or a key rotates. |
| `scripts/validate.sh` | What CI checks on every pull request. | Rarely. |

Product teams propose changes to `apps/<team>-*.yaml` (chart versions) and review
them through `CODEOWNERS`; everything else is reviewed by the platform team.
