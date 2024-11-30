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
            requests = {
              cpu    = var.resource_requests_cpu
              memory = var.resource_requests_memory
            }
            limits = {
              cpu    = var.resource_limits_cpu
              memory = var.resource_limits_memory
            }
          }
        }
      }
    }
  }
}
