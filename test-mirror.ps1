# 测试 Docker 镜像加速器

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Docker 镜像加速器测试" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "测试 1: 检查 Docker 连接..." -ForegroundColor Yellow
docker info 2>&1 | Select-String -Pattern "Server Version" | Select-Object -First 1
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker 未运行，请先启动 Docker Desktop" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Docker 连接正常" -ForegroundColor Green
Write-Host ""

Write-Host "测试 2: 拉取 hello-world 镜像（测试镜像加速器）..." -ForegroundColor Yellow
docker pull hello-world
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ 镜像拉取成功！镜像加速器工作正常" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "测试 3: 拉取 Supabase PostgreSQL 镜像..." -ForegroundColor Yellow
    docker pull supabase/postgres:15.1.0.147
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Supabase PostgreSQL 镜像拉取成功！" -ForegroundColor Green
        Write-Host ""
        Write-Host "===========================================" -ForegroundColor Cyan
        Write-Host "配置成功！可以启动 Supabase 服务了" -ForegroundColor Green
        Write-Host "===========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "运行以下命令启动服务:" -ForegroundColor Yellow
        Write-Host "  docker compose up -d" -ForegroundColor Cyan
        Write-Host ""
        
        $response = Read-Host "是否现在启动 Supabase 服务? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            Write-Host ""
            Write-Host "正在启动 Supabase 服务..." -ForegroundColor Green
            docker compose up -d
        }
    } else {
        Write-Host "✗ Supabase PostgreSQL 镜像拉取失败" -ForegroundColor Red
        Write-Host "可以继续尝试其他镜像或检查网络连接" -ForegroundColor Yellow
    }
} else {
    Write-Host "✗ 镜像拉取失败" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的原因:" -ForegroundColor Yellow
    Write-Host "  1. 镜像加速器配置未生效（需要重启 Docker Desktop）" -ForegroundColor White
    Write-Host "  2. 镜像加速器服务器不可用" -ForegroundColor White
    Write-Host "  3. 网络连接问题" -ForegroundColor White
    Write-Host ""
    Write-Host "建议:" -ForegroundColor Yellow
    Write-Host "  1. 确认 Docker Desktop 已完全重启" -ForegroundColor White
    Write-Host "  2. 尝试使用其他镜像加速器地址" -ForegroundColor White
    Write-Host "  3. 检查网络连接" -ForegroundColor White
}

Write-Host ""


