set -e  # 出错即停止，避免无效执行

# ===================== 训练流程 =====================
GPU=0
PORT_BASE=6001
GT_PATH=/home/jiangzhenghan/project/MeetingRoom

DATASET=MeetingRoom
SAVE_PATH=output

SCENE_LIST=(
    vrig_IroningClothes
)
TRAIN_ITERATIONS=30000 

for SCENE in "${SCENE_LIST[@]}"; do
    echo -e "\n\033[32m[1/3] 开始训练rgb NeRF-DS/HyperNeRF...\033[0m"
    CUDA_VISIBLE_DEVICES=$GPU python train.py \
    -s "${GT_PATH}/${SCENE}/rgb" \
    -m "${SAVE_PATH}/${DATASET}/${SCENE}_rgb_down2x" \
    --eval \
    --iterations "${TRAIN_ITERATIONS}"

    # ===================== 渲染流程 =====================
    echo -e "\n\033[32m[2/3] 训练完成，开始渲染...\033[0m"
    CUDA_VISIBLE_DEVICES=$GPU python render.py \
    -m "${SAVE_PATH}/${DATASET}/${SCENE}_rgb_down2x" \
    --mode render --skip_train

    # ===================== 评估流程 =====================
    echo -e "\n\033[32m[3/3] 渲染完成，开始评估...\033[0m"
    CUDA_VISIBLE_DEVICES=$GPU python metrics.py \
    -m "${SAVE_PATH}/${DATASET}/${SCENE}_rgb_down2x"

    echo -e "\n\033[32m[1/3] 开始训练thermal NeRF-DS/HyperNeRF...\033[0m"
    CUDA_VISIBLE_DEVICES=$GPU python train.py \
    -s "${GT_PATH}/${SCENE}/thermal" \
    -m "${SAVE_PATH}/${DATASET}/${SCENE}_thermal_down2x" \
    --eval \
    --iterations "${TRAIN_ITERATIONS}"

    # ===================== 渲染流程 =====================
    echo -e "\n\033[32m[2/3] 训练完成，开始渲染...\033[0m"
    CUDA_VISIBLE_DEVICES=$GPU python render.py \
    -m "${SAVE_PATH}/${DATASET}/${SCENE}_thermal_down2x" \
    --mode render --skip_train   
       # ===================== 评估流程 =====================
    echo -e "\n\033[32m[3/3] 渲染完成，开始评估...\033[0m"
    CUDA_VISIBLE_DEVICES=$GPU python metrics.py \
    -m "${SAVE_PATH}/${DATASET}/${SCENE}_thermal_down2x"
    


    echo -e "\n\033[32m✅ 全流程完成！结果已保存至：${SAVE_PATH}/${DATASET}/${SCENE}_rgb_down2x\033[0m"
done
