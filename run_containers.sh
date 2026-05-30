#!/bin/bash

# Step 1: Run the Ollama container with a named volume and exposed port
docker run -d \
  --name ollama \
  -v ollama-data:/root/.ollama \
  -p 11434:11434 \
  ollama/ollama

# Check if the Ollama container is running successfully
if [ $? -eq 0 ]; then
  echo "Ollama container started successfully."
else
  echo "Failed to start Ollama container."
  exit 1
fi

# Step 2: Install and run Llama 3 model inside the Ollama container
echo "Running Llama 3 model installation inside the Ollama container..."
docker exec -it ollama ollama run SmolLM2

# Check if the Llama 3 model installed successfully
if [ $? -eq 0 ]; then
  echo "Llama 3 model installed and running successfully."
else
  echo "Failed to run Llama 3 model."
  exit 1
fi

# Step 3: Run the Open-WebUI container with the necessary host binding and volumes
docker run -d \
  --name open-webui \
  -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui-data:/app/backend/data \
  --restart always \
  ghcr.io/open-webui/open-webui:main

# Check if the Open-WebUI container is running successfully
if [ $? -eq 0 ]; then
  echo "Open-WebUI container started successfully."
else
  echo "Failed to start Open-WebUI container."
  exit 1
fi

# Step 4: Print the status of the running containers
docker ps
