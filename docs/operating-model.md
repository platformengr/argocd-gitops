# How product teams work with Argo CD

## Ownership

| Thing | Platform team | Product team (team-checkout) |
| --- | --- | --- |
| Argo CD install, upgrades, exposure, SSO, RBAC | Owns | Uses |
| AppProject `checkout`, namespaces, quotas | Owns | Requests changes by pull request |
| Secret stores, repository credentials (deploy keys) | Owns the stores; puts the key in the platform store, commits the ExternalSecret | Adds the deploy key to its repo |
| `apps/checkout-*.yaml` (which chart release runs) | Reviews | Proposes (CODEOWNERS) |
| Chart in `checkout-app` | | Owns, releases by tag |
| Values and ExternalSecrets in `checkout-config`; the values in its own store | | Owns |
| Sync, refresh, rollback of checkout apps | Can | Can, in its own project |

## How the product team deploys

1. **New release of the app or chart**: tag `checkout-app` (`v1.1.0`).
2. **Run it in dev**: pull request to `argocd-platform` changing `targetRevision` in `apps/checkout-dev.yaml`, or to `checkout-config` changing `image.tag` in `helm/dev.yaml`.
3. **Promote to prod**: the same change for prod, reviewed by a second person.
4. **Roll back**: `git revert` the pull request. Never the UI rollback: it turns auto-sync off and leaves Git wrong.

## How the product team inspects failures

| Question | Where |
| --- | --- |
| Did Argo CD see my commit? | UI: app header, *Last sync* revision; `argocd app get checkout-dev` |
| What would it change? | UI *App diff*; `argocd app diff checkout-dev` |
| Why did the sync fail? | `argocd app get checkout-dev --show-operation` |
| Why is it not healthy? | UI resource tree, then the pod's events and logs; `argocd app logs checkout-dev` |
| What changed recently? | `argocd app history checkout-dev`, then the commits |

## When to escalate to the platform team

| Symptom | Product team first | Escalate when |
| --- | --- | --- |
| Out of sync, sync failed on my manifests | Fix in your repo, revert | Never: it is yours |
| Degraded, CrashLoopBackOff, failed hook | Logs and events; revert | Never: it is yours |
| `not permitted in project` | Check you deploy only into your namespaces | You need a new kind or destination |
| `permission denied` (RBAC) | Check you are logged in as yourself | Your role is wrong |
| `authentication required`, repo `Failed` | Check the deploy key is still on the repo | The credential in Argo CD must change |
| Every app Unknown, UI down | Nothing | Immediately |
