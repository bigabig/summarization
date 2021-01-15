import {gql, useMutation, useQuery} from "@apollo/client";
import * as Types from '../types/projects-generated-types';
import * as ProjectTypes from "../types/projects-generated-types";

const GET_ALL_PROJECTS_QUERY = gql`
  query GetAllProjectsQuery {
    projects(order_by: {name: asc}) {
      graph_data
      graph_up_to_date
      id
      name
      summary_content
      summary_up_to_date
      created_at
      updated_at
    }
  }
`;

const GET_PROJECT_BY_ID_QUERY = gql`
  query GetProjectById($id: Int!) {
    projects_by_pk(id: $id) {
      graph_data
      graph_up_to_date
      id
      name
      summary_content
      summary_up_to_date
      created_at
      updated_at
    }
  }
`;

const ADD_PROJECT_MUTATION = gql`
  mutation AddProject($name: String!) {
    insert_projects_one(object: {name: $name}) {
      graph_data
      graph_up_to_date
      id
      name
      summary_content
      summary_up_to_date
      created_at
      updated_at
    }
  }
`;

const DELETE_PROJECT_MUTATION = gql`
  mutation DeleteProject($id: Int!) {
    delete_projects_by_pk(id: $id) {
      graph_data
      graph_up_to_date
      id
      name
      summary_content
      summary_up_to_date
      created_at
      updated_at
    }
  }
`;

const RENAME_PROJECT_MUTATION = gql`
  mutation RenameProject($id: Int!, $name: String) {
    update_projects_by_pk(pk_columns: {id: $id}, _set: {name: $name}) {
      graph_data
      graph_up_to_date
      id
      name
      summary_content
      summary_up_to_date
      created_at
      updated_at
    }
  }
`;

export function useGetProjectById({ id }: ProjectTypes.GetProjectByIdVariables) {
    const { loading, error, data } = useQuery<ProjectTypes.GetProjectById, ProjectTypes.GetProjectByIdVariables>(
        GET_PROJECT_BY_ID_QUERY, {
            variables: {
                id
            }
        });
    return {loading, error, data};
}

export function useGetAllProjects() {
    const {loading, error, data} = useQuery<ProjectTypes.GetAllProjectsQuery>(GET_ALL_PROJECTS_QUERY);
    return {loading, error, data};
}


export function useAddProject() {
    const [mutate, { data, error, loading }] = useMutation<Types.AddProject, Types.AddProjectVariables>(
        ADD_PROJECT_MUTATION, {
            refetchQueries: [
                {query: GET_ALL_PROJECTS_QUERY}
            ]
        });
    return { mutate, data, error, loading };
}

export function useDeleteProject() {
    const [mutate, { data, error, loading }] = useMutation<Types.DeleteProject, Types.DeleteProjectVariables>(
        DELETE_PROJECT_MUTATION, {
            refetchQueries: [
                {query: GET_ALL_PROJECTS_QUERY}
            ]
        });
    return { mutate, data, error, loading };
}

export function useRenameProjectById() {
    const [mutate, { data, error, loading }] = useMutation<Types.RenameProject, Types.RenameProjectVariables>(RENAME_PROJECT_MUTATION)
    return { mutate, data, error, loading };
}