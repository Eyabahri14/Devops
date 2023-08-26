pipeline {
    agent any

    stages {
        stage("Git Clone") {
            steps {
                git credentialsId: 'GIT_HUB_CREDENTIALS', url: 'https://github.com/Eyabahri14/Devops.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage("Docker build") {
            steps {
                sh 'docker version'
                sh 'docker build -t eya-docker .'
                sh 'docker image list'
                sh 'docker tag eya-docker eyabahri14/testachat:latest'
            }
        }

        stage("Docker Login") {
            steps {
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'PASSWORD')]) {
                    sh 'docker login -u eyabahri14 -p $PASSWORD'
                }
            }
        }

        stage("Push Image to Docker Hub") {
            steps {
                sh 'docker push eyabahri14/testachat:latest'
            }
        }

        stage("SSH Into k8s Server") {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'K8S master'
                    remote.host = '192.168.75.135'
                    remote.user = 'eyabahri'
                    remote.password = '191JFT4899'
                    remote.allowAnyHosts = true

                    stage('Put K8S config files into k8smaster') {
                        sshPut remote: remote, from: '/var/lib/jenkins/workspace/achat/app_deployment.yaml', into: '.'
                        sshPut remote: remote, from: '/var/lib/jenkins/workspace/achat/app_service.yaml', into: '.'
                        sshPut remote: remote, from: '/var/lib/jenkins/workspace/achat/db_deployment.yaml', into: '.'
                        sshPut remote: remote, from: '/var/lib/jenkins/workspace/achat/db_secret.yaml', into: '.'
                        sshPut remote: remote, from: '/var/lib/jenkins/workspace/achat/db_configMap.yaml', into: '.'
                    }

                    stage('Deploy spring boot') {
                        sshCommand remote: remote, command: "export KUBECONFIG=/etc/kubernetes/admin.conf && kubectl apply -f db_secret.yaml"
                        sshCommand remote: remote, command: "export KUBECONFIG=/etc/kubernetes/admin.conf && kubectl apply -f db_configMap.yaml"
                        sshCommand remote: remote, command: "export KUBECONFIG=/etc/kubernetes/admin.conf && kubectl apply -f db_deployment.yaml"
                        sshCommand remote: remote, command: "export KUBECONFIG=/etc/kubernetes/admin.conf && kubectl apply -f app_deployment.yaml"
                        sshCommand remote: remote, command: "export KUBECONFIG=/etc/kubernetes/admin.conf && kubectl apply -f app_service.yaml"


                    }
                }
            }
        }
    }
}
