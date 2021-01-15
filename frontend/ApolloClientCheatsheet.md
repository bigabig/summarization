# Apollo Client v3 Cheatsheet
(created with information from https://www.apollographql.com/docs/)

## Queries

### Define Query
```
const GET_DOG_PHOTO = gql`
  query Dog($breed: String!) {
    dog(breed: $breed) {
      id
      displayImage
    }
  }
`;
```

### Execute Query
Whenever Apollo Client fetches query results it automatically caches those results locally making subsequent executions of the same query extremely fast.
```
const { loading, error, data } = useQuery(GET_DOG_PHOTO, { 
    variables: { breed },
    onCompleted,
    onError    
 });
```

### Execute Query Manually
```
const [getDog, { loading, data }] = useLazyQuery(GET_DOG_PHOTO);
...
<button onClick={() => getDog({ variables: { breed: 'bulldog' } })}>Click me!</button>
```

### Updating Cached Query Results

#### Polling (execute query periodically)
```
const { loading, error, data } = useQuery(GET_DOG_PHOTO, {
variables: { breed },
pollInterval: 500,
});
```

#### Refetching (refresh query results on demand)
```
const { loading, error, data, refetch } = useQuery(GET_DOG_PHOTO, { variables: { breed } });
...
button onClick={() => refetch()}>Refetch!</button>
```

### Loading States & Network Status
```
const { loading, error, data, refetch, networkStatus } = useQuery(GET_DOG_PHOTO, {
      variables: { breed },
      notifyOnNetworkStatusChange: true,
    });

if (networkStatus === NetworkStatus.refetch) return 'Refetching!';
```


## Mutations

### Define Mutation
```
const ADD_TODO = gql`
  mutation AddTodo($type: String!) {
    addTodo(type: $type) {
      id
      type
    }
  }
`;
```

### Apply Mutation
```
const [addTodo, { data, loading, error, called }] = useMutation(ADD_TODO, {
    variables: { [key: string]: any },
    update: (cache: DataProxy, mutationResult: FetchResult),
    ignoreResults: boolean,
    refetchQueries,
    awaitRefetchQueries,
    onCompleted,
    onError,
});
addTodo({ variables: { type: stringValue } });
```

### Update Cache After Mutation

#### Single Entity
The mutation must return the id of the modified entity, along with the values of the fields that were modified.
```
const UPDATE_TODO = gql`
  mutation UpdateTodo($id: String!, $type: String!) {
    updateTodo(id: $id, type: $type) {
      id
      type
    }
  }
`;
...
const { loading, error, data } = useQuery(GET_TODOS);
const [updateTodo] = useMutation(UPDATE_TODO);
```
Executing the UPDATE_TODO mutation returns both the id of the modified to-do item and the item's new type.
Therefore, Apollo client automatically knows how to update the corresponding entity in its cache.

#### Multiple Entities
If a mutation modifies multiple entities, creates or deletes entities, the Apollo Client cache is not automatically updated!
useMutation can include an update function that modifies cached data to match the modified back-end data.
Any changes to cached data inside of an update function are automatically broadcast to queries that are listening for changes to that data (e.g. GET_TODOS).
```
const GET_TODOS = gql`
  query GetTodos {
    todos {
      id
    }
  }
`;

const [addTodo] = useMutation(ADD_TODO, {
update(cache, { data: { addTodo } }) {
  cache.modify({
    fields: {
      todos(existingTodos = []) {
        const newTodoRef = cache.writeFragment({
          data: addTodo,
          fragment: gql`
            fragment NewTodo on Todo {
              id
              type
            }
          `
        });
        return [...existingTodos, newTodoRef];
      }
    }
  });
}
});
```
The cache object represents the Apollo Client cache and provides access to API methods like readQuery, writeQuery, readFragment, writeFragment and modify.
The data property contains the result of the mutation.