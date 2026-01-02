FROM maven:3.9-eclipse-temurin-17

# Optional: UI test deps
RUN apt-get update && apt-get install -y chromium chromium-driver && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy the script into the image and make it executable; strip CRLF if present
COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


