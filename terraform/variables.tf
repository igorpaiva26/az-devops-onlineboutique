variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "DevOpsGroup"
}

variable "location" {
  description = "Região do Azure"
  type        = string
  default     = "eastus"
}

variable "acr_name" {
  description = "Nome do Azure Container Registry"
  type        = string
  default     = "adapterboutiqueacr"
}

variable "aks_cluster_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "online-boutique-aks"
}

variable "aks_node_count" {
  description = "Número de nodes no AKS"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "Tamanho da VM para nodes do AKS"
  type        = string
  default     = "Standard_B2s"
}
