/*
  Configures provider
*/

provider "google" {
  credentials = "${var.gcp_credentials_path}"
  project     = "${var.gcp_project_id}"
  region      = "${var.gcp_region}"
  zone        = "${var.gcp_region}-a"
}