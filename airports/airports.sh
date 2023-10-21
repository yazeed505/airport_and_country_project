#!/bin/bash

# Set your Docker image name and version
DOCKER_IMAGE_NAME="airports-assembly"
DOCKER_IMAGE_VERSION="1.1.0"

# Set your Helm chart directory
HELM_CHART_DIR="./helm"

# Step 1: Docker build, tag, and push
docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION .
docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION yazeed505/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION
docker push yazeed505/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION

# Step 2: Change tag in Helm chart
sed -i '' "s/^ *tag: .*/  tag: $DOCKER_IMAGE_VERSION/" ${PWD}/airports/helm/values.yaml

# Step 3: Commit and push changes to GitHub
git add --all
git commit -m "Update Docker image tag in Helm chart"
git push

echo "Script completed successfully!"
