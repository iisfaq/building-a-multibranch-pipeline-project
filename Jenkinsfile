def name = 'react'
def tempFolder  = "c:\\temp\\app"
def buildImage = "my-${name}-build-image"
def buildContainer = "my-${name}-build-container"
def runImage = "node:lts-alpine"
def runContainer = "my-${name}-run-container"

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
        stage('Clean Workspace & Checkout Source Code') {
            steps {
                deleteDir()
                checkout scm

                catchError {
                    bat "docker kill ${buildContainer}"
                }
                catchError {
                    bat "docker rm ${buildContainer}"
                }
                catchError {
                    bat "docker kill ${runContainer}"
                }
                catchError {
                    bat "docker rm ${runContainer}"
                }                
                catchError {
                    bat "docker rmi ${buildImage} --force"
                }
            }
        }
        stage('Show Environment Vars') {
            steps {
                bat 'set'
            }
        }
        stage('Create Build Image') {
            steps {
                bat "docker build -t ${buildImage}:latest ."
            }
        }
        stage('Create Build Container') {
            steps {
                // -t keep docker container running
                bat "docker run -t -d --name ${buildContainer} ${buildImage}"
            }
        }
              

        stage('Create Run Container') {
            steps {
                // -t keep docker container running
                bat "docker run -t -d --name ${runContainer} -p 3000:3000 ${runImage}"

                bat "docker exec ${runContainer} mkdir /app"
            }
        }

        stage('Build Web Site') {
            when {
                branch 'development'
            }
            steps {
                bat "docker exec ${buildContainer} npm install"
                bat "docker exec ${buildContainer} npm run build"
                bat "docker cp ${buildContainer}:/src/build ${tempFolder}"
                bat "docker cp ${tempFolder} ${runContainer}:/"
                bat "rmdir ${tempFolder} /s /q"
                bat "docker exec ${runContainer} npm install -g serve"
                bat 'docker exec ${runContainer} serve -s /app -l 3000'
            }
        }
        stage('Production Container') {
            when {
                branch 'production'
            }
            steps {
                bat "docker exec ${buildContainer} sh ./jenkins/scripts/deliver-for-production.sh"
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                bat "docker exec ${buildContainer} sh ./jenkins/scripts/kill.sh"
            }
        }

        stage('Stop Running Containers') {
            steps {
                bat "docker stop ${buildContainer}"
                bat "docker stop ${runContainer}"
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
