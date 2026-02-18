pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials("")
        AWS_SECRET_ACCESS_KEY = credentials("")

        ANSIBLE_CONFIG = '/var/lib/jenkins/workspace/ansible/ansible.cfg'
        ANSIBLE_SSH_ARGS = '-F /var/lib/jenkins/.ssh/config'
        DIR_ANSIBLE_PROJECT = '/var/lib/jenkins/workspace/ansible'
    }

    stages {
        stage ('Initializing and validating terraform') {
            steps {
                sh "terraform -chdir=./terraform init"

                sh "terraform -chdir=./terraform validate"
            }
        }
        stage ('Creating/updating infrastructure') {
            steps {
                sh "./infra.sh -y"
            }
        }
        stage ('Configuring hosts with ansible') {
            steps {
                sh "./ansible_hosts.sh"
            }
        }
    }
}
