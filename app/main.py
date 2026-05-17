from fastapi import FastAPI, Request
from prometheus_client import Counter, Histogram, Gauge, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response
import time
import psutil

# ──────────────────────────────────────────
# App Instance
# ──────────────────────────────────────────
app = FastAPI(
    title="Cloud Native DevOps AIOps Platform",
    description="""
    A production-grade System Health Dashboard built by sri31.
    Exposes real system metrics for Prometheus scraping and Grafana visualization.
    Part of a full DevOps + AIOps pipeline using Kubernetes, Terraform, Ansible, ArgoCD, Vault and Ollama.
    GitHub: https://github.com/sri31/cloud-native-devops-aiops-platform
    """,
    version="1.0.0"
)

# ──────────────────────────────────────────
# Prometheus Metrics Definition
# ──────────────────────────────────────────
REQUEST_COUNT = Counter(
    'http_requests_total',
    'Total number of HTTP requests',
    ['method', 'endpoint', 'status']
)

REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP request latency in seconds',
    ['endpoint']
)

CPU_USAGE = Gauge(
    'system_cpu_usage_percent',
    'Current system CPU usage percentage'
)

MEMORY_USAGE = Gauge(
    'system_memory_usage_percent',
    'Current system memory usage percentage'
)

DISK_USAGE = Gauge(
    'system_disk_usage_percent',
    'Current system disk usage percentage'
)

APP_INFO = Gauge(
    'app_info',
    'Application information',
    ['version', 'app_name', 'author']
)

APP_INFO.labels(
    version="1.0.0",
    app_name="cloud-native-devops-aiops-platform",
    author="sri31"
).set(1)

# ──────────────────────────────────────────
# Middleware — Auto track every request
# ──────────────────────────────────────────
@app.middleware("http")
async def track_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    duration = time.time() - start_time

    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.url.path,
        status=response.status_code
    ).inc()

    REQUEST_LATENCY.labels(
        endpoint=request.url.path
    ).observe(duration)

    return response

# ──────────────────────────────────────────
# Endpoints
# ──────────────────────────────────────────
@app.get("/")
async def root():
    return {
        "project": "Cloud Native DevOps AIOps Platform",
        "author": "sri31",
        "docker_hub": "https://hub.docker.com/r/srinidhi1989/cloud-native-devops-aiops-platform",
        "version": "1.0.0",
        "description": "Production-grade System Health Dashboard with full DevOps + AIOps pipeline",
        "endpoints": {
            "health": "/health",
            "metrics": "/metrics",
            "system": "/system"
        }
    }


@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "version": "1.0.0",
        "app": "cloud-native-devops-aiops-platform"
    }


@app.get("/system")
async def system_health():
    # Read real system stats using psutil
    cpu = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory()
    disk = psutil.disk_usage('/')

    # Update Prometheus gauges with latest values
    CPU_USAGE.set(cpu)
    MEMORY_USAGE.set(memory.percent)
    DISK_USAGE.set(disk.percent)

    return {
        "cpu": {
            "usage_percent": cpu
        },
        "memory": {
            "total_gb": round(memory.total / (1024**3), 2),
            "used_gb": round(memory.used / (1024**3), 2),
            "usage_percent": memory.percent
        },
        "disk": {
            "total_gb": round(disk.total / (1024**3), 2),
            "used_gb": round(disk.used / (1024**3), 2),
            "usage_percent": disk.percent
        }
    }


@app.get("/metrics")
async def metrics():
    # Update system metrics before Prometheus scrapes
    cpu = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory()
    disk = psutil.disk_usage('/')

    CPU_USAGE.set(cpu)
    MEMORY_USAGE.set(memory.percent)
    DISK_USAGE.set(disk.percent)

    return Response(
        generate_latest(),
        media_type=CONTENT_TYPE_LATEST
    )