#! /bin/bash
# Evaluate FactCCX model

# UPDATE PATHS BEFORE RUNNING SCRIPT
export CODE_PATH=/home/tim/Development/factCC/modeling/ # absolute path to modeling directory
export DATA_PATH=/home/tim/Development/summarization/data/annotated_data/test/ # absolute path to data directory
export CKPT_PATH=/home/tim/Development/factCC/factccx-checkpoint/ # absolute path to model checkpoint

export TASK_NAME=factcc_annotated
export MODEL_NAME=bert-base-uncased

python3 $CODE_PATH/app.py \
    --task_name $TASK_NAME \
    --do_eval \
    --do_lower_case \
    --max_seq_length 512 \
    --per_gpu_train_batch_size 1 \
    --model_type pbert \
    --model_name_or_path $MODEL_NAME \
    --data_dir $DATA_PATH \
    --output_dir $CKPT_PATH

