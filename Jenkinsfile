pipeline {
    agent {
        dockerfile {
            args '-v /home/jenkins/.ssh/:/root/.ssh/ -v /var/run/docker.sock:/var/run/docker.sock -u root'
        }
    }

    stages {
        stage("terraform init") {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }

            }
        }

        stage("terraform apply") {
            steps {
                dir('terraform') {
                    sh 'terraform apply -var "yandex-token=${YANDEX_TOKEN}" -var "yandex-cloud-id=${YANDEX_CLOUD_ID}" -var "yandex-folder-id=${YANDEX_FOLDER_ID}" -var "yandex-zone=${YANDEX_ZONE}" -var "terraform-backend-bucket=${TERRAFORM_BACKEND_BUCKET}" -var "backend-key=${BACKEND_KEY}" -var "access-key=${ACCESS_KEY}" -var "secret_key=${SECRET_KEY}" -auto-approve'
                }
            }
        }
        stage("build") {
            steps {
                dir('ansible') {
                    sh 'ansible-galaxy collection install community.docker'
                    sh 'ansible-playbook playbook.yaml -i ./inventory/inventory.yaml -u ubuntu --extra-vars "password_docker=${DOCKER_HUB_PASSWORD}"'
                }
            }
        }
    }
}