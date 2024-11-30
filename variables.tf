variable "mongodb_uri" {
  description = "Host do MongoDB"
  type        = string
  default     = "mongodb+srv://root:root@cliente-cluster.ejjve.mongodb.net/?retryWrites=true&w=majority&appName=cliente-cluster"
}

variable "mongodb_database" {
  description = "Database do MongoDB"
  type        = string
  default     = "cliente"
}

variable "mysql_product_uri" {
  description = "Host do MySQL"
  type        = string
  default     = "jdbc:mysql://mysql-ftc4-product.cl5uqyhyrufj.us-east-1.rds.amazonaws.com:3306/product?useSSL=false&allowPublicKeyRetrieval=true"
}

variable "mysql_payment_uri" {
  description = "Host do MySQL"
  type        = string
  default     = "jdbc:mysql://mysql-ftc4-payment.cl5uqyhyrufj.us-east-1.rds.amazonaws.com:3306/payment?useSSL=false&allowPublicKeyRetrieval=true"
}

variable "mysql_order_uri" {
  description = "Host do MySQL"
  type        = string
  default     = "jdbc:mysql://mysql-ftc4-order.cl5uqyhyrufj.us-east-1.rds.amazonaws.com:3306/order_db?useSSL=false&allowPublicKeyRetrieval=true"
}

variable "mysql_user" {
  description = "Usuário do MySQL"
  type        = string
  default     = "admin"
}

variable "mysql_password" {
  description = "Senha do MySQL"
  type        = string
  default     = "admin123"
}
