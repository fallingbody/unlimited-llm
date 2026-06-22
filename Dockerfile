# Use the official llama.cpp server image
FROM ghcr.io/ggml-org/llama.cpp:server

# Switch to root to install curl and configure directory permissions
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create directory for the models and set ownership to UID 1000 (Hugging Face default user)
RUN mkdir -p /models && chown -R 1000:1000 /models

# Switch to HF user
USER 1000

# Download the Qwen 2.5 Coder 14B Q4_K_M GGUF model during build
# This avoids downloading the 9GB model on every container startup
RUN curl -L -o /models/qwen2.5-coder-14b-instruct-q4_k_m.gguf \
    "https://huggingface.co/Qwen/Qwen2.5-Coder-14B-Instruct-GGUF/resolve/main/qwen2.5-coder-14b-instruct-q4_k_m.gguf"

# Expose port 7860 (Hugging Face default)
EXPOSE 7860

# Run llama-server with CPU-friendly parameters:
# --host 0.0.0.0      : Bind to all interfaces to accept incoming connections
# --port 7860          : Run on port 7860 (required by Hugging Face)
# --model              : Path to our model file
# --ctx-size 8192      : 8K context size (leaves ~4GB RAM free to avoid OOM on 16GB free tier)
# --threads 2          : Optimized for the 2 vCPUs allocated to free Spaces
ENTRYPOINT ["/llama-server", "--host", "0.0.0.0", "--port", "7860", "--model", "/models/qwen2.5-coder-14b-instruct-q4_k_m.gguf", "--ctx-size", "8192", "--threads", "2"]
