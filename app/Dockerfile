# ──────────────────────────────────────────
# Base Image — Python 3.12 Slim
# Lightweight and production suitable
# ──────────────────────────────────────────
FROM python:3.12-slim

# ──────────────────────────────────────────
# Set working directory inside container
# ──────────────────────────────────────────
WORKDIR /app

# ──────────────────────────────────────────
# Copy requirements first
# Docker caches this layer
# ──────────────────────────────────────────
COPY requirements.txt .

# ──────────────────────────────────────────
# Install dependencies
# ──────────────────────────────────────────
RUN pip install --no-cache-dir -r requirements.txt

# ──────────────────────────────────────────
# Create non-root user for security
# ──────────────────────────────────────────
RUN adduser --disabled-password --gecos '' appuser

# ──────────────────────────────────────────
# Copy application code
# ──────────────────────────────────────────
COPY . .

# ──────────────────────────────────────────
# Switch to non-root user
# ──────────────────────────────────────────
USER appuser

# ──────────────────────────────────────────
# Expose port 8000
# ──────────────────────────────────────────
EXPOSE 8000

# ──────────────────────────────────────────
# Start the application
# ──────────────────────────────────────────
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]