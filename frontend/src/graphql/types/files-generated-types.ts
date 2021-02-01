

/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetAllFiles
// ====================================================

import {MyAnnotationData, MyTriplesData} from "./annotations";
import {MyAlignmentData} from "./alignments";

export interface GetAllFiles_files {
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
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
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
  updated_at: any;
}

export interface GetFileById {
  files_by_pk: GetFileById_files_by_pk | null;  // fetch data from the table: "files" using primary key columns
}

export interface GetFileByIdVariables {
  id: number;
  projectId: number;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetFilesByProjectId
// ====================================================

export interface GetFilesByProjectId_files {
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
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
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
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
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
  updated_at: any;
}

export interface UpdateFile {
  update_files_by_pk: UpdateFile_update_files_by_pk | null;  // update single row of the table: "files"
}

export interface UpdateFileVariables {
  id: number;
  projectId: number;
  content?: string | null;
  name?: string | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: UpdateSummary
// ====================================================

export interface UpdateSummary_update_files_by_pk {
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
  updated_at: any;
}

export interface UpdateSummary {
  update_files_by_pk: UpdateSummary_update_files_by_pk | null;  // update single row of the table: "files"
}

export interface UpdateSummaryVariables {
  id: number;
  projectId: number;
  summary_content?: string | null;
  summary_annotation_data?: any | null;
  summary_alignment_data?: any | null;
  summary_triple_data?: any | null;
  summary_sentences?: any | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: RenameFile
// ====================================================

export interface RenameFile_update_files_by_pk {
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
  updated_at: any;
}

export interface RenameFile {
  update_files_by_pk: RenameFile_update_files_by_pk | null;  // update single row of the table: "files"
}

export interface RenameFileVariables {
  id: number;
  projectId: number;
  name?: string | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: EditFile
// ====================================================

export interface EditFile_update_files_by_pk {
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
  updated_at: any;
}

export interface EditFile {
  update_files_by_pk: EditFile_update_files_by_pk | null;  // update single row of the table: "files"
}

export interface EditFileVariables {
  id: number;
  projectId: number;
  content?: string | null;
  sentences?: any | null;
  annotationData?: any | null;
  tripleData?: any | null;
}


/* tslint:disable */
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteFile
// ====================================================

export interface DeleteFile_delete_files_by_pk {
  annotation_data: any | null;
  annotation_up_to_date: boolean;
  content: string;
  sentences: string[] | null;
  created_at: any;
  graph_data: any;
  graph_up_to_date: boolean;
  id: number;
  name: string;
  project_id: number;
  summary_content: string | null;
  summary_up_to_date: boolean;
  summary_annotation_data: MyAnnotationData | null;
  summary_alignment_data: MyAlignmentData | null;
  summary_triple_data: MyTriplesData | null;
  summary_sentences: string[] | null;
  triple_data: MyTriplesData | null;
  updated_at: any;
}

export interface DeleteFile {
  delete_files_by_pk: DeleteFile_delete_files_by_pk | null;  // delete single row from the table: "files"
}

export interface DeleteFileVariables {
  id: number;
  projectId: number;
}

/* tslint:disable */
// This file was automatically generated and should not be edited.

//==============================================================
// START Enums and Input Objects
//==============================================================

//==============================================================
// END Enums and Input Objects
//==============================================================