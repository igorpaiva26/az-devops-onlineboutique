#!/bin/bash
set -e

ACR_NAME="adapterboutiqueacr.azurecr.io"
TAG="v1"

echo "=== Login no ACR ==="
az acr login --name adapterboutiqueacr

echo ""
echo "=== Building e Push das imagens ==="

services=(
  "frontend"
  "cartservice"
  "productcatalogservice"
  "currencyservice"
  "paymentservice"
  "shippingservice"
  "emailservice"
  "checkoutservice"
  "recommendationservice"
  "adservice"
)

for service in "${services[@]}"; do
  echo ""
  echo ">>> $service <<<"
  
  if [ "$service" = "cartservice" ]; then
    docker build -t $ACR_NAME/$service:$TAG -f boutique/src/cartservice/src/Dockerfile boutique/src/cartservice/src
  else
    docker build -t $ACR_NAME/$service:$TAG -f boutique/src/$service/Dockerfile boutique/src/$service
  fi
  
  docker push $ACR_NAME/$service:$TAG
  
  echo "✓ $service concluído"
done

echo ""
echo "=== Todas as imagens foram enviadas para o ACR! ==="
echo "Execute: kubectl apply -f online-boutique-cicd/online-boutique/k8s-specifications/"
