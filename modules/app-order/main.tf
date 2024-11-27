resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      app = var.labels_app
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.labels_app
      }
    }

    template {
      metadata {
        labels = {
          app = var.labels_app
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.image

          port {
            container_port = var.container_port
            protocol       = "TCP"
          }

          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          resources {
            limits = {
              cpu    = var.resource_limits_cpu
              memory = var.resource_limits_memory
            }

            requests = {
              cpu    = var.resource_requests_cpu
              memory = var.resource_requests_memory
            }
          }
        }

        restart_policy = var.restart_policy
      }
    }
  }
}

resource "kubernetes_service" "app_order_service_load_balancer" {
  metadata {
    name      = "app-order-service-loadbalancer"
    namespace = var.namespace
  }

  spec {
    port {
      protocol    = "TCP"
      port        = var.application_port
      target_port = var.target_port
    }

    selector = {
      app = var.labels_app
    }

    type = "LoadBalancer"
  }
}

output "app_order_loadbalancer_hostname" {
  value = kubernetes_service.app_order_service_load_balancer.status[0].load_balancer[0].ingress[0].hostname
}

resource "kubernetes_service" "app_order" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    port {
      port        = var.port
      target_port = var.target_port
    }

    selector = {
      app = var.labels_app
    }
  }
}

module "app_order_autoscaling" {
  source              = "./autoscaling"
  name                = "${var.name}-hpa"
  namespace           = var.namespace
  target_kind         = "Deployment"
  target_name         = kubernetes_deployment.this.metadata.0.name
  api_version         = "apps/v1"
  min_replicas        = 1
  max_replicas        = 3
  metric_type         = "Resource"
  resource_name       = "cpu"
  target_type         = "Utilization"
  average_utilization = 50
}

module "app_order_pdb" {
  source        = "./pdb"
  name          = "${var.name}-pdb"
  namespace     = var.namespace
  min_available = 1
  match_labels = {
    app = var.labels_app
  }
}

module "app_order_replicaset" {
  source                   = "./replicaset"
  name                     = "${var.name}-replicaset"
  namespace                = var.namespace
  labels_app               = "${var.labels_app}-replicaset"
  replicas                 = 2
  container_name           = var.container_name
  image                    = var.image
  container_port           = var.container_port
  env_vars                 = var.env_vars
  resource_limits_cpu      = "1"
  resource_limits_memory   = "1Gi"
  resource_requests_cpu    = "500m"
  resource_requests_memory = "256Mi"
}
