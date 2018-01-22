"""
run.py - Startup script for the demo Flask app
"""
from os import getenv
import demo

port = getenv('FLASK_PORT', 5000)

if __name__ == '__main__':
    demo.app.run(host='0.0.0.0', port=int(port))
