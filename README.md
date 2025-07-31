# Good Repository

> An _opinionated_ approach of a "good" repository.

## Features

- **Flask Web Application**: Simple web service with health check endpoint
- **Environment Configuration**: Configurable host, port, and debug settings via environment variables
- **Error Handling**: Proper 404 and 500 error responses
- **Logging**: Structured logging for monitoring and debugging
- **Health Check**: `/health` endpoint for container health monitoring
- **Unit Tests**: Comprehensive test coverage for application logic

## Environment Variables

- `FLASK_HOST`: Host to bind to (default: `0.0.0.0`)
- `FLASK_PORT`: Port to bind to (default: `8080`)
- `FLASK_DEBUG`: Enable debug mode (default: `false`)

## API Endpoints

- `GET /`: Returns "Hello, World!"
- `GET /health`: Returns health status as JSON

## Running Tests

```bash
python -m unittest discover tests/
```
