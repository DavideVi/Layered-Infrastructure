data "google_dns_managed_zone" "main_zone" {
  name = "${var.dns_zone}"
}

resource "google_dns_record_set" "proxy" {
  name = "${var.deployment_type}.${data.google_dns_managed_zone.main_zone.dns_name}"
  type = "TXT"
  ttl  = 60

  managed_zone = "${data.google_dns_managed_zone.main_zone.name}"

  rrdatas = ["${google_compute_instance.proxy_instance.network_interface.0.access_config.0.nat_ip}"]
}

resource "google_dns_record_set" "bastion" {
  name = "bastion.${var.deployment_type}.${data.google_dns_managed_zone.main_zone.dns_name}"
  type = "TXT"
  ttl  = 60

  managed_zone = "${data.google_dns_managed_zone.main_zone.name}"

  rrdatas = ["${google_compute_instance.bastion_instance.network_interface.0.access_config.0.nat_ip}"]
}
