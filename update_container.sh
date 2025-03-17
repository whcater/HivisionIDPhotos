#!/bin/bash

# 启动容器（如果尚未运行）
CONTAINER_ID=$(docker ps -q -f name=avatar-test)
if [ -z "$CONTAINER_ID" ]; then
  echo "启动新容器..."
  CONTAINER_ID=$(docker run -d -p 7860:7860 -p 8080:8080 --name avatar-test byteheng/ai-biz-avatar)
fi

# 复制修改后的文件到容器
echo "更新文件..."
docker cp deploy_api.py $CONTAINER_ID:/app/deploy_api.py
docker cp hivision/utils.py $CONTAINER_ID:/app/hivision/utils.py

# 重启容器
echo "重启容器..."
docker restart $CONTAINER_ID

echo "更新完成，容器已重启" 