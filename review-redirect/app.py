from flask import Flask, send_file, send_from_directory
import os

app = Flask(__name__)

@app.route('/')
def index():
    return send_file('/root/review-redirect/index.html')

@app.route('/favicon.ico')
@app.route('/image.png')
def favicon():
    return send_from_directory('/root/review-redirect', 'image.png')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5555)
