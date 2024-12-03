terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster_info.endpoint
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster_info.certificate_authority[0].data)
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = ["us-east-1a", "us-east-1b"][count.index]
  map_public_ip_on_launch = true
}

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

module "eks_cluster" {
  source             = "./modules/eks-cluster"
  cluster_name       = "cluster-ftc4"
  cluster_role_arn   = data.aws_iam_role.lab_role.arn
  subnet_ids         = aws_subnet.public_subnets.*.id
  kubernetes_version = "1.24"
}

module "eks_cluster_nodes" {
  source        = "./modules/nodes"
  cluster_name  = module.eks_cluster.cluster_name
  node_role_arn = module.eks_cluster.cluster_role_arn_iam
  subnet_ids    = aws_subnet.public_subnets.*.id
}

data "aws_eks_cluster" "cluster_info" {
  depends_on = [module.eks_cluster]
  name       = module.eks_cluster.cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  depends_on = [module.eks_cluster]
  name       = module.eks_cluster.cluster_name
}

module "namespace" {
  source = "./modules/namespaces"
}

module "app_client_deployment" {
  source         = "./modules/app-client"
  name           = "app-client"
  namespace      = "app-client"
  labels_app     = "app-client"
  replicas       = 1
  container_name = "app-client"
  image          = "filipeborba/app-client:v2"
  container_port = 8080
  env_vars = {
    "SPRING_DATA_MONGODB_URI" = {
      name  = "SPRING_DATA_MONGODB_URI"
      value = var.mongodb_uri
    }
    "SPRING_DATA_MONGODB_DATABASE" = {
      name  = "SPRING_DATA_MONGODB_DATABASE"
      value = var.mongodb_database
    }
  }
  resource_limits_cpu      = "1"
  resource_limits_memory   = "1Gi"
  resource_requests_cpu    = "500m"
  resource_requests_memory = "256Mi"
  restart_policy           = "Always"
  port                     = 8080
  target_port              = 8080
  application_port         = 4000
  depends_on               = [module.namespace]
}

module "app_product_deployment" {
  source         = "./modules/app-product"
  name           = "app-product"
  namespace      = "app-product"
  labels_app     = "app-product"
  replicas       = 1
  container_name = "app-product"
  image          = "filipeborba/app-product:v2"
  container_port = 8080
  env_vars = {
    "SPRING_DATASOURCE_URL" = {
      name  = "SPRING_DATASOURCE_URL"
      value = var.mysql_product_uri
    }
    "SPRING_DATASOURCE_USERNAME" = {
      name  = "SPRING_DATASOURCE_USERNAME"
      value = var.mysql_user
    }
    "SPRING_DATASOURCE_PASSWORD" = {
      name  = "SPRING_DATASOURCE_PASSWORD"
      value = var.mysql_password
    }
  }
  resource_limits_cpu      = "1"
  resource_limits_memory   = "1Gi"
  resource_requests_cpu    = "500m"
  resource_requests_memory = "256Mi"
  restart_policy           = "Always"
  port                     = 8080
  target_port              = 8080
  application_port         = 4000
  depends_on               = [module.namespace]
}

module "app_order_deployment" {
  source         = "./modules/app-order"
  name           = "app-order"
  namespace      = "app-order"
  labels_app     = "app-order"
  replicas       = 1
  container_name = "app-order"
  image          = "filipeborba/app-order:v2"
  container_port = 8080
  env_vars = {
    "MYSQL_URI" = {
      name  = "MYSQL_URI"
      value = var.mysql_order_uri
    }
    "MYSQL_USER" = {
      name  = "MYSQL_USER"
      value = var.mysql_user
    }
    "MYSQL_PASSWORD" = {
      name  = "MYSQL_PASSWORD"
      value = var.mysql_password
    }
  }
  resource_limits_cpu      = "1"
  resource_limits_memory   = "1Gi"
  resource_requests_cpu    = "500m"
  resource_requests_memory = "256Mi"
  restart_policy           = "Always"
  port                     = 8080
  target_port              = 8080
  application_port         = 4000
  depends_on               = [module.namespace]
}

module "app_payment_deployment" {
  source         = "./modules/app-payment"
  name           = "app-payment"
  namespace      = "app-payment"
  labels_app     = "app-payment"
  replicas       = 1
  container_name = "app-payment"
  image          = "filipeborba/app-payment:v2"
  container_port = 8080
  env_vars = {
    "MYSQL_URI" = {
      name  = "MYSQL_URI"
      value = var.mysql_payment_uri
    }
    "MYSQL_USER" = {
      name  = "MYSQL_USER"
      value = var.mysql_user
    }
    "MYSQL_PASSWORD" = {
      name  = "MYSQL_PASSWORD"
      value = var.mysql_password
    }
    "URL_API_ORDER" = {
      name  = "URL_API_ORDER"
      value = "http://${module.app_order_deployment.app_order_loadbalancer_hostname}:4000/"
    }
  }
  resource_limits_cpu      = "1"
  resource_limits_memory   = "1Gi"
  resource_requests_cpu    = "500m"
  resource_requests_memory = "256Mi"
  restart_policy           = "Always"
  port                     = 8080
  target_port              = 8080
  application_port         = 4000
  depends_on               = [module.namespace, module.app_order_deployment]
}


