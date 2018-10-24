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