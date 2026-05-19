from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

# Test 1 — Root endpoint
def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["project"] == "Cloud Native DevOps AIOps Platform"
    assert response.json()["author"] == "sri31"

# Test 2 — Health check endpoint
def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"

# Test 3 — System endpoint
def test_system():
    response = client.get("/system")
    assert response.status_code == 200
    assert "cpu" in response.json()
    assert "memory" in response.json()
    assert "disk" in response.json()

# Test 4 — Metrics endpoint
def test_metrics():
    response = client.get("/metrics")
    assert response.status_code == 200