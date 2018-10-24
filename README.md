# Layered-Infrastructure

## Requirements
- `terraform`. Tested on `0.11.9-1` .

## Usage

```
cd provisioning/gcp

terraform init

// Export variables
// export TF_VAR_var_name=var_value

terraform validate
terraform plan
terraform apply
```
