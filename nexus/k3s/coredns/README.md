# Custom Core DNS with fallback to Public DNS

## Apply the manifest file
```bash
    kubectl apply -f coredns-custom.yaml
```

## Restart the CoreDNS
```bash
    kubectl -n kube-system rollout restart deploy coredns
```