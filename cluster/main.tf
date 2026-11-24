terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = "project-e9e43bdd-fac9-4d30-bc5"
  region  = "asia-south1"
}

resource "google_container_cluster" "day1_cluster" {
  name                     = "day1-gke-cluster"
  location                 = "asia-south1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "day1-node-pool"
  location   = "asia-south1-a"
  cluster    = google_container_cluster.day1_cluster.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 20
    disk_type    = "pd-standard"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
