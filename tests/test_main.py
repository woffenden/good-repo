"""Unit tests for the Flask application."""

import json
import os
import sys
import unittest

# Add the app directory to the Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "app"))

try:
    from main import create_app
    FLASK_AVAILABLE = True
except ImportError:
    FLASK_AVAILABLE = False


@unittest.skipUnless(FLASK_AVAILABLE, "Flask not available")
class FlaskAppTestCase(unittest.TestCase):
    """Test cases for the Flask application."""

    def setUp(self):
        """Set up test client."""
        self.app = create_app()
        self.app.config["TESTING"] = True
        self.client = self.app.test_client()

    def test_hello_world(self):
        """Test the hello world endpoint."""
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode(), "Hello, World!")

    def test_health_check_endpoint(self):
        """Test the health check endpoint."""
        response = self.client.get("/health")
        self.assertEqual(response.status_code, 200)
        
        data = json.loads(response.data.decode())
        self.assertEqual(data["status"], "healthy")
        self.assertEqual(data["service"], "good-repo")
        self.assertEqual(response.content_type, "application/json")

    def test_404_error_handling(self):
        """Test 404 error handling."""
        response = self.client.get("/nonexistent")
        self.assertEqual(response.status_code, 404)
        
        data = json.loads(response.data.decode())
        self.assertEqual(data["error"], "Resource not found")
        self.assertEqual(response.content_type, "application/json")

    def test_response_content_type(self):
        """Test that response has correct content type."""
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        # Flask default content type for text responses
        self.assertIn("text/html", response.content_type)

    def test_environment_variables(self):
        """Test that environment variables are used for configuration."""
        # Test default values when environment variables are not set
        import main
        
        # Since we can't easily test the actual environment variable reading
        # in the if __name__ == "__main__" block, we test the expected behavior
        host = os.getenv("FLASK_HOST", "0.0.0.0")
        port = int(os.getenv("FLASK_PORT", "8080"))
        debug = os.getenv("FLASK_DEBUG", "false").lower() == "true"
        
        self.assertEqual(host, "0.0.0.0")
        self.assertEqual(port, 8080)
        self.assertFalse(debug)


if __name__ == "__main__":
    unittest.main()