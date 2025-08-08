# Sample Applications

A collection of identical REST API implementations across multiple programming languages and frameworks, plus AWS deployment configurations. Perfect for learning, comparing technologies, or using as starter templates.

## Overview

This repository demonstrates how to build the same user management REST API using different technology stacks. Each implementation provides identical functionality with language/framework-specific best practices.

## 🚀 Available Implementations

### Backend APIs

All applications implement the same User Management API with CRUD operations:

| Language | Framework | Directory | Key Features |
|----------|-----------|-----------|--------------|
| **Go** | Gin | [`go/gin/`](./go/gin/) | Fast HTTP framework, minimal dependencies |
| **Java** | Spring Boot | [`java/springboot/`](./java/springboot/) | Enterprise-grade, layered architecture |  
| **Node.js** | Express.js | [`nodejs/express/`](./nodejs/express/) | Middleware-based, comprehensive validation |
| **Python** | FastAPI | [`python/fastapi/`](./python/fastapi/) | Modern async API with auto-documentation |
| **PHP** | Laravel | [`php/laravel/`](./php/laravel/) | Elegant syntax, built-in ORM, artisan CLI |

### Cloud Deployment

| Platform | Service | Directory | Description |
|----------|---------|-----------|-------------|
| **AWS** | EKS EC2 | [`aws/eks/ec2/`](./aws/eks/ec2/) | Kubernetes cluster on EC2 instances |
| **AWS** | EKS Fargate | [`aws/eks/fargate/`](./aws/eks/fargate/) | Serverless Kubernetes deployment |

## 🔧 Common API Endpoints

All implementations expose these identical endpoints:

```
GET    /health           # Health check
GET    /users            # List all users  
GET    /users/:id        # Get user by ID
POST   /users            # Create new user
PUT    /users/:id        # Update existing user
DELETE /users/:id        # Delete user
```

### Sample API Calls

```bash
# Health check
curl http://localhost:8080/health

# Get all users
curl http://localhost:8080/users

# Create a user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe", "email": "john@example.com"}'

# Get user by ID
curl http://localhost:8080/users/1

# Update user
curl -X PUT http://localhost:8080/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Jane Doe"}'

# Delete user
curl -X DELETE http://localhost:8080/users/1
```

## 🏁 Quick Start

Choose your preferred technology and follow the setup instructions:

### Go (Gin)
```bash
cd go/gin
go mod download
go run main.go
```

### Java (Spring Boot)
```bash
cd java/springboot
mvn spring-boot:run
```

### Node.js (Express)
```bash
cd nodejs/express
npm install
npm start
```

### Python (FastAPI)
```bash
cd python/fastapi
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8080
```

### PHP (Laravel)
```bash
cd php/laravel
composer install
cp .env.example .env
php artisan key:generate
php artisan serve --host=0.0.0.0 --port=8080
```

All servers run on **http://localhost:8080**

## 🐳 Docker Support

Each application includes a Dockerfile. Build and run any implementation:

```bash
# Example with Go
cd go/gin
docker build -t sample-api .
docker run -p 8080:8080 sample-api
```

## 🧪 Testing

Each implementation includes unit tests:

```bash
# Go
go test -v

# Java  
mvn test

# Node.js
npm test

# Python
pytest -v

# PHP
php artisan test
```

## 📊 Performance Comparison

| Framework | Startup Time | Memory Usage | Throughput* |
|-----------|-------------|--------------|-------------|
| **Go/Gin** | ~100ms | ~10MB | High |
| **FastAPI** | ~200ms | ~15MB | High |
| **Laravel** | ~500ms | ~30MB | Medium |
| **Express** | ~300ms | ~25MB | Medium |
| **Spring Boot** | ~3s | ~150MB | High |

*Throughput varies based on workload and configuration

## 🌟 Key Features

### Consistent Functionality
- ✅ Identical API endpoints across all implementations
- ✅ Same request/response formats  
- ✅ Consistent error handling
- ✅ Health check endpoints

### Development Ready
- ✅ Input validation
- ✅ Unit tests included
- ✅ Docker containerization
- ✅ Development/production configurations
- ✅ Comprehensive documentation

### Cloud Deployment
- ✅ AWS EKS cluster setup scripts
- ✅ Load balancer configuration  
- ✅ Container orchestration examples

## 🏗️ Architecture

Each application follows framework-specific best practices:

- **Go**: Simple handlers with middleware
- **Java**: Layered architecture (Controller → Service → Model)
- **Node.js**: Middleware-based request processing
- **Python**: FastAPI with Pydantic models and async handlers
- **PHP**: Laravel MVC with Eloquent ORM and Artisan CLI

## 🤝 Use Cases

- **Learning**: Compare syntax and patterns across languages
- **Prototyping**: Quick API setup in your preferred stack  
- **Benchmarking**: Performance testing between frameworks
- **Teaching**: Demonstrate identical functionality in different languages
- **Migration**: Reference when moving between technology stacks

## 📖 Documentation

Each implementation has detailed documentation:
- [`go/gin/README.md`](./go/gin/README.md)
- [`java/springboot/README.md`](./java/springboot/README.md)  
- [`nodejs/express/README.md`](./nodejs/express/README.md)
- [`python/fastapi/README.md`](./python/fastapi/README.md)
- [`php/laravel/README.md`](./php/laravel/README.md)

## 🚀 Deployment

The repository includes AWS EKS deployment configurations for both EC2 and Fargate. See the [`aws/eks/`](./aws/eks/) directory for detailed setup instructions.

## 📄 License

This project is open source. Feel free to use these implementations as templates for your own projects.

## 🤝 Contributing

Found an issue or want to add a new framework implementation? Contributions are welcome! Please ensure any new implementations maintain API compatibility with existing ones.