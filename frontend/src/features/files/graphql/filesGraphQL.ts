import {gql, useMutation, useQuery} from "@apollo/client";
import * as Types from "../types/files-generated-types";

const GET_ALL_FILES_QUERY = gql`
  query GetAllFiles {
    files(order_by: {name: asc}) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;

const GET_FILE_BY_ID_QUERY = gql`
  query GetFileById($id: Int!) {
    files_by_pk(id: $id) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;

const GET_FILES_BY_PROJECT_ID_QUERY = gql`
  query GetFilesByProjectId($_eq: Int) {
    files(where: {project_id: {_eq: $_eq}}) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;

const ADD_FILE_MUTATION = gql`
  mutation AddFile($name: String, $content: String, $project_id: Int) {
    insert_files_one(object: {content: $content, name: $name, project_id: $project_id}) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;

const UPDATE_FILE_MUTATION = gql`
  mutation UpdateFile($id: Int!, $content: String, $name: String) {
    update_files_by_pk(pk_columns: {id: $id}, _set: {content: $content, name: $name}) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;

const RENAME_FILE_MUTATION = gql`
  mutation RenameFile($id: Int!, $name: String) {
    update_files_by_pk(pk_columns: {id: $id}, _set: {name: $name}) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;

const EDIT_FILE_MUTATION = gql`
  mutation EditFile($id: Int!, $content: String) {
    update_files_by_pk(pk_columns: {id: $id}, _set: {content: $content}) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;


const DELETE_FILE_MUTATION = gql`
  mutation DeleteFile($id: Int!) {
    delete_files_by_pk(id: $id) {
      content
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      updated_at
    }
  }
`;

export function useGetFileById(id: number, onCompleted: ((data: Types.GetFileById) => void) | undefined = undefined) {
    const { loading, error, data } = useQuery<Types.GetFileById, Types.GetFileByIdVariables>(
        GET_FILE_BY_ID_QUERY, {
            variables: {
                id
            },
            onCompleted
        });
    return {loading, error, data};
}

export function useGetFilesByProjectId({ _eq }: Types.GetFilesByProjectIdVariables) {
    const { loading, error, data } = useQuery<Types.GetFilesByProjectId, Types.GetFilesByProjectIdVariables>(
        GET_FILES_BY_PROJECT_ID_QUERY, {
            variables: {
                _eq: _eq
            }
        });
    return {loading, error, data};
}

export function useGetAllFiles() {
    const {loading, error, data} = useQuery<Types.GetAllFiles>(GET_ALL_FILES_QUERY);
    return {loading, error, data};
}


export function useAddFile(projectId: number) {
    const [mutate, { data, error, loading }] = useMutation<Types.AddFile, Types.AddFileVariables>(
        ADD_FILE_MUTATION, {
            refetchQueries: [
                {query: GET_ALL_FILES_QUERY},
                {
                    query: GET_FILES_BY_PROJECT_ID_QUERY,
                    variables: {
                        _eq: projectId
                    }
                }
            ]
        });
    return { mutate, data, error, loading };
}

export function useDeleteFile(projectId: number) {
    const [mutate, { data, error, loading }] = useMutation<Types.DeleteFile, Types.DeleteFileVariables>(
        DELETE_FILE_MUTATION, {
            refetchQueries: [
                {query: GET_ALL_FILES_QUERY},
                {
                    query: GET_FILES_BY_PROJECT_ID_QUERY,
                    variables: {
                        _eq: projectId
                    }
                }
            ]
        });
    return { mutate, data, error, loading };
}

export function useUpdateFileById() {
    const [mutate, { data, error, loading }] = useMutation<Types.UpdateFile, Types.UpdateFileVariables>(UPDATE_FILE_MUTATION)
    return { mutate, data, error, loading };
}

export function useRenameFileById() {
    const [mutate, { data, error, loading }] = useMutation<Types.RenameFile, Types.RenameFileVariables>(RENAME_FILE_MUTATION)
    return { mutate, data, error, loading };
}

export function useEditFileById() {
    const [mutate, { data, error, loading }] = useMutation<Types.EditFile, Types.EditFileVariables>(EDIT_FILE_MUTATION)
    return { mutate, data, error, loading };
}