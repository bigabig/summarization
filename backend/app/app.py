# https://programmingwithmosh.com/javascript/react-file-upload-proper-server-side-nodejs-easy/
# https://blog.miguelgrinberg.com/post/handling-file-uploads-with-flask
import json
import os
from flask import Flask, abort, jsonify
from flask import request
from flask_cors import CORS

import summarization as summarization
from pipeline import full_pipeline, annotation_pipeline
from extract import pdf_to_text, txt_to_text, url_to_text

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 10 * 1024 * 1024  # max 10mb
app.config['UPLOAD_EXTENSIONS'] = ['.txt', '.pdf']
app.config['UPLOAD_PATH'] = 'uploads'
CORS(app)


# ----------------------------------------------------------------------------------------------------------------------
# HELPER
# ----------------------------------------------------------------------------------------------------------------------

def make_error(status_code, message):
    response = jsonify({
        'status': status_code,
        'message': message,
    })
    response.status_code = status_code
    return response


# ----------------------------------------------------------------------------------------------------------------------
# TESTING
# ----------------------------------------------------------------------------------------------------------------------

@app.route('/')
def hello_world():
    input_document, summary_document = full_pipeline(input_text=summarization.ARTICLE, length=summarization.LENGTH)

    response = app.response_class(
        response=json.dumps({
                    'summary_document': summary_document,
                    'input_document': input_document
                }, default=lambda o: '<not serializable>'),
        status=200,
        mimetype='application/json'
    )
    return response


# ----------------------------------------------------------------------------------------------------------------------
# SUMMARIZATION
# ----------------------------------------------------------------------------------------------------------------------

@app.route('/summarize', methods=['POST'])
def summarize():
    if not request.is_json:
        error = "Request is not a JSON object."
        print(error)
        return make_error(400, error)

    content = request.get_json()
    print(content)

    if 'text' not in content or 'length' not in content or 'method' not in content:
        error = "Request is malformed! Required fields: text, length, method."
        print(error)
        return make_error(400, error)

    summarization.switch_method(content['method'])

    input_document, summary_document = full_pipeline(input_text=content["text"], length=content["length"])

    response = app.response_class(
        response=json.dumps({
                    'summary_document': summary_document,
                    'input_document': input_document
                }, default=lambda o: '<not serializable>'),
        status=200,
        mimetype='application/json'
    )
    return response


@app.route('/annotate', methods=['POST'])
def annotate():
    if not request.is_json:
        error = "Request is not a JSON object."
        print(error)
        return make_error(400, error)

    content = request.get_json()
    print(content)

    if 'text' not in content:
        error = "Request is malformed! Required fields: text."
        print(error)
        return make_error(400, error)

    document = annotation_pipeline(text=content["text"])

    response = app.response_class(
        response=json.dumps({
                    'document': document,
                }, default=lambda o: '<not serializable>'),
        status=200,
        mimetype='application/json'
    )
    return response


# ----------------------------------------------------------------------------------------------------------------------
# FILE EXTRACTION
# ----------------------------------------------------------------------------------------------------------------------

@app.route('/upload', methods=['POST'])
def upload_file():
    uploaded_file = request.files['file']
    filename = uploaded_file.filename
    if filename != '':
        file_ext = os.path.splitext(filename)[1]
        if file_ext not in app.config['UPLOAD_EXTENSIONS']:
            abort(400)
        filepath = os.path.join(app.config['UPLOAD_PATH'], filename)
        uploaded_file.save(filepath)

        # handle pdf files
        if file_ext == '.pdf':
            result = pdf_to_text(filepath)
        # handle txt files
        else:
            result = txt_to_text(filepath)

        return {"text": result}


@app.route('/extract', methods=['POST'])
def extract_text_from_url():
    if not request.is_json:
        error = "Request is not a JSON object."
        print(error)
        return make_error(400, error)

    content = request.get_json()
    print(content)

    if 'url' not in content:
        error = "Request is malformed! Required fields: url."
        print(error)
        return make_error(400, error)

    text = url_to_text(content["url"])

    if text:
        return {"text": url_to_text(content["url"]).splitlines()}
    else:
        return make_error(400, "An unexpected error occurred during extraction.")


def main():
    # start flask app
    app.run(host='0.0.0.0', port='3333')


if __name__ == '__main__':
    main()
