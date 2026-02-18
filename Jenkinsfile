pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials("aws-access-key")
        AWS_SECRET_ACCESS_KEY = credentials("aws-secret-key")

        ANSIBLE_CONFIG = '/var/lib/jenkins/workspace/terraform/ansible.cfg'
        ANSIBLE_SSH_ARGS = '-F /var/lib/jenkins/.ssh/config'
    }

    stages {
      stage ('Initializing and validating terraform') {
            steps {
                  dir("./terraform") {
                        sh '''
                              terraform init
                              terraform validate  
                        '''
                  }
            }
      }
      stage ('Creating/updating infrastructure') {
            steps {
                  sh '''
                        ./infra.sh -y
                  '''
            }
      }
        stage ('Configuring hosts with ansible') {
            steps {
                sh "./ansible_hosts.sh"
            }
        }
    }
}
