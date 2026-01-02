pipeline {
  agent any
  options { timestamps() }

node {
  echo "✅ Jenkinsfile is executing"
  sh 'pwd; ls -la'
}

  stages {
    stage('Sanity') {
      steps {
        echo "Hello from Jenkins"
        sh 'pwd && ls -la'
      }
    }
  }
}
