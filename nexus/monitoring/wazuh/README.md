
# Wazuh on Kubernetes

## Resources

- [Official Repo](https://github.com/wazuh/wazuh-kubernetes)

## Set up

1. Generate certificates
    ```bash
    ./certs/dashboard_http/generate_certs.sh \
    && ./certs/indexer_cluster/generate_certs.sh
    ```

2. Configure storage class \
    Modify `/base/storage-class.yaml` with your provisioner.

    Find your provisioner
    ```bash
    kubectl get sc
    ```

3. Configure Kubernetes Secrets \
    Copy all `.yaml.example` files to `.yaml` extension.
    ```bash
    cp secrets/dashboard-cred-secret.yaml.example dashboard-cred-secret.yaml && \
    cp secrets/indexer-cred-secret.yaml.example indexer-cred-secret.yaml && \
    cp secrets/wazuh-api-cred-secret.yaml.example wazuh-api-cred-secret.yaml && \
    cp secrets/wazuh-authd-pass-secret.yaml.example wazuh-authd-pass-secret.yaml && \
    cp secrets/wazuh-cluster-key-secret.yaml.example wazuh-cluster-key-secret.yaml
    ```
    > Don't modify passwords yet!

4. IP of Wazuh Manager \
    Modify the IP of Wazuh Manager Services in both:
      - `/wazuh_managers/master-svc.yaml`
      - `/wazuh_managers/wazuh-workers-svc.yaml` 

5. Apply all manifests using Kustomize
    ```bash
    kubectl apply -k .
    ```

## Default Credentials

| **User**        | **Username**   | **Password**                        |
|-----------------|----------------|-------------------------------------|
| Indexer         | admin          | SecretPassword                      |
| Kibana server   | kibanaserver   | kibanaserver                        |
| User            | user           | kibanaserver                        |
| Wazuh API       | wazuh-wui      | MyS3cr37P450r.*-                    |
| Wazuh auth      | N/A            | password                            |
| Cluster key     | N/A            | 123a45bc67def891gh23i45jk67l8mn9    |

> [Instructions to change default credentials](CHANGE_PASSWORDS.md)
