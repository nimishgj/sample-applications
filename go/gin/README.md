# Go Gin REST API

A simple REST API server built with Go and the Gin web framework for user management operations.

## Features

- **CRUD Operations**: Create, read, update, and delete users
- **JSON API**: RESTful endpoints with JSON request/response
- **Validation**: Input validation using Gin's binding features
- **Health Check**: Endpoint for service health monitoring
- **In-Memory Storage**: Simple in-memory data store for demonstration

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check endpoint |
| GET | `/users` | Get all users |
| GET | `/users/:id` | Get user by ID |
| POST | `/users` | Create a new user |
| PUT | `/users/:id` | Update existing user |
| DELETE | `/users/:id` | Delete user |

## Quick Start

### Prerequisites
- Go 1.21 or higher
- Git

### Installation & Running

1. **Clone and navigate to directory**:
   ```bash
   cd go/gin
   ```

2. **Install dependencies**:
   ```bash
   go mod download
   ```

3. **Run the application**:
   ```bash
   go run main.go
   ```

4. **Access the API**:
   - Server runs on `http://localhost:8080`
   - Health check: `GET http://localhost:8080/health`

### Docker

Build and run with Docker:

```bash
docker build -t go-gin-api .
docker run -p 8080:8080 go-gin-api
```

## Testing

Run the test suite:

```bash
go test -v
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

## Dependencies

- **Gin**: Fast HTTP web framework
- **Testify**: Testing toolkit for assertions and mocks

## Project Structure

```
go/gin/
├── main.go          # Main application file with routes and handlers
├── main_test.go     # Unit tests
├── go.mod           # Go module definition
├── go.sum           # Dependency checksums
├── Dockerfile       # Docker configuration
└── README.md        # This file
```

