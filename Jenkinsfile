pipeline {
  agent any
  triggers { cron('H H * * *') } // daily
  options { timestamps(); ansiColor('xterm') }

  environment {
    PROJECT_DIR = "examples/simple-junit"
    SERENITY_DIR = "examples/simple-junit/target/site/serenity"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Run tests (container)') {
      steps {
        sh '''
          docker run --rm \
            -v /var/jenkins_home:/var/jenkins_home \
            -e WORKSPACE=${WORKSPACE} \
            -w ${WORKSPACE}/${PROJECT_DIR} \
            qa/test-runner:latest
        '''
      }
    }

    stage('Publish Serenity Report') {
      steps {
        publishHTML(target: [
          reportDir: "${SERENITY_DIR}",
          reportFiles: "index.html",
          reportName: "Serenity Report",
          keepAll: true,
          alwaysLinkToLastBuild: true
        ])
        archiveArtifacts artifacts: "${SERENITY_DIR}/**", fingerprint: true
      }
    }
  }

  // Add email later once SMTP is configured
}
