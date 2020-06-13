
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

ver=v0.0.6
operator-sdk bundle create quay.io/sbergste/azure-service-operator-catalog --channels alpha --package azure-service-operator-catalog --directory deploy/olm-catalog/azure-service-operator/manifests/
docker tag quay.io/sbergste/azure-service-operator-catalog:latest quay.io/sbergste/azure-service-operator-catalog:${ver}
docker push quay.io/sbergste/azure-service-operator-catalog:${ver}
opm index add -c docker --bundles quay.io/sbergste/azure-service-operator-catalog:${ver} --tag quay.io/sbergste/azure-service-operator-index:${ver}
docker push quay.io/sbergste/azure-service-operator-index:${ver}
;;

*)
            echo $"Usage: $0 {bundle}"
            exit 1
esac


