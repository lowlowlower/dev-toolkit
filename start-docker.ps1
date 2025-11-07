# 启动 Docker 服务的命令
# 请在 Docker Desktop 中配置代理后再运行此命令

Write-Host "正在启动 Supabase Docker 服务..." -ForegroundColor Green
Write-Host ""

# 设置代理环境变量（用于容器运行时）
$env:HTTP_PROXY="http://127.0.0.1:7897"
$env:HTTPS_PROXY="http://127.0.0.1:7897"
$env:NO_PROXY="localhost,127.0.0.1"

# 启动服务
docker compose up -d

Write-Host ""
Write-Host "等待服务启动..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "检查服务状态:" -ForegroundColor Cyan
docker compose ps

Write-Host ""
Write-Host "如果服务启动成功，访问以下地址:" -ForegroundColor Green
Write-Host "  - Supabase Studio: http://localhost:54323" -ForegroundColor Cyan
Write-Host "  - API Gateway: http://localhost:54324" -ForegroundColor Cyan
Write-Host ""


