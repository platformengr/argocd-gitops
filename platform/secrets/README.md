# Sealed repository credentials

`kubeseal` output for repository Secrets goes here, one file per repository
(module 08). A SealedSecret only decrypts in the cluster whose key sealed it, so
this folder is empty in the reference: you generate your own.

    secrets/repo-checkout-config.yaml   # SealedSecret -> Secret argocd/repo-checkout-config

Never commit the private key, the plain Secret, or `kubectl create secret ... -o yaml` output.
