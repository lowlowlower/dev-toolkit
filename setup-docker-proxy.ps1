# Docker 代理配置脚本
# 用于配置 Docker Desktop 使用本地代理

Write-Host "正在配置 Docker 代理..." -ForegroundColor Green

# 方法1: 通过环境变量设置（临时）
$env:HTTP_PROXY="http://127.0.0.1:7897"
$env:HTTPS_PROXY="http://127.0.0.1:7897"
$env:NO_PROXY="localhost,127.0.0.1"

Write-Host "已设置环境变量:" -ForegroundColor Yellow
Write-Host "  HTTP_PROXY=$env:HTTP_PROXY" -ForegroundColor Cyan
Write-Host "  HTTPS_PROXY=$env:HTTPS_PROXY" -ForegroundColor Cyan
Write-Host "  NO_PROXY=$env:NO_PROXY" -ForegroundColor Cyan
Write-Host ""

Write-Host "请在 Docker Desktop 中手动配置代理:" -ForegroundColor Yellow
Write-Host "  1. 打开 Docker Desktop" -ForegroundColor White
Write-Host "  2. 点击 Settings (设置)" -ForegroundColor White
Write-Host "  3. 找到 Resources -> Proxies" -ForegroundColor White
Write-Host "  4. 设置代理地址为: http://127.0.0.1:7897" -ForegroundColor White
Write-Host "  5. 点击 Apply & Restart" -ForegroundColor White
Write-Host ""

Write-Host "配置完成后，运行以下命令启动服务:" -ForegroundColor Green
Write-Host "  docker compose up -d" -ForegroundColor Cyan


