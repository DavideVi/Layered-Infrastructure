output "bastion_public" {
  value = "${google_compute_instance.bastion_instance.network_interface.0.access_config.0.nat_ip}"
}

output "bastion_private" {
  value = "${google_compute_instance.bastion_instance.network_interface.0.address}"
}

output "proxy_public" {
  value = "${google_compute_instance.proxy_instance.network_interface.0.access_config.0.nat_ip}"
}

output "proxy_private" {
  value = "${google_compute_instance.proxy_instance.network_interface.0.address}"
}

output "application_public" {
  value = "${google_compute_instance.application_instance.network_interface.0.access_config.0.nat_ip}"
}

output "application_private" {
  value = "${google_compute_instance.application_instance.network_interface.0.address}"
}
