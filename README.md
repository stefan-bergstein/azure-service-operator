# Ansible based Kubernetes Operator for Azure services
Why yet another Operator for Azure services? The Azure team develops [Azure Service Operator](https://github.com/Azure/azure-service-operator) that allows you to create Azure resources using kubectl.

This Ansible based operator should show the simplicity of building an operator for external services and having the freedom for easy customization to address your workflow requirements by changing the Ansible roles.

## Installation
```
cat <<EOS | kubectl apply -f -
---
apiVersion: operators.coreos.com/v1
kind: OperatorSource
metadata:
  name: azure-service-operators
spec:
  displayName: Azure Service Operators
  endpoint: https://quay.io/cnr
  
  publisher: StefanB
  registryNamespace: sbergste
  type: appregistry

EOS
```


## Prerequisites

The operator requires a secret with the name `azure-service-operator-azure-conf` in the target namespace of the operator.

First, create the target namespace for the operator:

```
oc new-project <azure-test>
```
 
Set the following environment variables:

```
AZURE_CLIENT_ID=<service_principal_client_id>
AZURE_SECRET=<service_principal_password>
AZURE_SUBSCRIPTION_ID=<azure_subscription_id>
AZURE_TENANT=<azure_tenant_id>
```

Create a secret:

```
oc create secret generic azure-service-operator-azure-conf \
  --from-literal=AZURE_TENANT=$AZURE_TENANT \
  --from-literal=AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID \
  --from-literal=AZURE_CLIENT_ID=$AZURE_CLIENT_ID \
  --from-literal=AZURE_SECRET=$AZURE_SECRET -n <azure-test>
```

## APIs

- Azure PostgreSQL (experimental)
- Azure MySQL (n/a)
- Azure CosmosDB (a/a)

