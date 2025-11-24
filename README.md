# Online Boutique - Azure DevOps + AKS + ArgoCD

Projeto de demonstração de CI/CD usando Azure DevOps, Azure Kubernetes Service (AKS) e GitOps com ArgoCD.

## 🚀 Quick Start

### Teste Local
```bash
./start-local.sh
# Acesse: http://localhost:9090
./stop-local.sh
```

### Deploy no Azure
Veja instruções completas em [DEPLOY.md](DEPLOY.md)

## 📋 Componentes

- **Aplicação**: Google Online Boutique (10 microserviços)
- **CI/CD**: Azure DevOps Pipelines
- **Container Registry**: Azure Container Registry
- **Orquestração**: Azure Kubernetes Service
- **IaC**: Terraform
- **GitOps**: ArgoCD (futuro)

## 🏗️ Arquitetura

```
┌─────────────────┐
│  Azure DevOps   │
│   (Pipelines)   │
└────────┬────────┘
         │ Build & Push
         ▼
┌─────────────────┐
│      ACR        │
│ adapterboutique │
│   acr.io        │
└────────┬────────┘
         │ Pull Images
         ▼
┌─────────────────┐
│      AKS        │
│  online-boutique│
│   -aks          │
└─────────────────┘
```

## 📦 Microserviços

1. **frontend** - Interface web (Go)
2. **cartservice** - Carrinho (C#)
3. **productcatalogservice** - Catálogo (Go)
4. **currencyservice** - Moedas (Node.js)
5. **paymentservice** - Pagamento (Node.js)
6. **shippingservice** - Frete (Go)
7. **emailservice** - Email (Python)
8. **checkoutservice** - Checkout (Go)
9. **recommendationservice** - Recomendações (Python)
10. **adservice** - Anúncios (Java)

## 💰 Custos

- **ACR Basic**: ~$0.17/dia
- **AKS (1 node B2s)**: ~$1/dia
- **Total**: ~$1.20/dia

## 📚 Documentação

- [DEPLOY.md](DEPLOY.md) - Guia completo de deploy
- [terraform/README.md](terraform/README.md) - Infraestrutura

## 🛠️ Tecnologias

- Azure DevOps
- Azure Container Registry
- Azure Kubernetes Service
- Terraform
- Docker
- Kubernetes
- ArgoCD (futuro)

## 📝 Licença

Este projeto é baseado no [Google Cloud Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo)
