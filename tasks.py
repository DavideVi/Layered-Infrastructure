import os
from invoke import task

REEQUIRED_VARS = [
    "TF_VAR_deployment_name",
    "TF_VAR_gcp_credentials_path",
    "TF_VAR_gcp_project_id",
    "TF_VAR_gcp_region"
]


@task
def deploy_gcp(context):

    if not check_vars_set():
        return

    context.run("cd provisioning/gcp && terraform apply")

    raw_terraform_output = context.run(
        "cd provisioning/gcp && terraform output""",
        hide=True
    ).stdout

    terraform_output = parse_terraform_output(raw_terraform_output)

    print("OUTS:\n{}".format(terraform_output))


def check_vars_set():

    missing_vars = []

    for var in REEQUIRED_VARS:
        if os.environ.get(var, None) is None:
            missing_vars.append(var)

    if len(missing_vars) > 0:
        print("Missing variables found: {missing_vars}".format(
            missing_vars=missing_vars
        ))

    return len(missing_vars) == 0


def parse_terraform_output(raw_terraform_outputs):
    """
        Parses raw string terraform outputs into a dict
    """
    terraform_output = {}

    lines = raw_terraform_outputs.split('\n')

    for line in lines:
        if " = " in line:
            key_and_value = line.split(' = ')
            key = key_and_value[0]
            value = key_and_value[1]

            terraform_output[key] = value

    return terraform_output


def generate_ansible_inventory(terraform_outputs):
    pass
