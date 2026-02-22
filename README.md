# Ansible post-backend application VM deployment

This is an ansible and terraform project, used to create the aws infrastructure and automate application dependecie's setup configuration

---

## 📦 Requirements for local machine

- Python >= 3.9
- Terraform CLI > 1.2.0
- Ansible
- kwoodson.yedit ansible galaxy role

## 📦 Requirements for remote machines

- Python >= 3.9

## 🗂️ Project Structure

. \
├── files/ **files used for the configuration of technologies installed via the playbooks**\
├── group_vars/ **Group variables**\
├── host_vars/ **Host variables** \
├── playbooks/ **Location of all the project playbooks**\
├── terraform/ **Location of all the tf resource definitions**\
├── hosts.yml **File that let's ansible connect to remote host** \
├── ansible_hosts.sh **bash script used to get ec2 ip's from tf outputs and create the hosts.yml file before executing playbooks** \
├── infra.sh **bash script used to create the aws infrastructure** \
├── Jenkinsfile **CI/CD Jenkins pipeline for automating the creating and modification of AWS infrastructure** \
└── ansible.cfg **ansible config file, specifying inventory and ssh args** 

## 🏗️ Create AWS Infrastructure With Terraform
First, make sure that you are connected to your AWS account by either install and configuring the AWS CLI Tool (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) or by populating the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

#### After that, we can initialize our terraform project and install our terraform provider
```bash
terraform init
```

#### Make sure that tf files are valid
```bash
terraform validate
```

#### Lastly, create the infrastructure
Assuming that you are at the root of the project
```bash
./infra.sh 
```
This script helps you:
- create the ssh key if not already exists and pass the public key as variable to terraform
- Add your public ip for the ec2 instance's security group inbound rules
- apply and create all the terraform resources inside `terraform/main.tf`

If you do not want to see the terraform planning and go straight to the building, you can add the `-y` argument

## 🖥 Remote Host Configuration
After the infrastructure is created, you can create the ansible's hosts.yml file like this:
```bash
./ansible_hosts.yml -n -p
```
This script takes the public ips of the ec2 instances using `terraform output` and populates the hosts.yml file with all the hosts entries. For example:
```bash
application_servers:
  hosts: 
    aws_application_inst: 
      ansible_host: 172.31.45.103
      ansible_port: 22
      ansible_ssh_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/ec2_rsa
```
You can give the hosts.yml entries their private ips (If you are running the playbooks from a CI/CD server that has private access) by removing the -p argument:
```bash
./ansible_hosts.yml -n
```

Lastly, if you want to create the hosts.yml file and run all the playbooks, remove the -n argument as well:
```bash
# running the playbooks using ec2 public ips
./ansible_hosts.yml -p
# running the playbooks using ec2 private ips
./ansible_hosts.yml
```

## 🚀 Run The Playbooks
#### Run the postgres.yml playbook
assuming that you are in the root of the project:
```bash
ansible-playbook playbooks/postgres.yml
```

#### Run the rabbitmq.yml playbook
assuming that you are in the root of the project:
```bash
ansible-playbook playbooks/rabbitmq.yml
```

#### Run the minio.yml playbook
assuming that you are in the root of the project:
```bash
ansible-playbook playbooks/minio.yml
```

#### Run the keycloak.yml playbook
assuming that you are in the root of the project:
```bash
ansible-playbook playboos/keycloak.yml
```

#### Run spring.yml playbook
**❗NOTE:** This playbook uses an ansible galaxy role in order to change the spring boot's application.yml file, you can install it like this:

Replace the application.yml spring entries to your needs in the `group_vars/application_servers.yml` and `host_vars/aws_app_database_inst.yml`
```bash
ansible-galaxy role install kwoodson.yedit
```

assuming that you are in the root of the project:
```bash
ansible-playbook playboos/spring.yml
```
