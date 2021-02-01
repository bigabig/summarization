import React from 'react';
import ReactDOM from 'react-dom';
import App from "../src/App";
import {ApolloClient, ApolloProvider, HttpLink, InMemoryCache} from "@apollo/client";
import {initializeKeycloak, keycloak} from "./api/keycloak";

// styles
import 'bootstrap/dist/css/bootstrap.min.css';
import './index.css';
import {setContext} from "@apollo/client/link/context";


const run = async() => {
    await initializeKeycloak()

    //to regenerate token on expiry
    keycloak.onTokenExpired = () => {
        console.log("Token has expired!")
        keycloak.updateToken(70).then(refreshed => {
            if (refreshed) {
                console.log('Token refreshed! ' + keycloak.token);
            } else {
                console.log('Token not refreshed!');
            }
        }).catch(() => {
            alert('Failed to refresh access token! Please refresh the site. We are sorry for the inconvenience!');
        })
    }

    keycloak.updateToken(-1).then((result) => {
        console.log(result);
    }).catch(error => {
        console.log(error)
    })

    const link = new HttpLink({ uri: 'http://localhost:8080/v1/graphql' });

    const setAuthorizationLink = setContext((request, previousContext) => ({
        headers: {
            ...previousContext.headers,
            authorization: `Bearer ${ keycloak.token }`
        }
    }));

    // @ts-ignore
    const client = new ApolloClient({
        // uri: 'http://localhost:8080/v1/graphql',
        //
        // headers: {
        //     // 'X-Hasura-Admin-Secret': 'myadminsecretkey' //**this works too**
        //     Authorization: `Bearer ${keycloak.token}`,
        //
        // },
        link: setAuthorizationLink.concat(link),
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
                                // @ts-ignore
                                project_id: args.project_id
                            });
                        },
                        insert_files_one: (_, { args, toReference }) => {
                            return toReference({
                                __typename: 'files',
                                // @ts-ignore
                                id: args.id,
                                // @ts-ignore
                                project_id: args.project_id
                            });
                        },
                        update_files_by_pk: (_, { args, toReference }) => {
                            return toReference({
                                __typename: 'files',
                                // @ts-ignore
                                id: args.id,
                                // @ts-ignore
                                project_id: args.project_id
                            });
                        },
                        delete_files_by_pk: (_, { args, toReference }) => {
                            return toReference({
                                __typename: 'files',
                                // @ts-ignore
                                id: args.id,
                                // @ts-ignore
                                project_id: args.project_id
                            });
                        },
                    }
                }
            }
        })
    });

    // testing stuff
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

