#!/bin/bash
set -euo pipefail

# Move into the examples project so we find pom.xml
cd /workspace/examples/simple-junit

echo "[QA Runner] CWD: $(pwd)"
mvn -q -B clean verify -Dserenity.outputDirectory=target/site/serenity
echo "[QA Runner] Report -> target/site/serenity/index.html"


