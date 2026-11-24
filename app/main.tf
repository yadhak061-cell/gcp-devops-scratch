terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }
}

provider "google" {
  project = "project-e9e43bdd-fac9-4d30-bc5"
  region  = "asia-south1"
}

data "terraform_remote_state" "cluster" {
  backend = "local"
  config = {
    path = "../cluster/terraform.tfstate"
  }
}

data "google_container_cluster" "gke" {
  name     = data.terraform_remote_state.cluster.outputs.cluster_name
  location = data.terraform_remote_state.cluster.outputs.cluster_location
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_deployment" "sample_app" {
  metadata {
    name = "hello-nginx"
    labels = {
      app = "hello-nginx"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "hello-nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-nginx"
        }
      }
      spec {
        container {
          image = "nginx:alpine"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "sample_app_lb" {
  metadata {
    name = "hello-nginx-service"
  }
  spec {
    selector = {
      app = "hello-nginx"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
