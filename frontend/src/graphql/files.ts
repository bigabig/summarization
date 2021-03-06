import {gql, useMutation, useQuery} from "@apollo/client";
import * as Types from "../types/files-generated-types";

const GET_ALL_FILES_QUERY = gql`
  query GetAllFiles($_eq: Int!) {
    files(where: {project_id: {_eq: $_eq}}) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;

const GET_FILE_BY_ID_QUERY = gql`
  query GetFileById($id: Int!, $projectId: Int!) {
    files_by_pk(id: $id, project_id: $projectId) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;

const GET_FILES_BY_PROJECT_ID_QUERY = gql`
  query GetFilesByProjectId($_eq: Int) {
    files(where: {project_id: {_eq: $_eq}}) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;

const ADD_FILE_MUTATION = gql`
  mutation AddFile($name: String, $content: String, $project_id: Int) {
    insert_files_one(object: {content: $content, name: $name, project_id: $project_id}) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;

const UPDATE_SUMMARY_MUTATION = gql`
  mutation UpdateSummary($id: Int!, $projectId: Int!, $summaryDocument: json, $document: json) {
    update_files_by_pk(pk_columns: {id: $id, project_id: $projectId}, _set: {summary_document: $summaryDocument, document: $document, documents_up_to_date: true}) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;

const RENAME_FILE_MUTATION = gql`
  mutation RenameFile($id: Int!, $projectId: Int!, $name: String) {
    update_files_by_pk(pk_columns: {id: $id, project_id: $projectId}, _set: {name: $name}) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;

const EDIT_FILE_MUTATION = gql`
  mutation EditFile($id: Int!, $projectId: Int!, $content: String) {
    update_files_by_pk(pk_columns: {id: $id, project_id: $projectId}, _set: {content: $content, documents_up_to_date: false}) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;


const DELETE_FILE_MUTATION = gql`
  mutation DeleteFile($id: Int!, $projectId: Int!) {
    delete_files_by_pk(id: $id, project_id: $projectId) {
      id
      project_id
      name
      content
      graph_data
      graph_up_to_date
      document
      summary_document
      documents_up_to_date
      updated_at
      created_at
    }
  }
`;

export function useGetFileById(id: number, projectId: number, onCompleted: ((data: Types.GetFileById) => void) | undefined = undefined) {
    const { loading, error, data } = useQuery<Types.GetFileById, Types.GetFileByIdVariables>(
        GET_FILE_BY_ID_QUERY, {
            variables: {
                id,
                projectId
            },
            onCompleted
        });
    return {loading, error, data};
}

export function useGetFileByIdNew({ id, projectId }: Types.GetFileByIdVariables) {
    const { loading, error, data } = useQuery<Types.GetFileById, Types.GetFileByIdVariables>(
        GET_FILE_BY_ID_QUERY, {
            variables: {
                id,
                projectId
            }
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

export function useGetAllFiles({ _eq }: Types.GetAllFilesVariables) {
    const {loading, error, data} = useQuery<Types.GetAllFiles, Types.GetAllFilesVariables>(
        GET_ALL_FILES_QUERY, {
            variables: {
                _eq: _eq
            }
        });
    return {loading, error, data};
}


export function useAddFile(projectId: number) {
    const [mutate, { data, error, loading }] = useMutation<Types.AddFile, Types.AddFileVariables>(
        ADD_FILE_MUTATION, {
            refetchQueries: [
                // {query: GET_ALL_FILES_QUERY},
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
                // {query: GET_ALL_FILES_QUERY},
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

export function useRenameFileById() {
    const [mutate, { data, error, loading }] = useMutation<Types.RenameFile, Types.RenameFileVariables>(RENAME_FILE_MUTATION)
    return { mutate, data, error, loading };
}

export function useEditFileById() {
    const [mutate, { data, error, loading }] = useMutation<Types.EditFile, Types.EditFileVariables>(EDIT_FILE_MUTATION)
    return { mutate, data, error, loading };
}

export function useUpdateSummaryById() {
    const [mutate, { data, error, loading }] = useMutation<Types.UpdateSummary, Types.UpdateSummaryVariables>(UPDATE_SUMMARY_MUTATION)
    return { mutate, data, error, loading };
}