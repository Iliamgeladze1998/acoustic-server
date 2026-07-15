from flask import Flask, send_file, send_from_directory

app = Flask(__name__)

@app.route('/')
def index():
    return send_file('/root/review-redirect/index.html')

@app.route('/favicon.ico')
@app.route('/logo_for_acoustic_browser_tab.png')
def favicon():
    return send_from_directory('/root/review-redirect', 'logo_for_acoustic_browser_tab.png')

@app.route('/acoustic_logo.png')
def acoustic_logo():
    return send_from_directory('/root/review-redirect', 'acoustic_logo.png')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5555)
