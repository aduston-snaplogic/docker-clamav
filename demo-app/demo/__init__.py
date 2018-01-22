"""
__init__.py - Initialize the demo app
"""
from flask import Flask
from os import getenv

# Initialize the Flask app
app = Flask(__name__, instance_relative_config=True)

# Get the location to store the uploaded files
app.config['UPLOAD_FOLDER'] = getenv('DEMO_UPLOAD_FOLDER', '/tmp')

# Set the maximum file size for uploads to 10M
app.config['MAX_CONTENT_LENGTH'] = 1000000

from . import routes