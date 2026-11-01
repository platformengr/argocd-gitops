# Sealed secrets for checkout-dev

`kubeseal` output goes here (module 08), for example `checkout-db.yaml`: a
SealedSecret that becomes the Secret `checkout-db` in namespace `checkout-dev`.
It only decrypts in the cluster that sealed it, so the reference has none.
