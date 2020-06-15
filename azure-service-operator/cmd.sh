#!/bin/bash

case "$1" in

secret)

oc create secret generic azure-service-operator-azure-conf --from-literal=AZURE_TENANT=$AZURE_TENANT --from-literal=AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID --from-literal=AZURE_CLIENT_ID=$AZURE_CLIENT_ID --from-literal=AZURE_SECRET=$AZURE_SECRET

;;


build)

operator-sdk build quay.io/sbergste/azure-service-operator:v0.0.1
docker push quay.io/sbergste/azure-service-operator:v0.0.1
oc create -f deploy/service_account.yaml
oc create -f deploy/role.yaml
oc create -f deploy/role_binding.yaml
oc create -f deploy/operator.yaml

;;


bundle)

ver=0.0.1


echo "Verify bundle ..."
operator-courier verify deploy/olm-catalog/azure-service-operator/${ver}/
operator-courier verify --ui_validate_io  deploy/olm-catalog/azure-service-operator/${ver}/


if [ -z "$QUAY_TOKEN" ]
then
      echo "\$QUAY_TOKEN is empty. Exiting ..."
      exit
fi

if [ -z "$QUAY_NAMESPACE" ]
then
      echo "\$QUAY_NAMESPACE is empty. Exiting ..."
      exit
fi
      

echo "Push bundle ..."
operator-courier push deploy/olm-catalog/azure-service-operator/0.0.1 $QUAY_NAMESPACE azure-service-operators ${ver} "$QUAY_TOKEN"

echo "Please make application on quay.io public  ..."

;;

deploy)

echo "Delete and create operatorsource ..."
oc delete -f deploy/operatorsource.yaml -n openshift-marketplace
oc create -f deploy/operatorsource.yaml -n openshift-marketplace
oc get opsrc -n openshift-marketplace

;;




*)
            echo $"Usage: $0 {secret|build|bundle|deploy}"
            exit 1
esac


