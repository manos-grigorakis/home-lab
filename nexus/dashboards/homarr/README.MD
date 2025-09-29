# Homarr with Helm

## Resources
- [Official Docs](https://homarr.dev/docs/getting-started/installation/helm/)
- [Values Sample](https://github.com/homarr-labs/charts/blob/dev/charts/homarr/values.yaml)

## Requirements
Kubernetes: `>=1.24.0-0`

## Set up

### Configuration
```bash
cp values.yaml.example values.yaml
cp secret.yaml.example secret.yaml
```
Modify both `values.yaml` and `secret.yaml`

### Create namespace
```bash
kubectl create namespace homarr
```

### Apply Secret
```bash
kubectl apply -f secret.yaml
```

### Install Homarr using Helm
```bash
helm install homarr oci://ghcr.io/homarr-labs/charts/homarr -f values.yaml -n homarr
```

### Upgrade Homarr
```bash
helm upgrade homarr oci://ghcr.io/homarr-labs/charts/homarr -f values.yaml -n homarr
```

### Apply Ingress Route (Optional)
```bash
kubectl apply -f ingress-route.yaml
```

### Apply Certificate from Cert-Manager (Optional)
```bash
kubectl apply -f ../../k3s/cert-manager/certificates/homarr-certificate.yaml
```

### Uninstall Homarr
```bash
helm uninstall homarr -n homarr
```