 def registry = 'https://trialg0yj41.jfrog.io' 
 def imageName = 'https://trialg0yj41.jfrog.io/valaxy-docker-local/ttrend'
 def version = '2.1.3'

pipeline {
    agent any
    
    environment {
        PATH = "/opt/maven/bin:$PATH"
        //KUBECONFIG = "$HOME/.kube/config"  // Ensure Jenkins uses the correct config
    }
    
    
    
    stages {
        stage("Build") {
            steps {
                echo "------ Build started ------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "------ Build completed ------"
            }
        }

        stage("Unit Test") {
            steps { 
                echo "------ Unit test started ------"
                sh 'mvn surefire-report:report'
                echo "------ Unit test completed ------"
            }
        }
        
        stage("Sonar Analysis") {
            environment {
                scannerHome = tool 'sonar-scanner'  // Scanner name configured for the agent
            }
            steps {
                echo '<--------------- Sonar Analysis started --------------->'
                withSonarQubeEnv('sonarqube-server') {
                    withCredentials([string(credentialsId: 'sonarcreds', variable: 'SONAR_TOKEN')]) {
                        sh """
                                set +e
                                ${scannerHome}/bin/sonar-scanner -Dsonar.login=$SONAR_TOKEN
                                echo "SonarQube scanner finished with exit code \$?"
                                set -e
                            """

                    }
                }
                echo '<--------------- Sonar Analysis stopped --------------->'
            }
        }

        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer(url: registry + "/artifactory", credentialsId: "jfrogcreds")
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/*",
                                "target": "tttrend-libs-release-local/",
                                "props" : "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }   


        stage("Docker Build") {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build(imageName + ":" + version)
                    echo '<--------------- Docker Build Ended --------------->'
                }
            }
        }

        stage(" Push to ECR") {
            steps {
                script {
                    echo '<--------------- Push to ECR Started --------------->'
                    docker.withRegistry('https://<aws_account_id>.dkr.ecr.<region>.amazonaws.com', 'ecr:us-east-1:aws-ecr-creds') {
                        app.push()
                    }
                    echo '<--------------- Push to ECR Ended --------------->'
                }
            }
        }

    stage ("Deploy to ECS") {
        steps {
            script {
                echo '<--------------- Deploy to ECS Started --------------->'
                sh 'aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment'
                echo '<--------------- Deploy to ECS Ended --------------->'
            }
        }
    }
  }
}
