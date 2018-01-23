"""
routes.py - Define app routes
"""
from . import app
from flask import render_template, request, url_for
from werkzeug.utils import secure_filename
from os import path


@app.route('/')
def index():
    app.logger.info(url_for('upload', _external=True))
    return render_template('index.html', upload_url=url_for('upload', _external=True))


@app.route('/upload', methods=['POST'])
def upload():
    """
     Accepts a file upload and stores it on disk.
    """
    f = request.files['file']
    filename = secure_filename(f.filename)
    f.save(path.join(app.config['UPLOAD_FOLDER'], filename))
    return "%s uploaded successfully" % f.filename
