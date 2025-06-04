# Infrastructure Deployment Pipeline Project

This is a small applicaiton which contains main and test folders.
Main contains application code.
Test contains test cases.
It also contains pom.xml which has all dependences and artfact name and version
This repository implements a production-grade infrastructure deployment pipeline following DevOps best practices, featuring:

- Infrastructure as Code with Terraform
- CI/CD Automation with Jenkins
- Container Orchestration via AWS ECS
- Blue/Green Deployments
- Comprehensive Observability
- Security-First Design

#Project Toolbox 
- Git:  Git will be used to manage our application source code.
Github Github is a free and open source distributed VCS designed to handle everything from small to very large projects with speed and efficiency
- Jenkins: Jenkins is an open source automation CI tool which enables developers around the world to reliably build, test, and deploy their software
- Terraform: Open source Infrastructure as code tool it allows you to define, provision, and manage infrastructure resources across various cloud providers and on-premises environments 
- Maven: Maven will be used for the application packaging and building including running unit test cases
- Checkstyle: Checkstyle is a static code analysis tool used in software development for checking if Java source code is compliant with specified coding rules and practices.
- SonarQube: SonarQube Catches bugs and vulnerabilities in your app, with thousands of automated Static Code Analysis rules.
- Jfrog Artifactory: Manage Binaries and build artifacts across your software supply chain
- EC2: EC2 allows users to rent virtual computers (EC2) to run their own workloads and applications.
- Slack: Slack is a communication platform designed for collaboration which can be leveraged to build and develop a very robust DevOps culture. Will be used for Continuous feedback loop.

## Architecture Overview



## 1. Prerequisites

- AWS Account with least privilege principle permissions
- Terraform v1.0+
- Docker installed
- Jenkins server 
- SonarQube token 
- Jfrog artifactory


## 2. Configure Jenkins

1. Access Jenkins
Copy your Jenkins Public IP Address and paste on the browser = ExternalIP:8080

Login to your Jenkins instance using your Shell (GitBash or your Mac Terminal)
Copy the Path from the Jenkins UI to get the Administrator Password
Run: sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Copy the password and login to Jenkins
Plugins: Choose Install Suggested Plugings
Provide
Username: admin
Password: admin
Name and Email can also be admin. You can use admin all, as its a poc.
Continue and Start using Jenkins
Plugin installations:
Click on "Manage Jenkins"
Click on "Plugins"
Click "Available Plugins"
Search and Install the following Plugings "Install Without Restart"

## 3.  SonarQube Configuration
Create Sonar cloud account on https://sonarcloud.io
Generate an Authentication token on SonarQube    Account --> my account --> Security --> Generate Tokens
On Jenkins create credentials    Manage Jenkins --> manage credentials --> system --> Global credentials --> add credentials  - Credentials type: Secret text  - ID: sonarqcreds
Install SonarQube plugin     Manage Jenkins --> Available plugins     Search for sonarqube scanner
Configure sonarqube server    Manage Jenkins --> Configure System --> sonarqube server    Add Sonarqube server    - Name: sonar-server    - Server URL: https://sonarcloud.io/    - Server authentication token: sonarqube-key
Configure sonarqube scanner    Manage Jenkins --> Global Tool configuration --> Sonarqube scanner    Add sonarqube scanner    - Sonarqube scanner: sonar-scanner

# 4. Publish jar file onto Jfrog Artifactory
Create Artifactory account
Generate an access token with username (username must be your email id)
Add username and password under jenkins credentials
Install Artifactory plugin
Update Jenkinsfile with jar publish stage


# 5. Pipeline creation
Click on New Item
Enter an item name: tf-infra-pipeline & select the category as Pipeline
Enter an item name: cicd-app-pipeline & select the category as Pipeline
Now scroll-down and in the Pipeline section --> Definition --> Select Pipeline script from SCM
SCM: Git
Repositories
Repository URL: FILL YOUR OWN REPO URL (that we created by importing in the first step)
Branch Specifier (blank for 'any'): */main or */dev
Script Path: Jenkinsfile
Save

# 6. Credentials setup (AWS Credentials)

Click "Manage Jenkins" (left side menu)
Click "Manage Credentials"
Under "Stores scoped to Jenkins", click on (global)
Click Add Credentials (left menu)
Fill the Credential Form:
Kind: Select AWS Credentials
Access Key ID: Paste your AWS access key (e.g., AKIA...)
Secret Access Key: Paste the corresponding AWS secret key
ID :aws-creds (You can refer to this ID in your pipeline)
Description: aws-creds
Click OK or Create

# Add credentials for AWS, DockerHub, SonarQube, and JFrog

# 7. Configure plugins:
- Terraform
- Docker Pipeline
- AWS Credentials
- Blue Ocean
- Jfrog 
- Sonarqube scanner
- Webhook Trigger
- Amazon SDK
- CloudBees Docker Build and Publish plugin
- Maven Intergration

# 8. GitHub webhook
1. Add jenkins webhook to github
Access your repo devops-fully-automated-infra on github
Goto Settings --> Webhooks --> Click on Add webhook
Payload URL: htpp://REPLACE-JENKINS-SERVER-PUBLIC-IP:8080/github-webhook/ (Note: The IP should be public as GitHub is outside of the AWS VPC where Jenkins server is hosted)
Click on Add webhook
2. Configure on the Jenkins side to pull based on the event
Access your jenkins server, pipeline app-infra-pipeline
Once pipeline is accessed --> Click on Configure --> In the General section --> Select GitHub project checkbox and fill your repo URL of the project devops-fully-automated.
Scroll down --> In the Build Triggers section --> Select GitHub hook trigger for GITScm polling checkbox
Once both the above steps are done click on Save.

# Set up and configure Tools and System configurations like JDK, Maven, Sonarqube server

# Skipping all the checks on the Jenkins file comment the checkov scan lines accordingly with # (sure to shell)


## Detailed Components

### Infrastructure as Code

**Terraform Modules:**
- network/ - VPC, subnets, NAT, routing
- security/ - IAM roles, security groups
- compute/ - ECS cluster, ALB, ASG
- monitoring/ - CloudWatch alarms, CloudWatch logs

### CI/CD Pipeline

Jenkins Stages:
1. Infra Validation
   - Terraform fmt/validate
   - Checkov security scanning
2. Build
   - Docker build/push
   - SonarQube analysis
3. Deploy
   - Terraform apply
   - ECS blue/green
4. Verify
   - Integration tests
   - Canary analysis
5. Notify
   - Slack deployment status
   - JIRA ticket update

### Container Management

ECS Configuration:
- Fargate launch type
- Task CPU/memory scaling
- Service mesh integration
- Secrets management via:

## Security Considerations

Key Implementations:
- IAM roles with least privilege
- S3 bucket encryption and versioning
- VPC flow logging
- Security group minimum rules
- Regular patching cycle
- Secrets rotation automation
- Static code application testing


## Monitoring & Alerting

CloudWatch Dashboard:
- ECS service metrics
- ALB request rates
- Custom business metrics

**Alert Thresholds:**
- CPU > 70% for 5 minutes
- Memory > 80% utilization
- HTTP 5xx > 1% of requests
- Deployment failure events

## Troubleshooting

**Common Issues:**
1. **Terraform State Lock**
   ```bash
   terraform force-unlock LOCK_ID
   ```
2. **ECS Deployment Stuck**
   - Check service events
   - Verify task IAM role
3. **Jenkins Pipeline Failures**
   - Check console output
   - Verify credential scopes

## Future Improvements

**Planned Enhancements:**
- [ ] Migrate to EKS 
- [ ] Add multi-region failover
- [ ] Automated rollback system
- [ ] Cost optimization alerts

