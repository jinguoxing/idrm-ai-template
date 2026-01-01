#!/bin/bash

# Docker 镜像构建脚本

set -e

REGISTRY=${REGISTRY:-"ghcr.io/myorg"}
TAG=${TAG:-"latest"}
SERVICES=("api" "rpc" "job" "consumer")

echo "Building Docker images..."
echo "Registry: $REGISTRY"
echo "Tag: $TAG"
echo ""

for svc in "${SERVICES[@]}"; do
    IMAGE="$REGISTRY/idrm-$svc:$TAG"
    echo "Building $IMAGE..."
    docker build -f deploy/docker/Dockerfile.$svc -t "$IMAGE" .
    echo "✅ Built $IMAGE"
    echo ""
done

echo "All images built successfully!"
echo ""
echo "To push images:"
for svc in "${SERVICES[@]}"; do
    echo "  docker push $REGISTRY/idrm-$svc:$TAG"
done
