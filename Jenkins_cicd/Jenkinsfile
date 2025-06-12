pipeline {
    agent any
    environment {
        AWS_REGION = 'ap-southeast-1'
        AWS_ACCOUNT_ID = '590183945701'
        IMAGE_TAG = "build-${BUILD_NUMBER}"
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/python_web_application"
        FULL_IMAGE = "${ECR_REPO}:${IMAGE_TAG}"
    }
    stages {

        stage('Clone Application Repo') {
            steps {
                withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'github')]) {
                    script {
                        if (fileExists('Jenkins_cicd_webhook')) {
                            dir('Jenkins_cicd_webhook') {
                                sh '''
                                    git checkout master || git checkout -b master origin/master
                                    git pull origin master
                                '''
                            }
                        } else {
                            sh 'git clone https://$github@github.com/varunsimha-MP/Jenkins_cicd_webhook.git'
                        }
                    }
                }
            }
        }

        stage('Clean old Docker image') {
            steps {
                sh 'docker rmi -f python_web_application:latest || true'
            }
        }

        stage('Build Docker image') {
            steps {
                dir('Jenkins_cicd_webhook') {
                    sh 'docker build -t python_web_application:${IMAGE_TAG} .'
                }
            }
        }

        stage('Push Docker Image To ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                    docker tag python_web_application:${IMAGE_TAG} ${FULL_IMAGE}
                    docker push ${FULL_IMAGE}
                '''
            }
        }


        stage('Clone ArgoCD Repo') {
            steps {
                withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'github')]) {
                    script {
                        if (fileExists('k8s_test')){
                            dir('k8s_test') {
                                sh '''
                                    git checkout master || git checkout -b master origin/master
                                    git pull origin master
                                '''
                                }
                            }   
                        else {
                            sh 'git clone https://$github@github.com/varunsimha-MP/k8s_test.git'
                        }
                    }
                }
            }
        }

        stage('Update ArgoCD YAML') {
            steps {
                dir('k8s_test/ArgoCD') {
                    sh '''
                        sed -i 's|image:.*|image: '"${FULL_IMAGE}"'|' appdeployment.yml
                    '''
                }
            }
        }

        stage('Commit and Push Changes to ArgoCD Repo') {
            steps {
                withCredentials([string(credentialsId: 'GITHUB_TOKEN', variable: 'github')]) {
                    dir('k8s_test') {
                        sh '''
                            git config --global user.email "jenkins@ci.com"
                            git config --global user.name "Jenkins CI"

                            git add ArgoCD/appdeployment.yml
                            git commit -m "Updated image to ${FULL_IMAGE}" || echo "No changes to commit"
                            git push https://$github@github.com/varunsimha-MP/k8s_test.git HEAD:master
                        '''
                    }
                }
            }
        }
    }
}
