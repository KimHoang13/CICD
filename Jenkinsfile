// git repository info
def gitlabRepository = 'http://54.254.157.242/devops-2023-01/Project.git'
// def gitlabCredential = '7fac6f95-3e88-49ca-8fdb-d4f18a7aac25'
def gitlabCredential = 'jenkinsdeploytk'


// 
def dockerHubUserName = 'kimhh13'
def dockerHubRepoName = 'lab'



pipeline {
    agent any
    environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub')
		DOCKER_IMAGE_NAME = "${dockerHubUserName}/${dockerHubRepoName}"
		BRANCH_NAME = "${GIT_BRANCH.split("/")[1]}"
	}
    stages {
		stage('Checkout') {
			steps {
				echo "Running on ${BRANCH_NAME} branch!"
				git branch: "${BRANCH_NAME}",
				   credentialsId: gitlabCredential,
				   url: gitlabRepository
				sh "git reset --hard"
				sh "aws s3api get-object --bucket kimhh1labinventory --key inventory ./ansible/inventory"
				sh "sh discord.sh Checkout_Step:B_Num_$BUILD_NUMBER Branch: $BRANCH_NAME"
			}
		}

        stage('Build') {
			steps{
				script {
                    sh 'docker build ./Myproject -t $DOCKER_IMAGE_NAME:$BRANCH_NAME$BUILD_NUMBER'
					sh "sh discord.sh Build_Step:B_Num_$BUILD_NUMBER Image: $DOCKER_IMAGE_NAME:${BRANCH_NAME}$BUILD_NUMBER"      
			 	}
			}
		}
		stage('Push') {      	
   			steps {                       	
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
				echo 'Login Completed'
			    sh 'docker push $DOCKER_IMAGE_NAME:${BRANCH_NAME}$BUILD_NUMBER'
				sh 'docker rmi $DOCKER_IMAGE_NAME:${BRANCH_NAME}$BUILD_NUMBER'
				sh 'docker logout'
				sh "sh discord.sh Push_Step:B_Num_$BUILD_NUMBER Status: 'Push image: $DOCKER_IMAGE_NAME:${BRANCH_NAME}$BUILD_NUMBER to $DOCKERHUB_CREDENTIALS_USR'"					
			}           
		}
		stage("Release") {
			steps {
				script {
					if (env.BRANCH_NAME == "main") {
						ansiblePlaybook(credentialsId: 'ssh-using-kimhh_T_T',disableHostKeyChecking: true, extras: '--extra-vars="default_container_image=$DOCKER_IMAGE_NAME:$BRANCH_NAME$BUILD_NUMBER host=$BRANCH_NAME install_nodeexp=true"', inventory: './ansible/inventory', playbook: './ansible/main.yaml')
						sh "sh discord.sh Release_Step:B_Num_$BUILD_NUMBER Env_Deploy: $BRANCH_NAME"
					} else {
						ansiblePlaybook(credentialsId: 'ssh-using-kimhh_T_T',disableHostKeyChecking: true, extras: '--extra-vars="default_container_image=$DOCKER_IMAGE_NAME:$BRANCH_NAME$BUILD_NUMBER host=$BRANCH_NAME"', inventory: './ansible/inventory', playbook: './ansible/main.yaml')
						sh "sh discord.sh Release_Step:B_Num_$BUILD_NUMBER Env_Deploy: $BRANCH_NAME"
					}
				}
			}
		} 
    }
}

