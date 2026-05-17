# ──────────────────────────────────────────
# Base Image — Python 3.12 Slim
# Lightweight and production suitable
# ──────────────────────────────────────────
FROM python:3.12-slim

# ──────────────────────────────────────────
# Set working directory inside container
# All commands will run from /app
# ──────────────────────────────────────────
WORKDIR /app

# ──────────────────────────────────────────
# Copy requirements first
# Docker caches this layer — speeds up builds
# if only code changes, not dependencies
# ──────────────────────────────────────────
COPY requirements.txt .

# ──────────────────────────────────────────
# Install dependencies
# --no-cache-dir keeps image size small
# ──────────────────────────────────────────
RUN pip install --no-cache-dir -r requirements.txt

# ──────────────────────────────────────────
# Copy application code
# ──────────────────────────────────────────
COPY . .

# ──────────────────────────────────────────
# Expose port 8000
# FastAPI runs on this port
# ──────────────────────────────────────────
EXPOSE 8000

# ──────────────────────────────────────────
# Start the application
# uvicorn is the server that runs FastAPI
# --host 0.0.0.0 makes it accessible outside container
# ──────────────────────────────────────────
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]