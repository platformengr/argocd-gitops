# Repository credentials

One ExternalSecret per private repository (module 08). Each one reads a deploy
key from the platform store (`store-platform`) and builds the Secret Argo CD
looks for: labelled `argocd.argoproj.io/secret-type: repository`, with `type`,
`url` and `sshPrivateKey`.

    secrets/repo-checkout-config.yaml   # ExternalSecret -> Secret argocd/repo-checkout-config

The file is a reference, not a secret: safe to commit. Never commit the private
key, a plain Secret, or `kubectl create secret ... -o yaml` output.
