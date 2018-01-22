"""
routes.py - Define app routes
"""
from . import app
from flask import render_template, request
from werkzeug.utils import secure_filename


@app.route('/')
def index():
    return render_template('index.html')


@app.route('upload', methods=['POST'])
def upload():
    """
     Accepts a file upload and stores it on disk.
    """
    f = request.files['file']
    f.save(secure_filename(f.filename))
