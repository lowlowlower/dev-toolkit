# ====================================
# 数据库初始化脚本
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  📊 初始化 Supabase 数据库" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查容器是否运行
Write-Host "检查数据库容器..." -ForegroundColor Green
$running = docker ps --filter "name=supabase-db" --format "{{.Names}}"

if (-not $running) {
    Write-Host "❌ 数据库容器未运行" -ForegroundColor Red
    Write-Host "请先运行: .\docker\start.ps1" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "✅ 数据库容器正在运行" -ForegroundColor Green
Write-Host ""

# 检查初始化脚本是否存在
$sqlFile = "supabase\init.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "❌ 找不到初始化脚本: $sqlFile" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "找到初始化脚本: $sqlFile" -ForegroundColor Green
Write-Host ""

# 询问是否继续
Write-Host "⚠️  警告: 此操作将创建/重置数据库表和数据" -ForegroundColor Yellow
$choice = Read-Host "是否继续？(y/n)"

if ($choice -ne "y" -and $choice -ne "Y") {
    Write-Host "操作已取消" -ForegroundColor Yellow
    pause
    exit 0
}

Write-Host ""
Write-Host "执行数据库初始化..." -ForegroundColor Green
Write-Host "这可能需要几秒钟..." -ForegroundColor Yellow
Write-Host ""

# 执行 SQL 脚本
try {
    Get-Content $sqlFile | docker exec -i supabase-db psql -U postgres -d postgres
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "  ✅ 数据库初始化成功！" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "已创建的表:" -ForegroundColor Yellow
        Write-Host "  ✓ business_cards (事业卡片)" -ForegroundColor White
        Write-Host "  ✓ card_combinations (卡片组合)" -ForegroundColor White
        Write-Host "  ✓ workflow_templates (工作流模板)" -ForegroundColor White
        Write-Host "  ✓ user_progress (用户进度)" -ForegroundColor White
        Write-Host ""
        Write-Host "初始数据:" -ForegroundColor Yellow
        Write-Host "  ✓ 20张事业卡片" -ForegroundColor White
        Write-Host "  ✓ 5个工作流模板" -ForegroundColor White
        Write-Host ""
        Write-Host "可以开始使用了！" -ForegroundColor Green
        Write-Host ""
        Write-Host "下一步:" -ForegroundColor Yellow
        Write-Host "  1. 启动前端: npm run dev" -ForegroundColor White
        Write-Host "  2. 访问管理界面: http://localhost:54323" -ForegroundColor White
        Write-Host "  3. 查看数据: .\docker\query.ps1" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "❌ 初始化失败" -ForegroundColor Red
        Write-Host "请查看上面的错误信息" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ 执行失败: $_" -ForegroundColor Red
}

pause

