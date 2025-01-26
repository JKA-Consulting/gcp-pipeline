resource "google_compute_instance" "jenkins-instance" {
  name         = "jenkins-instance"
  machine_type = "e2-medium"      
  zone         = var.subnet-zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20 # Boot disk size in GB
    }
  }

  network_interface {
    network    = google_compute_network.marketplace-vpc.name
    subnetwork = google_compute_subnetwork.marketplace-subnet1.name

  }

  # metadata_startup_script = "${file("/jenkinsScript.sh")}"

  metadata_startup_script = <<-EOT
            #!/bin/bash

            sudo apt update
            sudo apt install fontconfig openjdk-17-jre -y
            java -version
            sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
            echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
            sudo apt-get update
            sudo apt-get install jenkins
            sudo systemctl enable jenkins
            sudo systemctl start jenkins
            sudo systemctl status jenkins
        EOT
}

resource "google_compute_firewall" "allow-ssh-rdp-icmp" {
  name    = "allow-ssh-rdp-icmp"
  network = google_compute_network.marketplace-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3389", "80", "8080"] #allowing ssh, rdp and http
  }

  allow {
    protocol = "icmp" #allowing pings
  }

  source_ranges = ["0.0.0.0/0"] #allowing incoming traffic from the specified network address, in this case all addresses are allowed
}
