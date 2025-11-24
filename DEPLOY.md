# Online Boutique - Guia de Deploy Completo

## Arquitetura

- **Aplicação**: Google Online Boutique (10 microserviços)
- **CI/CD**: Azure DevOps Pipelines
- **Registry**: Azure Container Registry (<your-acr-name>.azurecr.io)
- **Orquestração**: Azure Kubernetes Service (AKS)
- **GitOps**: ArgoCD (futuro)

## Infraestrutura Provisionada

### Azure Resources
- **Resource Group**: DevOpsGroup (eastus)
- **ACR**: <your-acr-name>.azurecr.io (Basic tier)
- **AKS**: online-boutique-aks (1 node Standard_B2s)
- **Custo estimado**: ~$1.20/dia

### Credenciais ACR
```bash
# Obter credenciais após provisionar:
az acr credential show --name <seu-acr-name>
```

## Pré-requisitos

- Azure CLI instalado e autenticado
- kubectl configurado
- Acesso ao Azure DevOps
- Agent Pool 'azureagent' configurado

## 1. Teste Local (Docker Compose)

### Iniciar aplicação localmente
```bash
cd /home/igor/az-devops
./start-local.sh
```
Acesse: http://localhost:9090

### Parar aplicação
```bash
./stop-local.sh
```

## 2. Configurar Azure DevOps

### 2.1 Criar Service Connection para ACR
1. Acesse Azure DevOps > Project Settings > Service Connections
2. New Service Connection > Docker Registry
3. Preencha:
   - Registry type: Azure Container Registry
   - Subscription: DevOpsProject
   - Azure container registry: <your-acr-name>
   - Service connection name: <your-acr-name>
   - **ID deve ser**: ee79c0cd-50e2-439c-8aa7-7c7287757b38

### 2.2 Criar Azure Repos
1. Acesse Azure DevOps > Repos
2. Importe ou crie repositório com o código
3. Push do código local:
```bash
cd /home/igor/az-devops/online-boutique-cicd
git remote add azure https://dev.azure.com/<org>/<project>/_git/online-boutique
git push azure main
```

### 2.3 Criar Pipelines
Crie 10 pipelines, um para cada serviço:

1. **frontend**: Azure Pipelines/azure-pipelines-frontend.yml
2. **cartservice**: Azure Pipelines/azure-pipelines-cartservice.yml
3. **productcatalogservice**: Azure Pipelines/azure-pipelines-productcatalogservice.yml
4. **checkoutservice**: Azure Pipelines/azure-pipelines-checkoutservice.yml
5. **adservice**: Azure Pipelines/azure-pipelines-adservice.yml
6. **shippingservice**: Azure Pipelines/azure-pipelines-shippingservice.yml
7. **paymentservice**: Azure Pipelines/azure-pipelines-paymentservice.yml
8. **currencyservice**: Azure Pipelines/azure-pipelines-currencyservice.yml
9. **emailservice**: Azure Pipelines/azure-pipelines-emailservice.yml
10. **recommendationservice**: Azure Pipelines/azure-pipelines-recommendationservice.yml

## 3. Build e Push das Imagens

### Executar todos os pipelines manualmente
Cada pipeline irá:
1. Build da imagem Docker
2. Push para <your-acr-name>.azurecr.io
3. Atualizar manifesto K8s com nova tag

### Verificar imagens no ACR
```bash
az acr repository list --name <your-acr-name> --output table
```

## 4. Deploy no AKS

### 4.1 Configurar kubectl
```bash
az aks get-credentials --resource-group DevOpsGroup --name online-boutique-aks
kubectl get nodes
```

### 4.2 Deploy dos manifestos K8s
```bash
cd /home/igor/az-devops/online-boutique-cicd/online-boutique/k8s-specifications

# Deploy de todos os serviços
kubectl apply -f .

# Verificar pods
kubectl get pods

# Verificar services
kubectl get svc
```

### 4.3 Acessar aplicação
```bash
# Obter IP externo do frontend
kubectl get svc frontend

# Aguardar LoadBalancer provisionar IP externo
# Acesse: http://<EXTERNAL-IP>
```

## 5. Destruir Infraestrutura

### Remover recursos do AKS
```bash
kubectl delete -f /home/igor/az-devops/online-boutique-cicd/online-boutique/k8s-specifications/
```

### Destruir infraestrutura Azure
```bash
cd /home/igor/az-devops/terraform
terraform destroy
```

Confirme com `yes`. Tempo estimado: ~5 minutos.

## Estrutura do Projeto

```
az-devops/
├── boutique/                          # Código fonte Online Boutique
│   └── src/
│       ├── frontend/
│       ├── cartservice/
│       ├── productcatalogservice/
│       ├── checkoutservice/
│       ├── adservice/
│       ├── shippingservice/
│       ├── paymentservice/
│       ├── currencyservice/
│       ├── emailservice/
│       └── recommendationservice/
├── online-boutique-cicd/              # Configurações CI/CD
│   ├── Azure Pipelines/               # 10 pipelines YAML
│   ├── online-boutique/
│   │   └── k8s-specifications/        # 10 manifestos K8s
│   ├── scripts/
│   │   └── updateK8sManifests.sh      # Script de atualização
│   └── docker-compose-test.yml        # Teste local
├── terraform/                         # Infraestrutura como código
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── start-local.sh                     # Iniciar teste local
├── stop-local.sh                      # Parar teste local
└── DEPLOY.md                          # Este arquivo
```

## Microserviços

| Serviço | Linguagem | Porta | Descrição |
|---------|-----------|-------|-----------|
| frontend | Go | 8080 | Interface web |
| cartservice | C# | 7070 | Carrinho de compras |
| productcatalogservice | Go | 3550 | Catálogo de produtos |
| currencyservice | Node.js | 7000 | Conversão de moedas |
| paymentservice | Node.js | 50051 | Processamento de pagamento |
| shippingservice | Go | 50051 | Cálculo de frete |
| emailservice | Python | 8080 | Envio de emails |
| checkoutservice | Go | 5050 | Finalização de compra |
| recommendationservice | Python | 8080 | Recomendações |
| adservice | Java | 9555 | Anúncios |


