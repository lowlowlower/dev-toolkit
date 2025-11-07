@echo off
chcp 65001 >nul
echo ============================================
echo          微信多开工具
echo ============================================
echo.

REM 默认微信安装路径
set "WECHAT_PATH=C:\Program Files\Tencent\Weixin\Weixin.exe"

REM 检查路径是否存在
if not exist "%WECHAT_PATH%" (
    set "WECHAT_PATH=C:\Program Files (x86)\Tencent\WeChat\WeChat.exe"
)

if not exist "%WECHAT_PATH%" (
    echo [错误] 未找到微信安装路径！
    echo.
    echo 请手动编辑此脚本，修改 WECHAT_PATH 为你的微信路径
    echo 例如: set "WECHAT_PATH=D:\WeChat\WeChat.exe"
    echo.
    pause
    exit
)

echo 微信路径: %WECHAT_PATH%
echo.
echo 请选择操作:
echo [1] 双开微信（打开2个）
echo [2] 三开微信（打开3个）
echo [3] 自定义数量
echo [4] 退出
echo.
set /p choice=请输入选项 (1-4): 

if "%choice%"=="1" (
    set COUNT=2
    goto :START_WECHAT
)
if "%choice%"=="2" (
    set COUNT=3
    goto :START_WECHAT
)
if "%choice%"=="3" (
    set /p COUNT=请输入要打开的微信数量: 
    goto :START_WECHAT
)
if "%choice%"=="4" (
    exit
)

echo [错误] 无效选项
pause
exit

:START_WECHAT
echo.
echo 正在启动 %COUNT% 个微信...
echo.

for /L %%i in (1,1,%COUNT%) do (
    start "" "%WECHAT_PATH%"
    echo [✓] 第 %%i 个微信已启动
    timeout /t 1 /nobreak >nul
)

echo.
echo ============================================
echo 启动完成！
echo ============================================
echo.
echo 提示:
echo - 每个窗口需要单独扫码登录
echo - 可以同时登录不同账号
echo - 关闭此窗口不影响微信运行
echo.
pause

