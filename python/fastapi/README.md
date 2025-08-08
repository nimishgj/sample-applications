# Python FastAPI REST API

A modern, high-performance REST API built with FastAPI and Python for user management operations, featuring automatic API documentation and type validation.

## Features

- **FastAPI**: Modern, fast web framework with automatic API docs
- **Type Safety**: Python type hints with runtime validation
- **Pydantic Models**: Data validation using Pydantic models
- **Async/Await**: Asynchronous request handling for better performance
- **OpenAPI/Swagger**: Automatic interactive API documentation
- **JSON API**: RESTful endpoints with JSON request/response
- **Health Check**: Endpoint for service health monitoring
- **In-Memory Storage**: Simple in-memory data store for demonstration

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check endpoint |
| GET | `/users` | Get all users |
| GET | `/users/{user_id}` | Get user by ID |
| POST | `/users` | Create a new user |
| PUT | `/users/{user_id}` | Update existing user |
| DELETE | `/users/{user_id}` | Delete user |

## Quick Start

### Prerequisites
- Python 3.8 or higher
- pip
- Git

### Installation & Running

1. **Clone and navigate to directory**:
   ```bash
   cd python/fastapi
   ```

2. **Create virtual environment (recommended)**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the application**:
   ```bash
   # Using uvicorn directly
   uvicorn main:app --host 0.0.0.0 --port 8080 --reload
   
   # Or using Python
   python main.py
   ```

5. **Access the API**:
   - Server runs on `http://localhost:8080`
   - Health check: `GET http://localhost:8080/health`
   - **Interactive API docs**: `http://localhost:8080/docs`
   - **Alternative docs**: `http://localhost:8080/redoc`

### Docker

Build and run with Docker:

```bash
docker build -t python-fastapi-api .
docker run -p 8080:8080 python-fastapi-api
```

## Testing

Run the test suite:

```bash
pytest test_main.py -v
```

## Example Usage

### Create a user:
```bash
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice Johnson", "email": "alice@example.com"}'
```

### Get all users:
```bash
curl http://localhost:8080/users
```

### Get user by ID:
```bash
curl http://localhost:8080/users/1
```

## Data Models

### User Model
```python
class User(BaseModel):
    id: int
    name: str
    email: str
```

### Request Models
- **CreateUserRequest**: `name` (str), `email` (EmailStr)
- **UpdateUserRequest**: `name` (Optional[str]), `email` (Optional[EmailStr])

## Dependencies

- **fastapi**: Modern web framework for building APIs
- **uvicorn**: ASGI web server for running FastAPI
- **pydantic**: Data validation using Python type annotations
- **pytest**: Testing framework
- **httpx**: HTTP client for testing

## Project Structure

```
python/fastapi/
├── main.py             # Main application file with routes and models
├── test_main.py        # Unit tests
├── requirements.txt    # Python dependencies
├── Dockerfile          # Docker configuration
└── README.md           # This file
```

## Key Features

### Automatic Documentation
FastAPI automatically generates interactive API documentation:
- **Swagger UI**: Available at `/docs`
- **ReDoc**: Available at `/redoc`
- **OpenAPI Schema**: Available at `/openapi.json`

### Type Safety
- Runtime type validation using Pydantic
- IDE support with type hints
- Automatic request/response model validation

### Performance
- Built on Starlette for high performance
- Async/await support for concurrent requests
- Comparable performance to NodeJS and Go

## Error Responses

The API returns structured error responses:
- **422 Unprocessable Entity**: Validation errors
- **404 Not Found**: User not found
- **500 Internal Server Error**: Unexpected server errors