

/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetAllFiles
// ====================================================

export interface GetAllFiles_files {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface GetAllFiles {
  files: GetAllFiles_files[];  // fetch data from the table: "files"
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetFileById
// ====================================================

export interface GetFileById_files_by_pk {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface GetFileById {
  files_by_pk: GetFileById_files_by_pk | null;  // fetch data from the table: "files" using primary key columns
}

export interface GetFileByIdVariables {
  id: number;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetFilesByProjectId
// ====================================================

export interface GetFilesByProjectId_files {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface GetFilesByProjectId {
  files: GetFilesByProjectId_files[];  // fetch data from the table: "files"
}

export interface GetFilesByProjectIdVariables {
  _eq?: number | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: AddFile
// ====================================================

export interface AddFile_insert_files_one {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface AddFile {
  insert_files_one: AddFile_insert_files_one | null;  // insert a single row into the table: "files"
}

export interface AddFileVariables {
  name?: string | null;
  content?: string | null;
  project_id?: number | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: UpdateFile
// ====================================================

export interface UpdateFile_update_files_by_pk {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface UpdateFile {
  update_files_by_pk: UpdateFile_update_files_by_pk | null;  // update single row of the table: "files"
}

export interface UpdateFileVariables {
  id: number;
  content?: string | null;
  name?: string | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: RenameFile
// ====================================================

export interface RenameFile_update_files_by_pk {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface RenameFile {
  update_files_by_pk: RenameFile_update_files_by_pk | null;  // update single row of the table: "files"
}

export interface RenameFileVariables {
  id: number;
  name?: string | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: EditFile
// ====================================================

export interface EditFile_update_files_by_pk {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface EditFile {
  update_files_by_pk: EditFile_update_files_by_pk | null;  // update single row of the table: "files"
}

export interface EditFileVariables {
  id: number;
  content?: string | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteFile
// ====================================================

export interface DeleteFile_delete_files_by_pk {
  content: string;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  updated_at: any;
}

export interface DeleteFile {
  delete_files_by_pk: DeleteFile_delete_files_by_pk | null;  // delete single row from the table: "files"
}

export interface DeleteFileVariables {
  id: number;
}

/* tslint:disable */
// This file was automatically generated and should not be edited.

//==============================================================
// START Enums and Input Objects
//==============================================================

//==============================================================
// END Enums and Input Objects
//==============================================================