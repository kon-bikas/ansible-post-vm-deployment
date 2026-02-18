#!/bin/bash
command="apply"
if [[ ! -z $1 ]]; then 
      if [[ $1 = "-y" ]]; then
            command="apply -auto-approve"
      else
            command=$1
      fi
fi

if [[ ! -z $2 ]] && [[ $2 = "-y" ]]; then
      command="${command} -auto-approve"
fi

if [[ ! -f "$HOME/.ssh/ec2_rsa" ]]; then
      ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/ec2_rsa
fi

terraform -chdir=./terraform $command \
      -var "ssh_public_key=$(cat ~/.ssh/ec2_rsa.pub)" \
      -var "my_public_ip=$(curl -s -4 ip.me)"
