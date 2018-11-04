/*
   Instances
*/

// Public-facing Instances ====================================================
resource "google_compute_instance" "proxy_instance" {
  name         = "${var.deployment_name}-proxy-instance"
  machine_type = "${var.proxy_instance_size}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.deployment_subnetwork_public.self_link}"
    access_config = {}
  }

  labels = {
    deployment = "${var.deployment_name}"
    service    = "proxy"
  }

  tags = ["proxy"]
}

resource "google_compute_instance" "bastion_instance" {
  name         = "${var.deployment_name}-bastion-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.deployment_subnetwork_public.self_link}"
    access_config = {}
  }

  labels = {
    deployment = "${var.deployment_name}"
    service    = "bastion"
  }

  tags = ["bastion"]
}

// Private Instances ===========================================================
resource "google_compute_instance" "application_instance" {
  name         = "${var.deployment_name}-application-instance"
  machine_type = "${var.application_instance_size}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.deployment_subnetwork_private.self_link}"
    access_config = {}
  }

  labels = {
    deployment = "${var.deployment_name}"
    service    = "product"
  }
}
