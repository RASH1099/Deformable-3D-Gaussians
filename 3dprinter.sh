#!/bin/bash
set -e  # 出错即停止，避免无效执行

# ===================== 核心配置（根据你的实际路径修改） =====================
DATASET_PATH="data/HyperNeRF/vrig-3dprinter"  # 真实世界数据集路径
OUTPUT_PATH="output/vrig-3dprinter"                   # 训练结果输出路径
TRAIN_ITERATIONS=20000                            # 训练迭代次数

# ===================== 训练流程 =====================
echo -e "\n\033[32m[1/3] 开始训练 NeRF-DS/HyperNeRF...\033[0m"
python train.py \
  -s "${DATASET_PATH}" \
  -m "${OUTPUT_PATH}" \
  --eval \
  --iterations "${TRAIN_ITERATIONS}"

# ===================== 渲染流程 =====================
echo -e "\n\033[32m[2/3] 训练完成，开始渲染...\033[0m"
python render.py \
  -m "${OUTPUT_PATH}" \
  --mode render

# ===================== 评估流程 =====================
echo -e "\n\033[32m[3/3] 渲染完成，开始评估...\033[0m"
python metrics.py \
  -m "${OUTPUT_PATH}"

echo -e "\n\033[32m✅ 全流程完成！结果已保存至：${OUTPUT_PATH}\033[0m"