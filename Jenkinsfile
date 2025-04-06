pipeline{
    agent any
    stages{
        stage('Build Jar'){
            steps{
                bat "mvn clean package -DskipTests" 
            }
        }
        stage('Build Image'){
            steps{
                bat "docker build -t=srinidhips/selenium ."
            }
        }   
        stage('Push Image'){
            environment{
                DOCKER_HUB = credentials('dockerhubCreds')
            }
            steps{
                bat 'echo %DOCKER_HUB_PSW% | docker login -u %DOCKER_HUB_USR% --password-stdin'
                bat "docker push srinidhips/seleniumsuite"
                //use the below line if you want to update the latest push and also create a new image with build_number as tag
                //bat "docker tag srinidhips/selenium:latest srinidhips/selenium:%BUILD_NUMBER%"
                //bat "docker push srinidhips/selenium:%BUILD_NUMBER%"
            }
        } 
    } 
    post{
        always{
            bat "docker logout"
        }
    }
}