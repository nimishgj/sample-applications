# Java Spring Boot REST API

A RESTful web service built with Spring Boot for user management operations, demonstrating modern Java enterprise application development.

## Features

- **Spring Boot**: Production-ready Spring applications with minimal configuration
- **REST Controller**: Clean separation of concerns with controller layer
- **Service Layer**: Business logic encapsulated in service classes
- **DTO Pattern**: Data Transfer Objects for request/response handling
- **Bean Validation**: Jakarta validation annotations for input validation
- **JSON API**: RESTful endpoints with JSON request/response
- **Health Check**: Endpoint for service health monitoring
- **In-Memory Storage**: Simple in-memory data store for demonstration

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check endpoint |
| GET | `/users` | Get all users |
| GET | `/users/{id}` | Get user by ID |
| POST | `/users` | Create a new user |
| PUT | `/users/{id}` | Update existing user |
| DELETE | `/users/{id}` | Delete user |

## Quick Start

### Prerequisites
- Java 17 or higher
- Maven 3.6 or higher
- Git

### Installation & Running

1. **Clone and navigate to directory**:
   ```bash
   cd java/springboot
   ```

2. **Build the application**:
   ```bash
   mvn clean compile
   ```

3. **Run the application**:
   ```bash
   mvn spring-boot:run
   ```

4. **Access the API**:
   - Server runs on `http://localhost:8080`
   - Health check: `GET http://localhost:8080/health`

### Docker

Build and run with Docker:

```bash
docker build -t java-springboot-api .
docker run -p 8080:8080 java-springboot-api
```

## Testing

Run the test suite:

```bash
mvn test
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

## Project Structure

```
java/springboot/
├── src/
│   ├── main/
│   │   ├── java/com/example/apiserver/
│   │   │   ├── ApiServerApplication.java    # Main Spring Boot application
│   │   │   ├── controller/
│   │   │   │   └── UserController.java      # REST endpoints
│   │   │   ├── service/
│   │   │   │   └── UserService.java         # Business logic
│   │   │   ├── model/
│   │   │   │   └── User.java                # User entity
│   │   │   └── dto/
│   │   │       ├── CreateUserRequest.java   # Create user DTO
│   │   │       └── UpdateUserRequest.java   # Update user DTO
│   │   └── resources/
│   │       └── application.properties       # Application configuration
│   └── test/
│       └── java/com/example/apiserver/
│           └── controller/
│               └── UserControllerTest.java  # Controller tests
├── pom.xml                                  # Maven configuration
├── Dockerfile                               # Docker configuration
└── README.md                                # This file
```

## Dependencies

- **Spring Boot Starter Web**: Web applications with RESTful services
- **Spring Boot Starter Validation**: Bean validation with Hibernate Validator
- **Spring Boot Starter Test**: Testing starter with JUnit, Hamcrest and Mockito

## Architecture

This application follows Spring Boot best practices:

- **Controller Layer**: Handles HTTP requests and responses
- **Service Layer**: Contains business logic and data manipulation
- **Model Layer**: Entity classes representing data structures
- **DTO Layer**: Data Transfer Objects for API contracts