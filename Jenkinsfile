def registry = 'https://trialr471xd.jfrog.io'
def imageName = 'trialr471xd.jfrog.io/valaxy-docker-local/ttrend'
def version = '2.1.3'

pipeline {
    agent { label 'maven' }
    
    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
        KUBECONFIG = "$HOME/.kube/config"  // Ensure Jenkins uses the correct config
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
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.login=$SONAR_TOKEN"
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
                                "target": "tttrend-libs-release-local/{1}",
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

        stage("Docker Publish") {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'jfrogcreds') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }

        stage ("Deploy") {
            steps{
                script{
                    sh './deploy.sh'
                }
            }
        }
    }
}
