pipeline {
        agent any
        environment {
            registry = "inampudi2020dap/dockerk8pipeline"
            registryCredential = 'docker'
            dockerImage = ''
		PROJECT_ID = 'dap-k8-cluster'
 		CLUSTER_NAME = 'dap-k8-cluster'
 		LOCATION = 'us-central1-c'
 		CREDENTIALS_ID = 'gcp-k8-key'
        }
		
	    stages {	
		   stage('Scm Checkout') {            
			steps {
	             checkout scm
				  }	
	           }
	           
		   stage('Build') { 
	                steps {
	                  echo "Cleaning and packaging..."
			 slackSend channel: 'ci-cd-pipeline', color: '#BADA55', message: 'Build Stage', teamDomain: 'dap40devops', tokenCredentialId: 'slack'
	                  sh 'mvn clean package'		
	                }
	           }
		   stage('Test') { 
			steps {
		          echo "Testing..."
		          slackSend channel: 'ci-cd-pipeline', color: '#BADA55', message: 'Test Stage', teamDomain: 'dap40devops', tokenCredentialId: 'slack'
			  sh 'mvn test'
			}
		   }
		   stage('Build Docker Image') { 
			steps {
	                   script {
	                      dockerImage = docker.build registry + ":$BUILD_NUMBER"
		              slackSend channel: 'ci-cd-pipeline', color: '#BADA55', message: 'Build Docker Image', teamDomain: 'dap40devops', tokenCredentialId: 'slack'
	                   }
	                }
		   }
            stage('Deploy Image') {
                steps{
                    script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
			slackSend channel: 'ci-cd-pipeline', color: '#BADA55', message: 'Deploy Image', teamDomain: 'dap40devops', tokenCredentialId: 'slack'
                    }
                    }
                }
            }
	        stage('Deploy to GKE') {
 			steps{
 				echo "Deployment started"
				sh 'ls -ltr'
				sh 'pwd'
				sh "sed -i 's/tagversion/${env.BUILD_ID}/g' deployment.yaml"
				step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID,
				      clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml',
				      credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
				echo "Deployment Finished"
				slackSend channel: 'ci-cd-pipeline', color: '#BADA55', message: 'Deploy to GKE', teamDomain: 'dap40devops', tokenCredentialId: 'slack'
 	            }
	          }
	    }
		
		post {
			success {
      slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
					}

			failure {
      slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
					}
			}
	}
