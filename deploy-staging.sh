#!/bin/bash

set -e
pwd
echo "Deploy"
echo $GCLOUD_SERVICE_KEY_STG | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
echo "Auth successful"

cp ci_cd.yml ci_cd_staging.yml

sed -i.bak "s/_PROJECT_NAME_STG_/$PROJECT_NAME_STG/g" ci_cd_staging.yml
sed -i.bak "s/_DOCKER_IMAGE_NAME_/$DOCKER_IMAGE_NAME/g" ci_cd_staging.yml
sed -i.bak "s/_TRAVIS_COMMIT_/$TRAVIS_COMMIT/g" ci_cd_staging.yml

cat ci_cd_staging.yml

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
gcloud docker -- push gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}
cd $TRAVIS_BUILD_DIR

echo "push successful"
yes | gcloud beta container images add-tag gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:latest

echo "tag successful"

kubectl config view
kubectl config current-context

kubectl create -f ci_cd_staging.yml


#kubectl run ${KUBE_DEPLOYMENT_NAME} --image=gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT --port=8080

#kubectl set image deployment/${KUBE_DEPLOYMENT_NAME} ${KUBE_DEPLOYMENT_CONTAINER_NAME}=gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT
