# Argo CD: from commit to cluster

**The reference implementation for the free [Argo CD course](https://www.platformengr.com/learn/argocd/) by [PlatformEngr](https://www.platformengr.com/): one Kubernetes cluster, Argo CD managed from Git, and a product team shipping through three repositories.**

Written by [Daniel Abrahamberg](https://www.abrahamberg.com/). Everything runs on your laptop with kind. It is the prerequisite for [Fleet GitOps](https://www.platformengr.com/learn/fleet-gitops/), which takes the same ideas to a fleet of clusters.

```text
 commit ──> Git ──(Argo CD polls / webhook)──> render (Helm, Kustomize) ──> diff ──> sync ──> health
                                                                                     │
   argocd-platform   (platform team)  Argo CD config, projects, Applications ───────┤
   checkout-app      (team-checkout)  source + Helm chart, released by tag ─────────┤
   checkout-config   (team-checkout)  values and sealed secrets per environment ────┘
```

## What is in here

You never fork this repo. You create **three repos of your own** and copy folders from here into them, one module at a time.

| Folder | Becomes your repo | Owner | Holds |
| --- | --- | --- | --- |
| [platform/](platform/) | `argocd-platform` | Platform team | Argo CD's own values, the root app, every Application, AppProjects, namespaces, sealed repo credentials. |
| [checkout-app/](checkout-app/) | `checkout-app` | team-checkout | The application repository: the Helm chart (and, in real life, the code and CI). |
| [checkout-config/](checkout-config/) | `checkout-config` (private) | team-checkout | The environment repository: what runs where, in every format the course uses. |
| [cluster/](cluster/) | (stays here) | You | The kind cluster definition. |
| [labs/](labs/) | (stays here) | Course | Manifests the debugging labs deploy straight from this repo. |
| [docs/](docs/) | (read) | Platform team | Operating model, repository comparison, debugging runbook. |

Every manifest says `YOUR_GITHUB_USER` where your GitHub user goes. The course replaces it when you copy.

## Versions

| Component | Version | Pinned in |
| --- | --- | --- |
| Argo CD | v3.5.6 (chart `argo-cd` 10.11.6; the course installs 10.10.5 first and upgrades) | `platform/apps/argocd.yaml` |
| Traefik | chart 42.2.0 | `platform/apps/traefik.yaml` |
| Sealed Secrets | chart 2.22.0 (controller 0.41.2) | `platform/apps/sealed-secrets.yaml` |
| checkout image | podinfo 6.7.0 / 6.7.1 | `checkout-config/helm/*.yaml` |

## What is simplified, and what production looks like

| Here | In production |
| --- | --- |
| kind on a laptop, one cluster | Managed Kubernetes; many clusters: see Fleet GitOps |
| Local accounts (`alice`, `checkout-dev`) | SSO through OIDC; groups mapped to roles |
| Traefik's self-signed certificate | cert-manager with a real certificate, private ingress |
| Sealed Secrets, key in the cluster | A vault plus External Secrets with workload identity; back up the sealing key if you keep Sealed Secrets |
| Argo CD polls Git every minute | GitHub webhooks to Argo CD for instant refresh |
