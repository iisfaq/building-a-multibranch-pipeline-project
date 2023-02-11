pipeline {
    agent  {
        node { label 'srv2022' }
    }
    environment {
        CI = 'true'
    }
    stages {
        stage('Build Image') {
            steps {
                bat 'docker build -t "myimage:dockerfile" .'
            }
        }
        stage('Run Container') {
            steps {
             catchError {
                bat 'docker kill mycontainer'
             }
              catchError {
                bat 'docker rm mycontainer'
                }
                bat 'docker run -t -d --name mycontainer -p 3000:3000 myimage'
            }
        }
        stage('Install NPM Packages') {
            steps {
                bat 'docker exec mycontainer npm install'
            }
        }

      
        stage('Test Container') {
            when {
                branch 'development'
            }
            steps {
                bat 'docker exec mycontainer sh ./jenkins/scripts/deliver-for-development.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                bat 'docker exec mycontainer sh ./jenkins/scripts/kill.sh'
            }
            // steps {
            //     bat 'docker exec mycontainer curl localhost:3000'
            // }
        }
        stage('Stop Container') {
            steps {
                bat 'docker stop mycontainer'
            }
        }
    }
}

//       stage('Create Docker Image') {
//         steps {
//           docker build -t "chris:dockerfile" .
//     }
// }/
// stage('Build') {
//     steps {
//         sh 'npm install'
//     }
// }
// stage('Test') {
//     steps {
//         sh './jenkins/scripts/test.sh'
//     }
// }
// stage('Deliver for development') {
//     when {
//         branch 'development'
//     }
//     steps {
//         sh './jenkins/scripts/deliver-for-development.sh'
//         input message: 'Finished using the web site? (Click "Proceed" to continue)'
//         sh './jenkins/scripts/kill.sh'
//     }
// }
// stage('Deploy for production') {
//     when {
//         branch 'production'
//     }
//     steps {
//         sh './jenkins/scripts/deploy-for-production.sh'
//         input message: 'Finished using the web site? (Click "Proceed" to continue)'
//         sh './jenkins/scripts/kill.sh'
//     }
// }
//    }
//}
