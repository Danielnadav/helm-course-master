pipeline {
    agent {
        kubernetes {
            // Configure the Kubernetes pod template
            // Customize the values based on your Kubernetes cluster and requirements
            yaml """
                apiVersion: v1
                kind: Pod
                metadata:
                  labels:
                    jenkins: agent
                spec:
                  containers:
                  - name: helm
                    image: alpine/helm
                    command:
                    - /bin/sh
                    - -c
                    - |
                      while true; do sleep 1; done
            """
        }
    }
    
    parameters {
        choice(
            choices: ['stg', 'prd'],
            description: 'Select the environment',
            name: 'ENVIRONMENT'
        )
    }
    
    stages {
        stage('Helm List') {
            steps {
                container('helm') {
                    // Run helm ls command
                    sh "helm ls"
                }
            }
        }
        
        stage('Helm Install or Upgrade') {
            steps {
                container('helm') {
                    script {
                        def valueFile
                        def chartName
                        if (params.ENVIRONMENT == 'stg') {
                            valueFile = 'values.yaml'
                            chartName = 'helm-course-master-stg'
                        } else if (params.ENVIRONMENT == 'prd') {
                            valueFile = 'values.prod.yaml'
                            chartName = 'helm-course-master-prd'
                        } else {
                            error("Invalid environment selected!")
                        }
                        
                        // Check if the release already exists
                        def releaseCheck = sh(returnStatus: true, script: "helm list -q --namespace pgadmin | grep -q ${chartName}")
                        
                        if (releaseCheck == 0) {
                            // Release already exists, perform helm upgrade
                            sh "helm upgrade ${chartName} . -f ${valueFile} --namespace pgadmin"
                        } else {
                            // Release does not exist, perform helm install
                            sh "helm install ${chartName} . -f ${valueFile} --namespace pgadmin"
                        }
                    }
                }
            }
        }
    }
}
