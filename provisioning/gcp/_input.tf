// Customisation Options =======================================================
variable "deployment_name" {
  type = "string"
}

variable "deployment_type" {
  type    = "string"
  default = "dev"
}

variable "ssh_user" {
  type = "string"
}

variable "ssh_pub_key_path" {
  type = "string"
}

variable "dns_zone" {
  type = "string"
}

// Provisioner =================================================================
variable "gcp_credentials_path" {
  type = "string"
}

variable "gcp_project_id" {
  type = "string"
}

variable "gcp_region" {
  type = "string"
}

// Feature Toggle & Sizing Options =============================================
variable "proxy_instance_size" {
  type    = "string"
  default = "f1-micro"
}

variable "application_instance_size" {
  type    = "string"
  default = "f1-micro"
}
