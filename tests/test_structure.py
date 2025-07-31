"""Integration tests for the application structure."""

import os
import sys
import unittest


class ApplicationStructureTestCase(unittest.TestCase):
    """Test the overall application structure and configuration."""

    def test_app_directory_exists(self):
        """Test that the app directory exists."""
        app_dir = os.path.join(os.path.dirname(__file__), "..", "app")
        self.assertTrue(os.path.exists(app_dir))

    def test_main_py_exists(self):
        """Test that main.py exists."""
        main_py = os.path.join(os.path.dirname(__file__), "..", "app", "main.py")
        self.assertTrue(os.path.exists(main_py))

    def test_main_py_has_docstring(self):
        """Test that main.py has a proper docstring."""
        main_py = os.path.join(os.path.dirname(__file__), "..", "app", "main.py")
        with open(main_py, 'r') as f:
            content = f.read()
            self.assertIn('"""Main module for the Flask application."""', content)

    def test_main_py_has_error_handlers(self):
        """Test that main.py includes error handlers."""
        main_py = os.path.join(os.path.dirname(__file__), "..", "app", "main.py")
        with open(main_py, 'r') as f:
            content = f.read()
            self.assertIn("@app.errorhandler(404)", content)
            self.assertIn("@app.errorhandler(500)", content)

    def test_main_py_has_health_endpoint(self):
        """Test that main.py includes health check endpoint."""
        main_py = os.path.join(os.path.dirname(__file__), "..", "app", "main.py")
        with open(main_py, 'r') as f:
            content = f.read()
            self.assertIn("/health", content)
            self.assertIn("health_check", content)

    def test_main_py_uses_environment_variables(self):
        """Test that main.py uses environment variables for configuration."""
        main_py = os.path.join(os.path.dirname(__file__), "..", "app", "main.py")
        with open(main_py, 'r') as f:
            content = f.read()
            self.assertIn("os.getenv", content)
            self.assertIn("FLASK_HOST", content)
            self.assertIn("FLASK_PORT", content)
            self.assertIn("FLASK_DEBUG", content)

    def test_main_py_has_logging(self):
        """Test that main.py includes logging configuration."""
        main_py = os.path.join(os.path.dirname(__file__), "..", "app", "main.py")
        with open(main_py, 'r') as f:
            content = f.read()
            self.assertIn("import logging", content)
            self.assertIn("logging.basicConfig", content)
            self.assertIn("app.logger", content)

    def test_tests_directory_exists(self):
        """Test that the tests directory exists."""
        tests_dir = os.path.dirname(__file__)
        self.assertTrue(os.path.exists(tests_dir))

    def test_test_files_exist(self):
        """Test that test files exist."""
        tests_dir = os.path.dirname(__file__)
        test_files = ["test_main.py", "test_main_mock.py", "test_structure.py"]
        
        for test_file in test_files:
            test_path = os.path.join(tests_dir, test_file)
            self.assertTrue(os.path.exists(test_path), f"Test file {test_file} should exist")


if __name__ == "__main__":
    unittest.main()