
// Customisation Options =======================================================
variable "deployment_name" {
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
    type = "string"
    default = "f1-micro"
}

variable "application_instance_size" {
    type = "string"
    default = "f1-micro"
}