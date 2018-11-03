import os
from invoke import task

REQUIRED_VARS = [
    "TF_VAR_deployment_name", "TF_VAR_gcp_credentials_path",
    "TF_VAR_gcp_project_id", "TF_VAR_gcp_region", "TF_VAR_ssh_user",
    "TF_VAR_ssh_pub_key_path"
]

TERRAFORM_SOURCES = "provisioning"
ANSIBLE_PLAYBOOKS = "configuring"


@task
def deploy_gcp(context):

    if not check_vars_set():
        return

    if not ssh_agent_running():
        return

    context.run("cd {sources}/gcp && terraform apply".format(
        sources=TERRAFORM_SOURCES))

    raw_terraform_output = context.run(
        "cd {sources}/gcp && terraform output"
        "".format(sources=TERRAFORM_SOURCES),
        hide=True).stdout

    terraform_output = parse_terraform_output(raw_terraform_output)

    generate_ansible_inventory(terraform_output)
    generate_ssh_config(terraform_output["bastion_public"])

    context.run(
        " cd {sources} && ansible-galaxy install -r requirements.yaml".format(
            sources=ANSIBLE_PLAYBOOKS))
    context.run(" cd {sources} && ansible-playbook scaffolding.yaml".format(
        sources=ANSIBLE_PLAYBOOKS))


def check_vars_set():
    """
        Checks if required environment variables are set
    """
    missing_vars = []

    for var in REQUIRED_VARS:
        if os.environ.get(var, None) is None:
            missing_vars.append(var)

    if len(missing_vars) > 0:
        print("Missing variables found: {missing_vars}".format(
            missing_vars=missing_vars))

    return len(missing_vars) == 0


def ssh_agent_running():
    agent_running = os.environ.get("SSH_AGENT_PID", None) is not None

    if not agent_running:
        print(
            "SSH agent must be running and must have loaded the private key for this deployment"
        )

    return agent_running


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
    with open("{sources}/inventory".format(sources=ANSIBLE_PLAYBOOKS),
              "w") as inventory:

        for group in terraform_outputs:

            inventory.write("[{group_name}]\n".format(group_name=group))
            inventory.write("{ip}\n".format(ip=terraform_outputs[group]))

            # for ip in terraform_outputs[group]:
            #     inventory.write("{ip}\n".format(ip=ip))


def generate_ssh_config(bastion_ip):
    with open("{sources}/ssh.config".format(sources=ANSIBLE_PLAYBOOKS),
              "w") as sshconf:
        sshconf.write("Host bastion-host\n")
        sshconf.write("\tHostName {}\n".format(bastion_ip))
        sshconf.write("\tUser {ssh_username}\n".format(
            ssh_username=os.environ["TF_VAR_ssh_user"]))
        sshconf.write("\tPort 22\n\n")
        sshconf.write("Host 10.0.*\n")
        sshconf.write("\tUser {ssh_username}\n".format(
            ssh_username=os.environ["TF_VAR_ssh_user"]))
        sshconf.write(
            "\tProxyCommand ssh -F ssh.config -o StrictHostKeyChecking=no -W %h:%p bastion-host\n"
        )
        sshconf.write("\tControlMaster auto\n")
        sshconf.write("\tControlPath ~/.ssh/ansible-%r@%h:%p\n")
        sshconf.write("\tControlPersist 5m\n")
