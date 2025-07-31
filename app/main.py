"""Main module for the Flask application."""

import logging
import os

from flask import Flask, jsonify


def create_app():
    """Create and configure the Flask application."""
    app = Flask(__name__)
    
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    
    @app.route("/")
    def hello():
        """Return a friendly greeting."""
        app.logger.info("Hello endpoint accessed")
        return "Hello, World!"
    
    @app.route("/health")
    def health_check():
        """Health check endpoint for container monitoring."""
        app.logger.info("Health check endpoint accessed")
        return jsonify({"status": "healthy", "service": "good-repo"})
    
    @app.errorhandler(404)
    def not_found(error):
        """Handle 404 errors."""
        app.logger.warning(f"404 error: {error}")
        return jsonify({"error": "Resource not found"}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        """Handle 500 errors."""
        app.logger.error(f"500 error: {error}")
        return jsonify({"error": "Internal server error"}), 500
    
    return app


# Create app instance
app = create_app()


if __name__ == "__main__":
    # Use environment variables for configuration
    host = os.getenv("FLASK_HOST", "0.0.0.0")
    port = int(os.getenv("FLASK_PORT", "8080"))
    debug = os.getenv("FLASK_DEBUG", "false").lower() == "true"
    
    app.logger.info(f"Starting Flask app on {host}:{port}")
    app.run(host=host, port=port, debug=debug)
