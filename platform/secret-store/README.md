# Secret stores

One store per team (module 08). Each file holds the store's namespace, the
`eso-reader` identity External Secrets uses to read it, and a
`ClusterSecretStore` whose `conditions` list the only namespaces allowed to read
from it.

    secret-store/platform.yaml   # store-platform  -> readable from argocd
    secret-store/checkout.yaml   # store-checkout  -> readable from checkout-dev, checkout-prod

The values themselves never come from Git. On kind you put them in the store
namespace with `kubectl create secret`; in production a vault holds them.
Onboarding a team means copying a file and changing the names (module 13).
