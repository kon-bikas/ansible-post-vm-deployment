pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials("aws-access-key")
        AWS_SECRET_ACCESS_KEY = credentials("aws-secret-key")

        ANSIBLE_CONFIG = '/var/lib/jenkins/workspace/ansible/ansible.cfg'
        ANSIBLE_SSH_ARGS = '-F /var/lib/jenkins/.ssh/config'
        DIR_ANSIBLE_PROJECT = '/var/lib/jenkins/workspace/ansible'
    }

    stages {
      stage ('Testing pipeline') {
            steps {
                  dir("./terraform") {
                        echo "hello world"
                        sh "pwd"
                  }
            }
      }
      //   stage ('Initializing and validating terraform') {
      //       steps {
      //           sh "terraform -chdir=./terraform init"

      //           sh "terraform -chdir=./terraform validate"
      //       }
      //   }
      //   stage ('Creating/updating infrastructure') {
      //       steps {
      //           sh "./infra.sh -y"
      //       }
      //   }
      //   stage ('Configuring hosts with ansible') {
      //       steps {
      //           sh "./ansible_hosts.sh"
      //       }
      //   }
    }
}
