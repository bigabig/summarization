import React from 'react';
import ReactDOM from 'react-dom';
import App from "../src/App";
import {ApolloClient, ApolloProvider, gql, InMemoryCache} from "@apollo/client";
import {initializeKeycloak, keycloak} from "./api/keycloak";

// styles
import 'bootstrap/dist/css/bootstrap.min.css';
import './index.css';


// testing out stuff

const run = async() => {
    await initializeKeycloak()
    // @ts-ignore
    const client = new ApolloClient({
        uri: 'http://localhost:8080/v1/graphql',
        headers: {
            // 'X-Hasura-Admin-Secret': 'myadminsecretkey' //**this works too**
            Authorization: `Bearer ${keycloak.token}`,
        },
        cache: new InMemoryCache({
            typePolicies: {
                Query: {
                    fields: {
                        projects_by_pk: (_, { args, toReference }) => {
                            return toReference({
                                __typename: 'projects',
                                // @ts-ignore
                                id: args.id,
                            });
                        },
                        files_by_pk: (_, { args, toReference }) => {
                            return toReference({
                                __typename: 'files',
                                // @ts-ignore
                                id: args.id,
                            });
                        }
                    }
                }
            }
        })
    });

    // client.query({query: gql`
    // query GetPosts {
    //     projects {
    //         name
    //     }
    // }`
    // }).then(result => console.log(result)).catch(error => console.log(error))

    ReactDOM.render(
        <React.StrictMode>
            <ApolloProvider client={client}>
                <App />
            </ApolloProvider>
        </React.StrictMode>,
        document.getElementById('root')
    );
};

run()

