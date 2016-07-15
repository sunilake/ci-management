#!/bin/bash -eu
set -o pipefail

BRANCH=${GIT_BRANCH##*/}
TAG=${GIT_COMMIT:0:7}
PEER_IMAGE="$(docker images -q hyperledger/fabric-peer)"
MEMBERSERVC_IMAGE="$(docker images -q hyperledger/fabric-membersrvc)"

echo "COMMIT NUMBER: " $TAG
echo "Branch Name: " $BRANCH
echo "peer image: " $PEER_IMAGE
echo "membersrvc image: " $MEMBERSERVC_IMAGE

docker tag $PEER_IMAGE hyperledger/fabric-peer:$BRANCH-$TAG
docker tag -f $PEER_IMAGE hyperledger/fabric-peer:latest
docker tag $MEMBERSERVC_IMAGE hyperledger/fabric-membersrvc:$BRANCH-$TAG
docker tag -f $MEMBERSERVC_IMAGE hyperledger/fabric-membersrvc:latest

echo "--> Logging into Docker Hub"
docker login --email=$DOCKER_HUB_EMAIL --username=$DOCKER_HUB_USERNAME --password=$DOCKER_HUB_PASSWORD

echo "--> Pushing Docker Tags to Docker Hub"
docker push hyperledger/fabric-peer:$BRANCH-$TAG
docker push hyperledger/fabric-peer:latest
docker push hyperledger/fabric-membersrvc:$BRANCH-$TAG
docker push hyperledger/fabric-membersrvc:latest
