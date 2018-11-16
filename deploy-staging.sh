#!/bin/bash

set -e
pwd
echo "Deploy"
echo $GCLOUD_SERVICE_KEY_STG | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
echo "Auth successful"



echo $PROJECT_NAME_STG
echo $CLUSTER_NAME_STG
echo ${CLOUDSDK_COMPUTE_ZONE}
echo $CLUSTER_NAME_STG

gcloud --quiet config set project $PROJECT_NAME_STG
gcloud --quiet config set container/cluster $CLUSTER_NAME_STG
gcloud --quiet config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials $CLUSTER_NAME_STG

echo "About to build"
cd $TRAVIS_BUILD_DIR/docker/build_context
docker build -t gcr.io/${PROJECT_NAME_PRD}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT .
cd $TRAVIS_BUILD_DIR

echo "About to push to cloud"
cd build/
gcloud docker push gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}
cd $TRAVIS_BUILD_DIR

echo "push successful"
yes | gcloud beta container images add-tag gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:latest

echo "tag successful"

kubectl config view
kubectl config current-context

kubectl set image deployment/${KUBE_DEPLOYMENT_NAME} ${KUBE_DEPLOYMENT_CONTAINER_NAME}=gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT
