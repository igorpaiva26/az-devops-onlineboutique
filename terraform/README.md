# Terraform - Online Boutique Infrastructure

## Recursos provisionados

- **Azure Container Registry (ACR)**: chetanazurecicd.azurecr.io
- **Azure Kubernetes Service (AKS)**: Cluster com 1 node (Standard_B2s)
- **Role Assignment**: Permissão para AKS acessar ACR

## Custo estimado

- **ACR Basic**: ~$0.17/dia
- **AKS (1 node B2s)**: ~$1/dia
- **Total**: ~$1.20/dia

## Comandos

### Provisionar infraestrutura
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Obter credenciais do AKS
```bash
az aks get-credentials --resource-group DevOpsGroup --name online-boutique-aks
```

### Obter credenciais do ACR
```bash
terraform output -raw acr_admin_username
terraform output -raw acr_admin_password
```

### Destruir infraestrutura
```bash
terraform destroy
```

## Após provisionar

1. Configure kubectl: `az aks get-credentials --resource-group DevOpsGroup --name online-boutique-aks`
2. Verifique nodes: `kubectl get nodes`
3. Configure Azure DevOps com credenciais do ACR
4. Execute pipelines para build e push das imagens
5. Deploy dos manifestos K8s no AKS
