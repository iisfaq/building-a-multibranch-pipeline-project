def name = 'test'
def baseImage = "my-${name}-image"
def buildContainer = "my-${name}-build-container"
def runtimeContainer = "my-${name}-runtime-container"

pipeline {
    agent  {
        node { label 'srv2022' }
    }
    options {
        skipDefaultCheckout true
    }
    environment {
        CI = 'true'
    }
    stages {
        stage('clean_workspace_and_checkout_source') {
            steps {
                deleteDir()
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                catchError {
                    bat "docker rmi ${baseImage} --force"
                }
                bat "docker build -t ${baseImage}:latest ."
            }
        }
        stage('Run Container') {
            steps {
                catchError {
                    bat "docker kill ${buildContainer}"
                }
                catchError {
                    bat "'docker rm ${buildContainer}"
                }
                // -t keep docker container running
                bat "docker run -t -d --name ${buildContainer} -p 3000:3000 ${baseImage}"
            }
        }
        stage('Install NPM Packages') {
            steps {
                bat 'docker exec ${buildContainer} npm install'
            }
        }

        stage('Development Container') {
            when {
                branch 'development'
            }
            steps {
                bat 'docker exec ${buildContainer} sh ./jenkins/scripts/deliver-for-development.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                bat 'docker exec ${buildContainer} sh ./jenkins/scripts/kill.sh'
            }
        }
        stage('Production Container') {
            when {
                branch 'development'
            }
            steps {
                bat 'docker exec ${buildContainer} sh ./jenkins/scripts/deliver-for-development.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                bat 'docker exec ${buildContainer} sh ./jenkins/scripts/kill.sh'
            }
        }

        stage('Stop Container') {
            steps {
                bat 'docker stop ${buildContainer}'
            }
        }
    }
    post {
        cleanup {
            /* clean up our workspace */
            //  deleteDir()
            /* clean up tmp directory */
            dir("${workspace}@tmp") {
                deleteDir()
            }
            /* clean up script directory */
            dir("${workspace}@script") {
                deleteDir()
            }
        }
    }
}

