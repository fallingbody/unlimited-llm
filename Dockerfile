# Use the official llama.cpp server image
FROM ghcr.io/ggml-org/llama.cpp:server

# Set cache directory to /tmp to ensure write permissions in the HF unprivileged environment
ENV LLAMA_CACHE=/tmp

# Expose port 7860 (Hugging Face default)
EXPOSE 7860

# Run llama-server using native Hugging Face integration:
# --host 0.0.0.0      : Bind to all interfaces to accept incoming connections
# --port 7860          : Run on port 7860 (required by Hugging Face)
# --hf-repo            : The Hugging Face GGUF repository
# --hf-file            : The specific Q4_K_M GGUF model file
# --ctx-size 8192      : 8K context size (leaves ~4GB RAM free to avoid OOM on 16GB free tier)
# --threads 2          : Optimized for the 2 vCPUs allocated to free Spaces
ENTRYPOINT ["/app/llama-server", "--host", "0.0.0.0", "--port", "7860", "--hf-repo", "Qwen/Qwen2.5-Coder-7B-Instruct-GGUF", "--hf-file", "qwen2.5-coder-7b-instruct-q4_k_m.gguf", "--ctx-size", "16384", "--threads", "2"]
