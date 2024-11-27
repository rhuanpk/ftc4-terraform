variable "name" {
  description = "Nome do recurso"
  type        = string
  default     = "mongodb"
}

variable "namespace" {
  description = "Namespace do recurso"
  type        = string
}

variable "port" {
  description = "Porta do MongoDB"
  type        = number
  default     = 27017
}

variable "target_port" {
  description = "Porta de destino do MongoDB"
  type        = number
  default     = 27017
}

variable "labels_app" {
  description = "Label da aplicação"
  type        = string
  default     = "mongodb"
}

variable "replicas" {
  description = "Número de réplicas"
  type        = number
  default     = 1
}

variable "container_name" {
  description = "Nome do container"
  type        = string
  default     = "mongodb"
}

variable "container_port" {
  description = "Porta do container"
  type        = number
  default     = 27017
}

variable "MONGO_INITDB_ROOT_USERNAME" {
  description = "Usuário do banco de dados"
  type        = string
}

variable "MONGO_INITDB_ROOT_PASSWORD" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "MONGO_INITDB_DATABASE" {
  description = "Nome do banco de dados"
  type        = string
}
