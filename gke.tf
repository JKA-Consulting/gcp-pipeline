# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location       = var.region
  version_prefix = "1.27."
}

resource "google_container_cluster" "demo-cluster" {
  name                     = "${var.project-id}-gke"
  location                 = var.subnet-zone
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.demo-vpc.name
  subnetwork               = google_compute_subnetwork.demo-subnet1.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "demo-cluster-nodes" {
  name       = google_container_cluster.demo-cluster.name
  location   = var.subnet-zone
  cluster    = google_container_cluster.demo-cluster.name
  //version    = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project-id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project-id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}