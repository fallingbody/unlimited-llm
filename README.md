---
title: Qwen2.5 Coder 14B Q4_K_M
emoji: 💻
colorFrom: blue
colorTo: purple
sdk: docker
pinned: false
---

# Qwen 2.5 Coder 14B Q4_K_M on Hugging Face Spaces

This repository contains the configuration to run **Qwen 2.5 Coder 14B Q4_K_M** (quantized GGUF format) on a free Hugging Face CPU-only Space using a high-performance C++ `llama-server`.

## Features
- **Zero Python Overhead**: Runs on pure C++ `llama.cpp` server.
- **Embedded Web UI**: Built-in interactive Web UI to test prompts, chat, and customize system settings.
- **OpenAI-Compatible API**: Exposes an endpoint (`/v1/chat/completions`) to integrate directly with IDE extensions like **Continue.dev**, **Cursor**, **Tabby**, or **VS Code**.
- **Instant Start**: The model is baked into the Docker image, so there's no download wait time when the Space wakes up from sleep.

---

## 🚀 How to Deploy to Hugging Face Spaces

### Step 1: Create a Space on Hugging Face
1. Go to [huggingface.co/new-space](https://huggingface.co/new-space).
2. Choose a name (e.g., `qwen2.5-coder-14b-gguf`).
3. Select **Docker** as the SDK.
4. Choose **Blank** template.
5. Set Space visibility to **Public** or **Private** (Private is recommended if you want to restrict API usage).
6. Click **Create Space**.

### Step 2: Initialize Git and Push to Hugging Face
On your local machine, run the following commands in the directory containing `Dockerfile` and `README.md`:

```bash
# Initialize git repository
git init -b main

# Add files
git add .
git commit -m "Initial commit for llama.cpp server"

# Add Hugging Face Space remote
git remote add origin https://huggingface.co/spaces/fallingbody/unlimited-llm

# Push to deploy (this will prompt for your Hugging Face username and password/token)
git push -u origin main --force
```

---

## 🔗 Automated CI/CD Pipeline (GitHub to Hugging Face Spaces)

You can set up a GitHub Actions workflow to automatically push changes to your Hugging Face Space whenever you push code to your GitHub repository.

### Step 1: Get a Hugging Face Write Token
1. Go to your [Hugging Face Access Tokens page](https://huggingface.co/settings/tokens).
2. Create a new token with **Write** role.

### Step 2: Add Token to GitHub Secrets
1. Go to your GitHub repository.
2. Navigate to **Settings > Secrets and variables > Actions**.
3. Click **New repository secret**.
4. Name the secret `HF_TOKEN` and paste your Hugging Face Write token.

### Step 3: Configure Repo Details in deploy.yml
1. Open `.github/workflows/deploy.yml` in your repository.
2. Verify that `huggingface_repo_id` is set to `fallingbody/unlimited-llm`.
3. Push your repository to GitHub. The GitHub Actions runner will automatically trigger and sync the code to Hugging Face!

---

## 🔒 Optional: Add an API Key

To prevent unauthorized access to your Space's endpoint:
1. Go to your Hugging Face Space settings page.
2. Under **Variables and secrets**, click **New secret**.
3. Set the name to `LLAMA_API_KEY` and the value to your chosen secret key (e.g. `my-super-secret-key`).
4. Re-run or restart the Space. The server will automatically lock itself using this key.

---

## 💻 Connecting to IDE Extensions (e.g., Continue.dev)

You can connect extensions like **Continue.dev** (VS Code, JetBrains) directly to your Space!

In your `config.json` for Continue, add the following configuration:

```json
{
  "models": [
    {
      "title": "Qwen 2.5 Coder 14B (HF Space)",
      "provider": "openai",
      "model": "qwen2.5-coder-14b-instruct",
      "apiBase": "https://fallingbody-unlimited-llm.hf.space/v1",
      "apiKey": "YOUR_LLAMA_API_KEY_SECRET" // Leave empty if you didn't set LLAMA_API_KEY
    }
  ]
}
```

*Note: Replace `fallingbody-unlimited-llm` with your actual Space subdomain if different (using a hyphen between username and space name).*

---

## 🛠️ Local Testing (Using Docker)

If you want to build and test this container locally before pushing:

```bash
# Build the image (downloads the 9GB model, will take a couple minutes)
docker build -t qwen-coder-local .

# Run the container
docker run -p 7860:7860 qwen-coder-local
```

Once running, navigate to `http://localhost:7860` in your browser.
