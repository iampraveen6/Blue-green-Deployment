#!/bin/bash

# Set image tags
BLUE_IMAGE="bluegreen-frontend-blue:1.0"
GREEN_IMAGE="bluegreen-frontend-green:1.0"

echo "🔧 Building frontend-blue image..."
cd ../frontend-blue || exit
docker build -t $BLUE_IMAGE .

echo "📦 Loading frontend-blue image into Minikube..."
minikube image load $BLUE_IMAGE

echo "🔧 Building frontend-green image..."
cd ../frontend-green || exit
docker build -t $GREEN_IMAGE .

echo "📦 Loading frontend-green image into Minikube..."
minikube image load $GREEN_IMAGE

echo "🚀 Restarting frontend-blue deployment..."
kubectl rollout restart deployment/frontend-blue -n bluegreen

echo "🚀 Restarting frontend-green deployment..."
kubectl rollout restart deployment/frontend-green -n bluegreen

echo "📡 Monitoring rollout status..."
kubectl rollout status deployment/frontend-blue -n bluegreen
kubectl rollout status deployment/frontend-green -n bluegreen

echo "✅ Blue-Green deployment updated successfully!"