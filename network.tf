resource "google_compute_network" "demo-vpc" {
  name                    = "demo-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demo-subnet1" {
  name          = "subnet-1"
  region        = var.subnet_region
  network       = google_compute_network.demo-vpc.id
  ip_cidr_range = var.subnet_cidr # Replace with your desired IP range
}
