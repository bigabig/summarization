sed -i 's/summary_annotation_data: any/summary_annotation_data: MyAnnotationData/g' ../src/graphql/types/files-generated-types.ts
sed -i 's/summary_alignment_data: any/summary_alignment_data: MyAlignmentData/g' ../src/graphql/types/files-generated-types.ts
sed -i 's/summary_triple_data: any/summary_triple_data: MyTriplesData/g' ../src/graphql/types/files-generated-types.ts
sed -i 's/triple_data: any/triple_data: MyTriplesData/g' ../src/graphql/types/files-generated-types.ts
sed -i 's/summary_sentences: any/summary_sentences: string[]/g' ../src/graphql/types/files-generated-types.ts
sed -i 's/document: any/document: MyDocument/g' ../src/graphql/types/files-generated-types.ts