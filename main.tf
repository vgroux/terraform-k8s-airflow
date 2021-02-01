variable "project" { 
  default = "default-project-name"
}

variable "credentials_file" {
  default = "filedoesntexist.json"
}

variable "region" {
  default = "hauts-de-france-north1"
}

variable "zone" {
  default = "hauts-de-france-north1-b"
}




terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "etl-panda-network"
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "random_string" "bucket" {
  length  = 8
  special = false
  upper   = false
}

resource "google_storage_bucket" "example_bucket" {
  name     = "learn-gcp-${random_string.bucket.result}"
  location = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "vm_instance" {
  name         = "etl-panda-instance-1"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  provisioner "local-exec" {
    command = "echo ${google_compute_instance.vm_instance.name}:  ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}

resource "google_compute_instance" "another_instance" {
  depends_on = [google_storage_bucket.example_bucket]

  name         = "etl-panda-instance-2"
  machine_type = "f1-micro"
  tags         = ["web", "dev", "bucket"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}