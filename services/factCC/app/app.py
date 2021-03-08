import json
from flask import Flask, jsonify
from flask import request
from flask_cors import CORS
from factcc import init, evaluate

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

@app.route('/factcc', methods=['POST'])
def bertscore():
    if not request.is_json:
        error = "Request is not a JSON object."
        print(error)
        return make_error(400, error)

    content = request.get_json()
    print(content)

    if 'claims' not in content or 'source' not in content:
        error = "Request is malformed! Required fields: claims, source"
        print(error)
        return make_error(400, error)

    # create input
    json_inputs = []
    for id, claim in enumerate(content['claims']):
        json_inputs.append({
            "claim": claim,
            "label": "CORRECT",
            "id": id,
            "text": content['source']
        })

    # Evaluation
    labels, scores  = evaluate(json_inputs, prefix="test")

    # labels: ["CORRECT", "INCORRECT"]
    print(labels)
    print(scores)

    response = app.response_class(
        response=json.dumps({
            "faithful": labels,
            "scores": scores
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
