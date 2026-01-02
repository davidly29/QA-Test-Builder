# docker/jenkins/Dockerfile
FROM jenkins/jenkins:lts

# Switch to root to install extra packages
USER root

# Install Docker client so Jenkins jobs can run sibling containers
RUN apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# Back to Jenkins user
USER jenkins

# Copy any Groovy init scripts (creates admin user etc.)
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
