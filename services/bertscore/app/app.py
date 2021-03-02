import json
from flask import Flask, jsonify
from flask import request
from flask_cors import CORS


from bertscore import calculate_bertscore

app = Flask(__name__)
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
# MAIN
# ----------------------------------------------------------------------------------------------------------------------

@app.route('/bertscore', methods=['POST'])
def bertscore():
    if not request.is_json:
        error = "Request is not a JSON object."
        print(error)
        return make_error(400, error)

    content = request.get_json()
    print(content)

    if 'source_document' not in content or 'summary_document' not in content:
        error = "Request is malformed! Required fields: source_document, summary_document."
        print(error)
        return make_error(400, error)

    # calculate bert scores
    result = calculate_bertscore(source_document=content['source_document'],
                                 summary_document=content['summary_document'])

    response = app.response_class(
        response=json.dumps(result, default=lambda o: '<not serializable>'),
        status=200,
        mimetype='application/json'
    )
    return response


def main():
    # start flask app
    app.run(host='0.0.0.0', port='4444')


if __name__ == '__main__':
    main()
