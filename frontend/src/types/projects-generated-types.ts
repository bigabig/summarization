

/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetAllProjectsQuery
// ====================================================

export interface GetAllProjectsQuery_projects {
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  document: any | null;
  summary_document: any | null;
  documents_up_to_date: boolean | null;
  created_at: any;
  updated_at: any;
}

export interface GetAllProjectsQuery {
  projects: GetAllProjectsQuery_projects[];  // fetch data from the table: "projects"
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetProjectById
// ====================================================

export interface GetProjectById_projects_by_pk {
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  document: any | null;
  summary_document: any | null;
  documents_up_to_date: boolean | null;
  created_at: any;
  updated_at: any;
}

export interface GetProjectById {
  projects_by_pk: GetProjectById_projects_by_pk | null;  // fetch data from the table: "projects" using primary key columns
}

export interface GetProjectByIdVariables {
  id: number;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: AddProject
// ====================================================

export interface AddProject_insert_projects_one {
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  document: any | null;
  summary_document: any | null;
  documents_up_to_date: boolean | null;
  created_at: any;
  updated_at: any;
}

export interface AddProject {
  insert_projects_one: AddProject_insert_projects_one | null;  // insert a single row into the table: "projects"
}

export interface AddProjectVariables {
  name: string;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteProject
// ====================================================

export interface DeleteProject_delete_projects_by_pk {
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  document: any | null;
  summary_document: any | null;
  documents_up_to_date: boolean | null;
  created_at: any;
  updated_at: any;
}

export interface DeleteProject {
  delete_projects_by_pk: DeleteProject_delete_projects_by_pk | null;  // delete single row from the table: "projects"
}

export interface DeleteProjectVariables {
  id: number;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: RenameProject
// ====================================================

export interface RenameProject_update_projects_by_pk {
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  document: any | null;
  summary_document: any | null;
  documents_up_to_date: boolean | null;
  created_at: any;
  updated_at: any;
}

export interface RenameProject {
  update_projects_by_pk: RenameProject_update_projects_by_pk | null;  // update single row of the table: "projects"
}

export interface RenameProjectVariables {
  id: number;
  name?: string | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: UpdateProject
// ====================================================

export interface UpdateProject_update_projects_by_pk {
  created_at: any;
  document: any | null;
  documents_up_to_date: boolean | null;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  summary_document: any | null;
  updated_at: any;
}

export interface UpdateProject {
  update_projects_by_pk: UpdateProject_update_projects_by_pk | null;  // update single row of the table: "projects"
}

export interface UpdateProjectVariables {
  id: number;
  document?: any | null;
  summary_document?: any | null;
}

/* tslint:disable */
// This file was automatically generated and should not be edited.

//==============================================================
// START Enums and Input Objects
//==============================================================

//==============================================================
// END Enums and Input Objects
//==============================================================