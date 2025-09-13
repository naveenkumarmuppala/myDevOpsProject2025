pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo building...'
      }
      post {
        always {
          // send build info to Jira (replace site name with your site)
          jiraSendBuildInfo site: 'naveen-kumar-muppala.atlassian.net'
        }
      }
    }

    stage('Deploy') {
      steps {
        sh 'echo deploying...'
      }
      post {
        success {
          // send deployment info (include environment info as needed)
          jiraSendDeploymentInfo site: 'naveen-kumar-muppala.atlassian.net',
                               environmentId: 'DSO-1',
                               environmentName: 'staging',
                               environmentType: 'staging',
                               issueKeys: ['DSO-1']
        }
      }
    }
  }
  post {
    success {
      script {
        // Transition issue PROJ-123 from In Progress → Done
        jiraTransitionIssue site: 'jira-jenkins',
                            issueKeys: 'DSO-1',
                            input: [transition: [id: '21']]
      }
    }
  }
}
