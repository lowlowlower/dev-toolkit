# Docker 代理配置说明

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Docker 代理配置指南" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

$proxyUrl = "http://127.0.0.1:7897"

Write-Host "代理地址: $proxyUrl" -ForegroundColor Yellow
Write-Host ""

Write-Host "请在 Docker Desktop 中配置代理:" -ForegroundColor Yellow
Write-Host ""
Write-Host "步骤 1: 打开 Docker Desktop" -ForegroundColor Cyan
Write-Host "步骤 2: 点击右上角的 Settings (设置图标)" -ForegroundColor Cyan
Write-Host "步骤 3: 选择 Resources -> Proxies" -ForegroundColor Cyan
Write-Host "步骤 4: 启用 Manual proxy configuration" -ForegroundColor Cyan
Write-Host "步骤 5: 设置以下内容:" -ForegroundColor Cyan
Write-Host "   - Web server (HTTP): $proxyUrl" -ForegroundColor White
Write-Host "   - Secure Web server (HTTPS): $proxyUrl" -ForegroundColor White
Write-Host "   - Bypass: localhost,127.0.0.1" -ForegroundColor White
Write-Host "步骤 6: 点击 'Apply and Restart'" -ForegroundColor Cyan
Write-Host ""

Write-Host "配置完成后，运行以下命令启动服务:" -ForegroundColor Green
Write-Host "  docker compose up -d" -ForegroundColor Cyan
Write-Host ""

$response = Read-Host "是否现在尝试启动 Docker 服务? (Y/N)"
if ($response -eq "Y" -or $response -eq "y") {
    Write-Host ""
    Write-Host "正在启动 Docker 服务..." -ForegroundColor Green
    docker compose up -d
}
