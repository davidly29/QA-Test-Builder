pipeline {
  agent any
  options { timestamps() }

  stages {
    stage('Sanity') {
      steps {
        echo "Hello from Jenkins"
        sh 'pwd && ls -la'
      }
    }
  }
}
