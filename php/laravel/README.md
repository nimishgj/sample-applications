# PHP Laravel REST API

A RESTful web service built with PHP and Laravel framework for user management operations, showcasing modern PHP development practices with the elegant Laravel ecosystem.

## Features

- **Laravel Framework**: The PHP framework for web artisans
- **Eloquent ORM Ready**: Built with Laravel's database patterns (using in-memory for demo)
- **Request Validation**: Laravel's built-in validation system
- **Artisan Commands**: Full Laravel CLI support
- **PHPUnit Testing**: Comprehensive test suite with Laravel's testing tools
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
- PHP 8.2 or higher
- Composer
- Git

### Installation & Running

1. **Clone and navigate to directory**:
   ```bash
   cd php/laravel
   ```

2. **Install dependencies**:
   ```bash
   composer install
   ```

3. **Set up environment**:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Run the application**:
   ```bash
   # Using Laravel's built-in server
   php artisan serve --host=0.0.0.0 --port=8080
   
   # Or using Apache/Nginx (configure virtual host to point to public/ directory)
   ```

5. **Access the API**:
   - Server runs on `http://localhost:8080`
   - Health check: `GET http://localhost:8080/health`

### Docker

Build and run with Docker:

```bash
docker build -t php-laravel-api .
docker run -p 8080:80 php-laravel-api
```

## Testing

Run the test suite:

```bash
# Run all tests
php artisan test

# Run with coverage
php artisan test --coverage

# Run specific test class
php artisan test --filter=UserControllerTest
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

The API includes Laravel's built-in validation:

- **User ID**: Must be a positive integer (route constraint)
- **Name**: Required string, max 255 characters
- **Email**: Must be a valid email format, max 255 characters
- **Update requests**: Fields are optional but must be valid if provided

## Dependencies

### Production
- **laravel/framework**: The Laravel framework core
- **guzzlehttp/guzzle**: HTTP client library
- **laravel/sanctum**: API authentication (ready for future use)

### Development  
- **phpunit/phpunit**: PHP testing framework
- **laravel/pint**: Code style fixer
- **spatie/laravel-ignition**: Beautiful error pages

## Project Structure

```
php/laravel/
├── app/
│   └── Http/
│       └── Controllers/
│           └── UserController.php    # Main API controller
├── routes/
│   ├── api.php                      # API routes (with /api prefix)
│   └── web.php                      # Web routes (direct access)
├── tests/
│   └── Feature/
│       └── UserControllerTest.php   # API endpoint tests
├── bootstrap/
│   └── app.php                      # Laravel bootstrap
├── public/
│   └── index.php                    # Application entry point
├── composer.json                    # PHP dependencies
├── phpunit.xml                      # Testing configuration
├── artisan                          # Laravel CLI tool
├── Dockerfile                       # Docker configuration
└── README.md                        # This file
```

## Laravel Features Demonstrated

- **Route Model Binding**: Clean parameter handling
- **Request Validation**: Automatic validation with custom rules
- **JSON Resources**: Structured API responses
- **Artisan Commands**: Full CLI integration
- **Service Container**: Dependency injection ready
- **Middleware Support**: Request/response processing pipeline

## Development Commands

```bash
# Install dependencies
composer install

# Generate application key
php artisan key:generate

# Run development server
php artisan serve --port=8080

# Run tests
php artisan test

# Clear application cache
php artisan cache:clear

# Check Laravel version
php artisan --version
```

## Architecture

This Laravel application follows the framework's conventions:

- **Controller**: Handles HTTP requests and returns responses
- **Routes**: Define API endpoints with parameter constraints  
- **Validation**: Uses Laravel's form request validation
- **Testing**: Feature tests for complete HTTP request flow
- **Configuration**: Environment-based configuration system