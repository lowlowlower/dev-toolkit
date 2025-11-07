# ====================================
# Docker Supabase 状态检查
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  📊 Supabase 服务状态" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker 是否运行
Write-Host "Docker 状态:" -ForegroundColor Green
try {
    docker info | Out-Null
    Write-Host "  ✓ Docker 正在运行" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Docker 未运行" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "容器状态:" -ForegroundColor Green
Write-Host ""

$containers = @(
    @{Name="supabase-db"; Display="数据库 (PostgreSQL)"; Port="54322"},
    @{Name="supabase-kong"; Display="API网关 (Kong)"; Port="54324"},
    @{Name="supabase-studio"; Display="管理界面 (Studio)"; Port="54323"},
    @{Name="supabase-auth"; Display="认证服务 (Auth)"; Port="54325"},
    @{Name="supabase-rest"; Display="REST API"; Port="54326"},
    @{Name="supabase-storage"; Display="存储服务 (Storage)"; Port="54327"}
)

foreach ($container in $containers) {
    $status = docker ps --filter "name=$($container.Name)" --format "{{.Status}}"
    
    if ($status) {
        Write-Host "  ✓" -ForegroundColor Green -NoNewline
        Write-Host " $($container.Display)" -ForegroundColor White
        Write-Host "    端口: $($container.Port) | 状态: $status" -ForegroundColor Gray
    } else {
        Write-Host "  ✗" -ForegroundColor Red -NoNewline
        Write-Host " $($container.Display)" -ForegroundColor White
        Write-Host "    状态: 未运行" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "数据卷:" -ForegroundColor Green
$volumes = docker volume ls --filter "name=business-builder" --format "{{.Name}}"
if ($volumes) {
    $volumes -split "`n" | ForEach-Object { 
        Write-Host "  ✓ $_" -ForegroundColor White 
    }
} else {
    Write-Host "  ✗ 未找到数据卷" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "访问地址:" -ForegroundColor Green
Write-Host "  - 管理界面: http://localhost:54323" -ForegroundColor Cyan
Write-Host "  - API网关: http://localhost:54324" -ForegroundColor Cyan
Write-Host "  - 数据库: localhost:54322" -ForegroundColor Cyan

Write-Host ""
Write-Host "快捷命令:" -ForegroundColor Yellow
Write-Host "  启动服务: .\docker\start.ps1" -ForegroundColor White
Write-Host "  停止服务: .\docker\stop.ps1" -ForegroundColor White
Write-Host "  查看日志: .\docker\logs.ps1" -ForegroundColor White
Write-Host "  初始化数据库: .\docker\init-db.ps1" -ForegroundColor White
Write-Host ""

pause


