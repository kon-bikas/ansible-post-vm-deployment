#!/bin/bash
hosts=("application" "web" "access_management" "app_database"
       "iam_database" "object_storage" "message_broker")

# create the hosts.yml file giving the host's assigned public ip address
declare -A private_ips

n_flag=false
p_flag=false
while getopts pn opt; do
      case $opt in
            p) p_flag=true ;;
            n) n_flag=true ;;
      esac
done

echo "---" > ./hosts.yml
for i in ${!hosts[@]}; do
      public_ip=$(terraform -chdir=./terraform output -json ec2_public_ips | \
                jq -r ".[\"i_${hosts[$i]}\"]")

      private_ips[${hosts[$i]}]=$(terraform -chdir=./terraform output -json ec2_private_ips | \
                jq -r ".[\"i_${hosts[$i]}\"]")

      host_ip=${private_ips[${hosts[$i]}]}
      if [[ $p_flag = true ]]; then
            host_ip=$public_ip
      fi

      cat <<EOF >> ./hosts.yml
${hosts[$i]}_servers:
  hosts: 
    aws_${hosts[$i]}_inst: 
      ansible_host: ${host_ip}
      ansible_port: 22
      ansible_ssh_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/ec2_rsa
EOF
done

# if -n flag is given, do NOT run the playbooks
if [[ $n_flag = true ]]; then
      exit 0;
fi

# run the playbooks
ansible-playbook ./playbooks/rabbitmq.yml
ansible-playbook ./playbooks/postgres.yml
ansible-playbook ./playbooks/minio.yml

ansible-playbook ./playbooks/keycloak.yml \
      -e psql_host=${private_ips["iam_database"]} \
      -e broker_host=${private_ips["message_broker"]}

ansible-galaxy role install kwoodson.yedit
ansible-playbook ./playbooks/spring.yml \
      -e psql_host=${private_ips["app_database"]} \
      -e rabbit_host=${private_ips["message_broker"]} \
      -e kc_host=${private_ips["access_management"]} \
      -e minio_host=${private_ips["object_storage"]}


