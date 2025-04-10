# Get the latest available GKE versions in the specified zone
# data "google_container_engine_versions" "gke_version" {
#   location = var.subnet_zone
# }

# GKE Cluster Resource (without default node pool)
resource "google_container_cluster" "demo-cluster" {
  name                     = "${var.project_id}-gke"
  location                 = var.subnet_zone
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.demo-vpc.name
  subnetwork = google_compute_subnetwork.demo-subnet1.name

  ip_allocation_policy {}

  # Explicitly set the master version to match latest available
  # min_master_version = data.google_container_engine_versions.gke_version.latest_master_version
}

# Node Pool Resource using the latest available node version
resource "google_container_node_pool" "demo-cluster-nodes" {
  name       = "${var.project_id}-node-pool"
  location   = var.subnet_zone
  cluster    = google_container_cluster.demo-cluster.name
  node_count = 1

  # version    = data.google_container_engine_versions.gke_version.latest_node_version

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-standard-4"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    tags = [
      "gke-node",
      "${var.project_id}-gke"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
