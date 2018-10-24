/*
    Creates networks and firewall rules
*/

resource "google_compute_network" "deployment_network" {
    name = "${var.deployment_name}-network"
    auto_create_subnetworks = "false"
    description = "Network for ${var.deployment_name}"
}

resource "google_compute_subnetwork" "deployment_subnetwork_public" {
    name = "${var.deployment_name}-subnetwork-public"
    region = "${var.gcp_region}"
    network = "${google_compute_network.deployment_network.name}"
    ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_subnetwork" "deployment_subnetwork_private" {
    name = "${var.deployment_name}-subnetwork-private"
    region = "${var.gcp_region}"
    network = "${google_compute_network.deployment_network.name}"
    ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_firewall" "ingress_allow_external_web" {
    name = "${var.deployment_name}-ingress-allow-external-web"
    network = "${google_compute_network.deployment_network.name}"

    allow {
        protocol = "tcp"
        ports = [ "80", "443" ]
    }

    source_ranges = [ "0.0.0.0/0" ]
    target_tags = [ "proxy" ]
}

resource "google_compute_firewall" "ingress_allow_external_ssh" {
    name = "${var.deployment_name}-ingress-allow-external-ssh"
    network = "${google_compute_network.deployment_network.name}"

    allow {
        protocol = "tcp"
        ports = [ "22" ]
    }

    source_ranges = [ "0.0.0.0/0" ]
    target_tags = [ "bastion" ]
}

resource "google_compute_firewall" "ingress_allow_internal_all" {
    name = "${var.deployment_name}-ingress-allow-internal-all"
    network = "${google_compute_network.deployment_network.name}"

    allow {
        protocol = "tcp"
        ports = [ "0-65535" ]
    }

    source_ranges = [ "10.0.0.0/16" ]
}

resource "google_compute_firewall" "egress_allow_all" {
    name = "${var.deployment_name}-egress-allow-all"
    network = "${google_compute_network.deployment_network.name}"

    allow {
        protocol = "tcp"
        ports = [ "0-65535" ]
    }

    direction = "EGRESS"
    destination_ranges = [ "0.0.0.0/0" ]
}
