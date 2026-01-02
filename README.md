# QA Bootstrapper Appliance

Docker Compose “appliance” for CI + test automation:
- Jenkins CI
- Test runner (JUnit/TestNG + Serenity)
- Daily scheduling (Jenkins cron)
- Serenity HTML reports + email (later)

## Quick start
```bash
docker compose -f .\docker-compose.yaml up -d jenkins

Docker setup config notes

Jenkins container just needs the Docker CLI (the docker command).

The container shares the host’s Docker socket (/var/run/docker.sock) via a volume mount (you already have that in docker-compose.yaml).

So when Jenkins runs docker build or docker run, it actually controls the host Docker daemon, not one inside Jenkins.

Quick commands to rebuild project 
- docker compose -f .\docker-compose.yaml build test-runner
- docker compose -f .\docker-compose.yaml run --rm test-runner
