# Docker 代理测试脚本
# 在重启 Docker Desktop 后运行此脚本

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Docker 代理连接测试" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# 测试 1: 简单的 hello-world 镜像
Write-Host "测试 1: 拉取 hello-world 镜像..." -ForegroundColor Yellow
try {
    docker pull hello-world 2>&1 | Tee-Object -Variable output
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ hello-world 镜像拉取成功" -ForegroundColor Green
    } else {
        Write-Host "✗ hello-world 镜像拉取失败" -ForegroundColor Red
        Write-Host $output -ForegroundColor Red
    }
} catch {
    Write-Host "✗ 错误: $_" -ForegroundColor Red
}

Write-Host ""

# 如果第一个测试成功，测试 Supabase 镜像
if ($LASTEXITCODE -eq 0) {
    Write-Host "测试 2: 拉取 Supabase PostgreSQL 镜像..." -ForegroundColor Yellow
    try {
        docker pull supabase/postgres:15.1.0.147 2>&1 | Tee-Object -Variable output
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Supabase PostgreSQL 镜像拉取成功" -ForegroundColor Green
            Write-Host ""
            Write-Host "代理配置正常！可以启动完整服务了:" -ForegroundColor Green
            Write-Host "  docker compose up -d" -ForegroundColor Cyan
        } else {
            Write-Host "✗ Supabase PostgreSQL 镜像拉取失败" -ForegroundColor Red
            Write-Host $output -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ 错误: $_" -ForegroundColor Red
    }
} else {
    Write-Host "第一个测试失败，请检查:" -ForegroundColor Yellow
    Write-Host "1. Docker Desktop 是否已完全重启" -ForegroundColor White
    Write-Host "2. 代理软件是否正在运行 (端口 7897)" -ForegroundColor White
    Write-Host "3. 代理软件是否允许 Docker Desktop 通过代理" -ForegroundColor White
    Write-Host "4. 尝试重启代理软件" -ForegroundColor White
}

Write-Host ""


