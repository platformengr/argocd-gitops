# Three kinds of repository

| | Application repository | Environment repository | Shared platform repository |
| --- | --- | --- | --- |
| Example | `checkout-app` | `checkout-config` | `argocd-platform` |
| Owner | The product team | The product team | The platform team |
| Holds | Source, tests, CI, Helm chart | Values per environment, sealed secrets | Argo CD config, Applications, AppProjects, namespaces, add-ons |
| Changes | Every code change; released by tag | Every deploy and promotion | Onboarding, access, upgrades |
| Argo CD reads | One tag (`v1.0.0`) | `main` | `main` |
| Who can break prod | A release, only once an environment points at it | A merged pull request | Anything: highest blast radius |
| Typical review | Team | Team; prod changes need a second person | Platform team, CODEOWNERS for team files |

## Why not one repo?

Different cadence and different owners. Code changes many times a day and most
of those changes should not deploy anywhere by themselves. Environment changes are
deploys: small, frequent, reviewed with prod in mind. Platform changes are rare
and affect every team. Mixing them means every CI run, every reviewer and every
permission covers all three.

## Multiple sources: when, and when not

An Application can combine sources: the chart from the application repo and the
values from the environment repo, as `checkout-dev` does. Use it to assemble
**one application** from parts with different owners.

Do not use multiple sources to group unrelated things into one Application
(the Argo CD documentation warns about this explicitly): you lose independent
sync, health and history. To group Applications, use an app of apps, like `root`.
