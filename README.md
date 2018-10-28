# Layered-Infrastructure

## Description

Deploys a two-tiered infrastructure with:
- A bastion (Not configured)
- A proxy (Docker-based nginx with `/etc/nginx` mounted on host and including from `conf.d`)
- An application instance (Not configured) not publicly accessible

### GCP

No Cloud NAT at the moment as it's unsupported in Terraform. Public/private enforced via firewall.

Default firewall rules:
- Allows ingress HTTP(S) from anywhere to proxy instance
- Allows ingress SSH from anywhere to bastion instance
- Allows any traffic inside the network
- Allows any egress traffic

### AWS

Not Available.

## Pre-requisites
**Required:**
- `terraform`. Tested on `0.11.9-1`.
- `ansible`. Tested on `2.7.0`.

**Optional (but useful):**
- `python 3+` with `invoke`


## Usage

### GCP Create

With `invoke`:
```
export TF_VAR_deployment_name="<deployment_name>"
export TF_VAR_gcp_project_id="<gcp_project_id>"
export TF_VAR_gcp_credentials_path="<gcp_credentials_path>"
export TF_VAR_gcp_region="<gcp_region>"

invoke deploy-gcp
```

Without `invoke`:
```
export TF_VAR_deployment_name="<deployment_name>"
export TF_VAR_gcp_project_id="<gcp_project_id>"
export TF_VAR_gcp_credentials_path="<gcp_credentials_path>"
export TF_VAR_gcp_region="<gcp_region>"

cd provisioning/gcp
terraform apply
```

### GCP Destroy




### AWS 

Not Available. 
