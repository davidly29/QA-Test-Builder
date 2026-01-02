pipeline {
  agent any

  parameters {
    string(name: 'PROJECT_DIR', defaultValue: 'examples/simple-junit', description: 'Path to Maven project containing pom.xml')
  }

  environment {
    RUNNER_IMAGE = "qa/test-runner:latest"
    SERENITY_DIR_REL = "${params.PROJECT_DIR}/target/site/serenity"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'pwd && ls -la'
      }
    }

    stage('Preflight') {
      steps {
        sh '''
          echo "Docker version:"
          docker version
          echo "Project dir:"
          ls -la "${WORKSPACE}/${PROJECT_DIR}"
          test -f "${WORKSPACE}/${PROJECT_DIR}/pom.xml"
        '''
      }
    }

    stage('Run Tests in Container') {
      steps {
        sh """
          docker run --rm \
            -v /var/jenkins_home:/var/jenkins_home \
            -e WORKSPACE=${WORKSPACE} \
            -w ${WORKSPACE}/${PROJECT_DIR} \
            ${RUNNER_IMAGE}
        """
      }
    }

    stage('Publish Serenity Report') {
      steps {
        sh """
          echo "Checking report directory: ${WORKSPACE}/${SERENITY_DIR_REL}"
          ls -la "${WORKSPACE}/${SERENITY_DIR_REL}" || true
        """

        // Requires HTML Publisher plugin
        publishHTML(target: [
          reportDir: "${SERENITY_DIR_REL}",
          reportFiles: "index.html",
          reportName: "Serenity Report",
          keepAll: true,
          alwaysLinkToLastBuild: true,
          allowMissing: true
        ])

        archiveArtifacts artifacts: "${SERENITY_DIR_REL}/**", fingerprint: true, allowEmptyArchive: true
      }
    }
  }

  post {
    always {
      echo "Build result: ${currentBuild.currentResult}"
    }
  }
}
