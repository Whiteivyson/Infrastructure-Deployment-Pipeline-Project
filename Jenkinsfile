def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
    'UNSTABLE': 'danger'
]
pipeline {
    agent any

    environment {
        PATH = "/opt/maven/bin:$PATH"
        dockerRepo = "whiteivyson/my-app-repo"
        ecrRepo = "my-app-repo"
        registryCredentials = "dockercreds"
        imageName = "trialg0yj41.jfrog.io/valaxy-docker-local/ttrend"
        version = "2.1.3"
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
                scannerHome = tool 'sonar-scanner'
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
                    def server = Artifactory.newServer(url: "https://trialg0yj41.jfrog.io/artifactory", credentialsId: "jfrogcreds")
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/*",
                                "target": "tttrend-libs-release-local/com/valaxy/demo-workshop/2.1.3/",
                                "props": "${properties}",
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
                    app = docker.build("${dockerRepo}:${version}")
                    echo '<--------------- Docker Build Ended --------------->'
                }
            }
        }

       stage('Push to DockerHub') {
            steps {
                script {
                    echo '<--------------- Push to DockerHub Started --------------->'
                    docker.withRegistry('https://index.docker.io/v1/', 'dockercreds') {
                        app.push("${version}")
                    }
                    echo '<--------------- Push to DockerHub Ended --------------->'
                }
            }
        }



        stage("Deploy to ECS") {
            steps {
                script {
                    echo '<--------------- Deploy to ECS Started --------------->'
                    sh 'aws ecs update-service --cluster BeatStar-ecs-cluster --service BeatStar-ecs-service --force-new-deployment --region us-east-1'
                    echo '<--------------- Deploy to ECS Ended --------------->'
                }
            }
        }

        post {
            always {
                    echo 'Slack Notifications.'
                slackSend channel: '#ab-devsecops-cicd-alerts',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job Name '${env.JOB_NAME}' build ${env.BUILD_NUMBER} \n Build Timestamp: ${env.BUILD_TIMESTAMP} \n Project Workspace: ${env.WORKSPACE} \n More info at: ${env.BUILD_URL}"
                }
        }
    }
}
