#!/bin/sh

BIN=/parrot
KUBECONFIG=/etc/kubernetes/config/kubelet
KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
NAMESPACE=kube-system
CONFIGMAP_NAME=node-metadata-$NODE_NAME
LOCAL_ADDRESS=$NODE_IP

CURL_URL=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$NAMESPACE/configmaps/$CONFIGMAP_NAME

MASTER_ADDRESS=$(curl -sSk \
    -H "Authorization: Bearer $KUBE_TOKEN" \
    -H 'Accept: application/json' \
    ${CURL_URL} | jq -r '.data.master_address')

SERVICE_SUBNET=$(curl -sSk \
    -H "Authorization: Bearer $KUBE_TOKEN" \
    -H 'Accept: application/json' \
    ${CURL_URL} | jq -r '.data.services_subnet_cidr')

BGP_AS=$(curl -sSk \
    -H "Authorization: Bearer $KUBE_TOKEN" \
    -H 'Accept: application/json' \
    ${CURL_URL} | jq -r '.data.bgp_remote_as')

NEIGHBOR0=$(curl -sSk \
    -H "Authorization: Bearer $KUBE_TOKEN" \
    -H 'Accept: application/json' \
    ${CURL_URL} | jq -r '.data.bgp_neighbor0')

NEIGHBOR1=$(curl -sSk \
    -H "Authorization: Bearer $KUBE_TOKEN" \
    -H 'Accept: application/json' \
    ${CURL_URL} | jq -r '.data.bgp_neighbor1')

$BIN --local_address=$LOCAL_ADDRESS --master_address=$MASTER_ADDRESS --service_subnet=$SERVICE_SUBNET --as=$BGP_AS --kubeconfig=$KUBECONFIG --neighbor=$NEIGHBOR0 --neighbor=$NEIGHBOR1 --v=5 --logtostderr