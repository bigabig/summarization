import json
from operator import itemgetter
from space import split_sentences

from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport

# Select your transport with a defined url endpoint
transport = AIOHTTPTransport(url="http://localhost:8080/v1/graphql", headers={'X-Hasura-Admin-Secret': 'myadminsecretkey'})

# Create a GraphQL client using the defined transport
client = Client(transport=transport, fetch_schema_from_transport=True)


def insert_project(graphql_client, name):
    mutation = gql(
        """
        mutation InsertProject($name: String!, $user_id: String!) {
          insert_projects_one(object: {name: $name, user_id: $user_id}) {
            id
          }
        }
        """
    )

    params = {
        "name": name,
        "user_id": "b6198bf1-5e8d-479d-9bd1-1e6a0c21f04b"
    }
    result = graphql_client.execute(mutation, variable_values=params)
    new_project_id = result['insert_projects_one']['id']
    return new_project_id


def insert_file(graphql_client, project_id, name, content):
    mutation = gql(
        """
        mutation InsertFile($project_id: Int!, $name: String, $content: String) {
          insert_files_one(object: {name: $name, project_id: $project_id, content: $content}) {
            id
          }
        }
        """
    )

    params = {
        "project_id": project_id,
        "name": name,
        "content": content,
    }
    result = graphql_client.execute(mutation, variable_values=params)
    new_file_id = result['insert_files_one']['id']
    return new_file_id


# read evaluation results
INPUT_PATH = '/home/tim/Development/summarization/data/cnn_dm/cnn_dm_metrics.txt'
with open(INPUT_PATH, mode='r', encoding='UTF-8') as input_file:
    json_results = [json.loads(result) for result in input_file.readlines()]

# write output files for each score
for score in ['rouge1', "rouge2", "rougeL", "rougeLsum"]:
    getter = itemgetter(score)
    json_results.sort(key=getter)

    project_id = insert_project(client, score)

    OUTPUT_PATH = f'/home/tim/Development/summarization/data/cnn_dm/best{score}.txt'
    with open(OUTPUT_PATH, mode='w', encoding='UTF-8') as output_file:
        output_file.write(json.dumps(json_results[-100:-95]))

    OUTPUT_PATH = f'/home/tim/Development/summarization/data/cnn_dm/best_readable_{score}.txt'
    with open(OUTPUT_PATH, mode='w', encoding='UTF-8') as output_file:
        counter = 1
        for result in json_results[-100:-95]:
            content = "\n".join(split_sentences(result["input"]))
            output_file.write(content)
            output_file.write("\n\n----------\n\n")
            insert_file(client, project_id, f"good_example_{counter}_{score}={result[score]}.txt", content)
            counter += 1

    OUTPUT_PATH = f'/home/tim/Development/summarization/data/cnn_dm/worst_{score}.txt'
    with open(OUTPUT_PATH, mode='w', encoding='UTF-8') as output_file:
        output_file.write(json.dumps(json_results[95:100]))

    OUTPUT_PATH = f'/home/tim/Development/summarization/data/cnn_dm/worst_readable_{score}.txt'
    with open(OUTPUT_PATH, mode='w', encoding='UTF-8') as output_file:
        for result in json_results[95:100]:
            content = "\n".join(split_sentences(result["input"]))
            output_file.write(content)
            output_file.write("\n\n----------\n\n")
            insert_file(client, project_id, f"bad_example_{counter}_{score}={result[score]}.txt", content)
            counter += 1
