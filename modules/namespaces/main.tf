resource "kubernetes_namespace" "app-client" {
  metadata {
    name = "app-client"
  }
}
resource "kubernetes_namespace" "app-payment" {
  metadata {
    name = "app-payment"
  }
}
resource "kubernetes_namespace" "app-order" {
  metadata {
    name = "app-order"
  }
}
resource "kubernetes_namespace" "app-product" {
  metadata {
    name = "app-product"
  }
}
resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }
}
