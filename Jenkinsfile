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
                sh 'docker build -t myimage .'
            }
        }
        stage('Run Container') {
            steps {
                sh 'docker run -d --name mycontainer -p 3000:3000 myimage'
            }
        }
        stage('Install NPM Packages') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Test Container') {
            steps {
                sh 'docker exec mycontainer curl localhost:80'
            }
        }
        stage('Stop Container') {
            steps {
                sh 'docker stop mycontainer'
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