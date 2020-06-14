# Ansible based Kubernetes Operator for Azure services
Why yet another Operator for Azure services? The Azure team develops [Azure Service Operator](https://github.com/Azure/azure-service-operator) that allows you to create Azure resources using kubectl.   
This Ansible based operator should show the simplicity of building an operator for external services and having the freedom for easy customization to address your workflow requirements by changing the Ansible roles.

# Installation
```
cat <<EOS | kubectl apply -f -
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: azure-service-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: quay.io/sbergste/azure-service-operator-index:v0.0.3
  displayName: Azure Service Operator Catalog
  publisher: StefanB
EOS
```
