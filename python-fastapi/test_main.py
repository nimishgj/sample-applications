import pytest
from fastapi.testclient import TestClient
from main import app, users_db, User

client = TestClient(app)

def setup_function():
    global users_db
    users_db.clear()
    users_db.extend([
        User(id=1, name="John Doe", email="john@example.com"),
        User(id=2, name="Jane Smith", email="jane@example.com"),
    ])

def test_health_check():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "python-api-server"
    assert "timestamp" in data

def test_get_users():
    setup_function()
    response = client.get("/users")
    assert response.status_code == 200
    data = response.json()
    assert "users" in data
    assert data["total"] == 2
    assert len(data["users"]) == 2

def test_get_user_by_id():
    setup_function()
    response = client.get("/users/1")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == 1
    assert data["name"] == "John Doe"
    assert data["email"] == "john@example.com"

def test_get_user_by_id_not_found():
    setup_function()
    response = client.get("/users/999")
    assert response.status_code == 404
    data = response.json()
    assert data["detail"] == "User not found"

def test_create_user():
    setup_function()
    new_user = {
        "name": "Test User",
        "email": "test@example.com"
    }
    response = client.post("/users", json=new_user)
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Test User"
    assert data["email"] == "test@example.com"
    assert "id" in data

def test_create_user_invalid_email():
    setup_function()
    new_user = {
        "name": "Test User",
        "email": "invalid-email"
    }
    response = client.post("/users", json=new_user)
    assert response.status_code == 422

def test_update_user():
    setup_function()
    update_data = {
        "name": "Updated Name"
    }
    response = client.put("/users/1", json=update_data)
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Updated Name"
    assert data["email"] == "john@example.com"

def test_update_user_not_found():
    setup_function()
    update_data = {
        "name": "Updated Name"
    }
    response = client.put("/users/999", json=update_data)
    assert response.status_code == 404

def test_delete_user():
    setup_function()
    response = client.delete("/users/2")
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "User deleted successfully"

def test_delete_user_not_found():
    setup_function()
    response = client.delete("/users/999")
    assert response.status_code == 404