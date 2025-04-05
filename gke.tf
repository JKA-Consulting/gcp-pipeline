# Get the latest available GKE version in the specified zone
data "google_container_engine_versions" "gke_version" {
  location = var.subnet_zone
}

# GKE Cluster Resource (without default node pool)
resource "google_container_cluster" "demo-cluster" {
  name                     = "${var.project_id}-gke"
  location                 = var.subnet_zone
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.demo-vpc.name
  subnetwork = google_compute_subnetwork.demo-subnet1.name

  ip_allocation_policy {}

  # Optional: if using a release channel instead of manual version pinning
  # release_channel {
  #   channel = "REGULAR"
  # }
}

# Node Pool Resource using the latest available GKE version
resource "google_container_node_pool" "demo-cluster-nodes" {
  name       = "${var.project_id}-node-pool"
  location   = var.subnet_zone
  cluster    = google_container_cluster.demo-cluster.name
  node_count = 1

  version    = data.google_container_engine_versions.gke_version.latest_node_version

  node_config {
    machine_type = "n1-standard-1"

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
