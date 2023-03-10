#/bin/bash

# CIL CONFIG
NOTE="sdp_cifar100_memory_free_iter3" # Short description of the experiment. (WARNING: logs/results with the same note will be overwritten!)
MODE="sdp_v16"
DATASET="cifar100" # cifar10, cifar100, tinyimagenet, imagenet
SIGMA=10
REPEAT=1
INIT_CLS=100
BETA=0.01
DMA_MEAN=10000
DMA_VAR=0.75
IMPORTANCE="none"
NORM_LOSS="batch"
FC_TRAIN="none"
LOSS_RATIO="cls_pred_based"
GPU_TRANSFORM="--gpu_transform"
USE_AMP="--use_amp"
SEEDS="1 2 3"
WEIGHT_METHOD="count_important" # to delete
WEIGHT_OPTION="loss" # to delete

if [ "$DATASET" == "cifar10" ]; then
    MEM_SIZE=50000 ONLINE_ITER=0.736427989
    MODEL_NAME="resnet32" EVAL_PERIOD=100 F_PERIOD=10000 IMP_UPDATE_PERIOD=1
    BATCHSIZE=16; LR=3e-4 OPT_NAME="adam" SCHED_NAME="pred_based"

elif [ "$DATASET" == "cifar100" ]; then
    MEM_SIZE=50000 ONLINE_ITER=2.209283968
    MODEL_NAME="resnet32" EVAL_PERIOD=100 F_PERIOD=10000 IMP_UPDATE_PERIOD=1
    BATCHSIZE=16; LR=3e-4 OPT_NAME="adam" SCHED_NAME="pred_based"

elif [ "$DATASET" == "tinyimagenet" ]; then
    MEM_SIZE=4000 ONLINE_ITER=3
    MODEL_NAME="resnet18" EVAL_PERIOD=200 F_PERIOD=20000
    BATCHSIZE=32; LR=3e-4 OPT_NAME="adam" SCHED_NAME="pred_based" IMP_UPDATE_PERIOD=1

elif [ "$DATASET" == "imagenet" ]; then
    MEM_SIZE=20000 ONLINE_ITER=0.25
    MODEL_NAME="resnet18" EVAL_PERIOD=2000 F_PERIOD=100000
    BATCHSIZE=256; LR=3e-4 OPT_NAME="adam" SCHED_NAME="pred_based" IMP_UPDATE_PERIOD=10

else
    echo "Undefined setting"
    exit 1
fi

for RND_SEED in $SEEDS
do
    CUDA_VISIBLE_DEVICES=4 nohup python main.py --mode $MODE \
    --dataset $DATASET --sigma $SIGMA --repeat $REPEAT --init_cls $INIT_CLS \
    --rnd_seed $RND_SEED --weight_method $WEIGHT_METHOD --weight_option $WEIGHT_OPTION \
    --model_name $MODEL_NAME --opt_name $OPT_NAME --sched_name $SCHED_NAME \
    --lr $LR --batchsize $BATCHSIZE \
    --memory_size $MEM_SIZE $GPU_TRANSFORM --online_iter $ONLINE_ITER --dma_mean $DMA_MEAN --dma_var $DMA_VAR \
    --note $NOTE --eval_period $EVAL_PERIOD $USE_AMP --beta $BETA --importance $IMPORTANCE --loss_ratio $LOSS_RATIO --norm_loss $NORM_LOSS --fc_train $FC_TRAIN --f_period $F_PERIOD --imp_update_period $IMP_UPDATE_PERIOD &
done

