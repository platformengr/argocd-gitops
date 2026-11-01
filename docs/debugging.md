# Debugging runbook

Start at the Application, then go one level down at a time.

```bash
argocd app get <app>                     # sync status, health, conditions, last operation
argocd app get <app> --show-operation    # why the last sync failed, per resource
argocd app diff <app>                    # what Argo CD would change
argocd app resources <app>               # every resource and its status
argocd app manifests <app>               # what Argo CD rendered
argocd app history <app>                 # what was deployed, from which revision
kubectl -n <ns> get events --sort-by=.lastTimestamp
kubectl -n argocd logs deploy/argocd-repo-server        # rendering, Git, Helm errors
kubectl -n argocd logs statefulset/argocd-application-controller   # sync and health
```

| Symptom | Usual cause | Look at |
| --- | --- | --- |
| `Unknown` sync status, `ComparisonError` | Argo CD cannot render: bad YAML, bad values, missing path, repo unreachable | Application conditions, repo-server logs |
| `OutOfSync` that never syncs | Auto-sync off, sync window, failed previous sync, wrong branch or path | `argocd app get`, `argocd proj windows list` |
| `OutOfSync` again right after syncing | Something else changes the field (HPA, webhook, controller) | `argocd app diff`, then `ignoreDifferences` or remove the fight |
| `Synced` but `Progressing` then `Degraded` | Image, probes, resources, crash | Resource tree, pod events and logs |
| `SyncFailed` on one resource | Invalid manifest (schema), immutable field, admission webhook | `--show-operation` |
| `... is not permitted in project` | AppProject source, destination or kind | `argocd proj get <project>` |
| `permission denied` | Argo CD RBAC for the logged-in account | `argocd account can-i ...` |
| Repo `Failed`, `authentication required` | Deploy key removed, wrong URL form, wrong credential | `argocd repo list` |
| Application stuck deleting | A resource with a finalizer that never completes | Resources with `deletionTimestamp` and `finalizers` |
