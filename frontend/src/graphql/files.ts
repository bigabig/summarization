import {gql, useMutation, useQuery} from "@apollo/client";
import * as Types from "./types/files-generated-types";

// const GET_ALL_FILES_QUERY = gql`
//   query GetAllFiles {
//     files(order_by: {name: asc}) {
//       annotation_data
//       annotation_up_to_date
//       content
//       sentences
//       created_at
//       graph_data
//       graph_up_to_date
//       id
//       name
//       project_id
//       summary_content
//       summary_up_to_date
//       summary_annotation_data
//       summary_alignment_data
//       summary_triple_data
//       summary_sentences
//       triple_data
//       updated_at
//     }
//   }
// `;

const GET_FILE_BY_ID_QUERY = gql`
  query GetFileById($id: Int!, $projectId: Int!) {
    files_by_pk(id: $id, project_id: $projectId) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
    }
  }
`;

const GET_FILES_BY_PROJECT_ID_QUERY = gql`
  query GetFilesByProjectId($_eq: Int) {
    files(where: {project_id: {_eq: $_eq}}) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
    }
  }
`;

const ADD_FILE_MUTATION = gql`
  mutation AddFile($name: String, $content: String, $project_id: Int) {
    insert_files_one(object: {content: $content, name: $name, project_id: $project_id}) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
    }
  }
`;

const UPDATE_FILE_MUTATION = gql`
  mutation UpdateFile($id: Int!, $projectId: Int!, $content: String, $name: String) {
    update_files_by_pk(pk_columns: {id: $id, project_id: $projectId}, _set: {content: $content, name: $name, summary_up_to_date: false}) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
    }
  }
`;

const UPDATE_SUMMARY_MUTATION = gql`
  mutation UpdateSummary($id: Int!, $projectId: Int! $summary_content: String, $summary_annotation_data: json, $summary_alignment_data: json, $summary_triple_data: json, $summary_sentences: json) {
    update_files_by_pk(pk_columns: {id: $id, project_id: $projectId}, _set: {summary_content: $summary_content, summary_up_to_date: true, summary_annotation_data: $summary_annotation_data, summary_alignment_data: $summary_alignment_data, summary_triple_data: $summary_triple_data, summary_sentences: $summary_sentences}) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
    }
  }
`;

const RENAME_FILE_MUTATION = gql`
  mutation RenameFile($id: Int!, $projectId: Int!, $name: String) {
    update_files_by_pk(pk_columns: {id: $id, project_id: $projectId}, _set: {name: $name}) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
    }
  }
`;

const EDIT_FILE_MUTATION = gql`
  mutation EditFile($id: Int!, $projectId: Int!, $content: String, $sentences: json, $annotationData: json, $tripleData: json) {
    update_files_by_pk(pk_columns: {id: $id, project_id: $projectId}, _set: {content: $content, sentences: $sentences, summary_up_to_date: false, annotation_data: $annotationData, annotation_up_to_date: true, triple_data: $tripleData}) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
    }
  }
`;


const DELETE_FILE_MUTATION = gql`
  mutation DeleteFile($id: Int!, $projectId: Int!) {
    delete_files_by_pk(id: $id, project_id: $projectId) {
      annotation_data
      annotation_up_to_date
      content
      sentences
      created_at
      graph_data
      graph_up_to_date
      id
      name
      project_id
      summary_content
      summary_up_to_date
      summary_annotation_data
      summary_alignment_data
      summary_triple_data
      summary_sentences
      triple_data
      updated_at
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

// export function useGetAllFiles() {
//     const {loading, error, data} = useQuery<Types.GetAllFiles>(GET_ALL_FILES_QUERY);
//     return {loading, error, data};
// }


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

export function useUpdateSummaryById() {
    const [mutate, { data, error, loading }] = useMutation<Types.UpdateSummary, Types.UpdateSummaryVariables>(UPDATE_SUMMARY_MUTATION)
    return { mutate, data, error, loading };
}