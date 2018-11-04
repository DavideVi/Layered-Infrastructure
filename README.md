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

Set up environment variables:
```
export TF_VAR_deployment_name="<deployment_name>"
export TF_VAR_gcp_project_id="<gcp_project_id>"
export TF_VAR_gcp_credentials_path="<gcp_credentials_path>"
export TF_VAR_gcp_region="<gcp_region>"
export TF_VAR_ssh_user="<your ssh username>"
export TF_VAR_ssh_pub_key_path="<path to your PUBLIC key file>"
```

Start the SSH agent, and load the private key used for this deployment
```
eval $(ssh-agent -s)
ssh-add ~/.ssh/google_compute_engine
```

Deploy with `invoke`:
```
invoke deploy-gcp
```

### GCP Destroy



### AWS 

Not Available. 
