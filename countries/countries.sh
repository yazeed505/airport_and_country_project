#!/bin/bash

# Set your Docker image name and version
DOCKER_IMAGE_NAME="countries-assembly"
DOCKER_IMAGE_VERSION="1.0.1"

# Step 1: Docker build, tag, and push
docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION countries/.
docker tag $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION yazeed505/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION
docker push yazeed505/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION

# Step 2: Change tag in Helm chart
sed -i '' "s/^ *tag: .*/  tag: $DOCKER_IMAGE_VERSION/" ${PWD}/countries/helm/values.yaml

# Step 3: Commit and push changes to GitHub
git add --all
git commit -m "Update Docker image tag in Helm chart"
git push

echo "Script completed successfully!"
