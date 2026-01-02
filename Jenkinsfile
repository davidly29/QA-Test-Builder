pipeline {
  agent any
  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  parameters {
    string(name: 'PROJECT_DIR', defaultValue: 'examples/simple-junit', description: 'Path to Maven project containing pom.xml')
    booleanParam(name: 'DAILY_SCHEDULE', defaultValue: false, description: 'Enable daily scheduled run (cron)')
  }

  // If you want scheduling always-on, remove the parameters section and keep triggers.
  triggers {
    // Runs daily if enabled via parameter (Jenkins declarative triggers are static, so we handle schedule below as a fallback)
    // Keep empty here; we implement schedule by job config or a separate "nightly" job later.
  }

  environment {
    RUNNER_IMAGE = "qa/test-runner:latest"
    // Serenity output path relative to workspace (inside Jenkins)
    SERENITY_DIR_REL = "${params.PROJECT_DIR}/target/site/serenity"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'echo "Workspace:" && pwd && ls -la'
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
        // Mount /var/jenkins_home so the runner can see the same workspace path.
        // WORKSPACE is inside /var/jenkins_home/workspace/<job>
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
        // Even if report missing, don't fail this stage—just show logs.
        sh """
          echo "Checking report directory: ${WORKSPACE}/${SERENITY_DIR_REL}"
          ls -la "${WORKSPACE}/${SERENITY_DIR_REL}" || true
        """

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
      // Useful debugging info if something breaks later:
      sh 'echo "Disk usage:" && df -h || true'
    }
  }
}

