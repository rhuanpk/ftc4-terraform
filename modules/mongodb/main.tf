resource "kubernetes_persistent_volume" "mongodb_pv" {
  metadata {
    name = "mongodb-pv"
  }

  spec {
    capacity = {
      storage = "10Gi"
    }

    access_modes = ["ReadWriteOnce"]

    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      host_path {
        path = "/mnt/data"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mongodb_pvc" {
  metadata {
    name      = "mongodb-pvc"
    namespace = "mongodb"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_service" "mongo" {
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

resource "kubernetes_deployment" "mongo" {
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
          image = "mongo:latest"

          port {
            container_port = var.container_port
          }

          env {
            name  = "MONGO_INITDB_ROOT_USERNAME"
            value = var.MONGO_INITDB_ROOT_USERNAME
          }

          env {
            name  = "MONGO_INITDB_ROOT_PASSWORD"
            value = var.MONGO_INITDB_ROOT_PASSWORD
          }

          env {
            name  = "MONGO_INITDB_DATABASE"
            value = var.MONGO_INITDB_DATABASE
          }

          volume_mount {
            name       = "mongodb-pv"
            mount_path = "/data/db"
          }
        }
        volume {
          name = "mongodb-pv"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mongodb_pvc.metadata.0.name
          }
        }
      }
    }
  }
}
