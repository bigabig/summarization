import json
from flask import Flask, jsonify
from flask import request
from flask_cors import CORS


from qaqg import calculate

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

@app.route('/qgqa', methods=['POST'])
def qgqa():
    if not request.is_json:
        error = "Request is not a JSON object."
        print(error)
        return make_error(400, error)

    content = request.get_json()
    print(content)

    if 'text1' not in content or 'text2' not in content:
        error = "Request is malformed! Required fields: source, summary."
        print(error)
        return make_error(400, error)

    # calculate qgqa scores
    questions_answers, score = calculate(text1=content['text1'], text2=content['text2'])

    response = app.response_class(
        response=json.dumps({
                    'qaqg': questions_answers,
                    'score': score
                }, default=lambda o: '<not serializable>'),
        status=200,
        mimetype='application/json'
    )
    return response


def main():
    # start flask app
    app.run(host='0.0.0.0', port='4444')


if __name__ == '__main__':
    main()
