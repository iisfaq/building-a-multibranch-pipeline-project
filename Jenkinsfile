def name = 'test'
def baseBuildImage = "my-${name}-build-image"
def baseRunImage = "my-${name}-image"
def buildContainer = "my-${name}-build-container"
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
            }
        }
        stage('Build Docker Image') {
            steps {
                catchError {
                    bat "docker rmi ${baseBuildImage} --force"
                }
                bat "docker build -t ${baseBuildImage}:latest ."
            }
        }
        stage('Run Container') {
            steps {
                catchError {
                    bat "docker kill ${buildContainer}"
                }
                catchError {
                    bat "docker rm ${buildContainer}"
                }
                // -t keep docker container running
                bat "docker run -t -d --name ${buildContainer} ${baseBuildImage}"
            }
        }
        stage('Install NPM Packages') {
            steps {
                bat "docker exec ${buildContainer} npm install"
            }
        }

        stage('Build Web Site') {
            when {
                branch 'development'
            }
            steps {
                bat "docker exec ${buildContainer} npm run build"
                catchError {
                    bat "docker rmi ${baseRunImage} --force"
                }
                bat "docker build -t ${baseRunImage}:latest ."
                
                catchError {
                    bat "docker kill ${runContainer}"
                }
                catchError {
                    bat "docker rm ${runContainer}"
                }
                // -t keep docker container running
                bat "docker run -t -d --name ${runContainer} -p 3000:3000 ${baseRunImage}"

                bat "docker exec ${runContainer} sh mkdir /app"

                bat "docker cp  ${buildContainer}:/src/build ${runContainer}:/app"
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

        stage('Stop Container') {
            steps {
                bat "docker stop ${buildContainer}"
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

