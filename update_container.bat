@echo off
setlocal

REM 检查容器是否已运行
for /f "tokens=*" %%i in ('docker ps -q -f name^=avatar-test') do (
    set CONTAINER_ID=%%i
)

@REM docker run -d --rm -p 7860:7860 -p 8080:8080 --name avatar-test byteheng/ai-biz-avatar
REM 如果容器未运行，启动新容器
if "%CONTAINER_ID%"=="" (
    echo 启动新容器...
    for /f "tokens=*" %%j in ('docker run -d --rm -p 8080:8080 --name avatar-test byteheng/ai-biz-avatar python3 deploy_api.py') do (
        set CONTAINER_ID=%%j
    )
)

REM 复制修改后的文件到容器
echo 更新文件...
docker cp deploy_api.py %CONTAINER_ID%:/app/deploy_api.py
docker cp hivision/utils.py %CONTAINER_ID%:/app/hivision/utils.py

REM 重启容器
echo 重启容器...
docker restart %CONTAINER_ID%

echo 更新完成，容器已重启
echo 容器ID: %CONTAINER_ID%

REM 显示日志
echo 显示容器日志（按 Ctrl+C 退出）...
docker logs -f %CONTAINER_ID%

endlocal 