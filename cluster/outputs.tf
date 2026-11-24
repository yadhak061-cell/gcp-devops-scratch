output "cluster_name" {
  value = google_container_cluster.day1_cluster.name
}

output "cluster_location" {
  value = google_container_cluster.day1_cluster.location
}

output "cluster_endpoint" {
  value = google_container_cluster.day1_cluster.endpoint
}
