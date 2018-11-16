#!/bin/bash

set -e

echo $GCLOUD_SERVICE_KEY_STG | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

cp ci_cd.yml ci_cd_staging.yml

sed -i.bak "s/_PROJECT_NAME_STG_/$PROJECT_NAME_STG/g" ci_cd_staging.yml
sed -i.bak "s/_DOCKER_IMAGE_NAME_/$DOCKER_IMAGE_NAME/g" ci_cd_staging.yml
sed -i.bak "s/_TRAVIS_COMMIT_/$TRAVIS_COMMIT/g" ci_cd_staging.yml

gcloud --quiet config set project $PROJECT_NAME_STG
gcloud --quiet config set container/cluster $CLUSTER_NAME_STG
gcloud --quiet config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials $CLUSTER_NAME_STG


cd $TRAVIS_BUILD_DIR/docker/build_context
docker build -t gcr.io/${PROJECT_NAME_PRD}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT .
cd $TRAVIS_BUILD_DIR

cd build/
gcloud docker -- push gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}
cd $TRAVIS_BUILD_DIR

yes | gcloud beta container images add-tag gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:latest


kubectl config view
kubectl config current-context

kubectl apply -f ci_cd_staging.yml
kubectl apply -f ci_cd_service.yml
