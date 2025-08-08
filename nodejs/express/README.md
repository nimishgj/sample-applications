# Node.js Express REST API

A RESTful web service built with Node.js and Express.js for user management operations, featuring comprehensive input validation and error handling.

## Features

- **Express.js**: Fast, unopinionated web framework for Node.js
- **Input Validation**: Comprehensive validation using express-validator
- **CORS Support**: Cross-Origin Resource Sharing enabled
- **Error Handling**: Centralized error handling middleware
- **JSON API**: RESTful endpoints with JSON request/response
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
- Node.js 16 or higher
- npm or yarn
- Git

### Installation & Running

1. **Clone and navigate to directory**:
   ```bash
   cd nodejs/express
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Run the application**:
   ```bash
   # Development mode with auto-restart
   npm run dev
   
   # Production mode
   npm start
   ```

4. **Access the API**:
   - Server runs on `http://localhost:8080`
   - Health check: `GET http://localhost:8080/health`

### Docker

Build and run with Docker:

```bash
docker build -t nodejs-express-api .
docker run -p 8080:8080 nodejs-express-api
```

## Testing

Run the test suite:

```bash
npm test
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

## Validation Rules

The API includes comprehensive input validation:

- **User ID**: Must be a positive integer
- **Name**: Required, cannot be empty
- **Email**: Must be a valid email format

## Dependencies

### Production
- **express**: Web application framework
- **express-validator**: Middleware for input validation
- **cors**: Enable Cross-Origin Resource Sharing

### Development
- **jest**: JavaScript testing framework
- **supertest**: HTTP assertion library for testing
- **nodemon**: Development server with auto-restart

## Project Structure

```
nodejs/express/
├── server.js           # Main application file with routes and middleware
├── server.test.js      # Unit tests
├── package.json        # npm configuration and dependencies
├── Dockerfile          # Docker configuration
└── README.md           # This file
```

## Middleware Stack

1. **CORS**: Enables cross-origin requests
2. **JSON Parser**: Parses JSON request bodies
3. **Validation**: Input validation using express-validator
4. **Route Handlers**: Business logic for each endpoint
5. **Error Handlers**: Centralized error handling and 404 responses

## Error Handling

The application includes comprehensive error handling:

- **400 Bad Request**: Invalid input data or validation errors
- **404 Not Found**: User not found or invalid routes
- **500 Internal Server Error**: Unexpected server errors