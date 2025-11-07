# ====================================
# 数据库备份脚本
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  💾 数据库备份工具" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查容器是否运行
$running = docker ps --filter "name=supabase-db" --format "{{.Names}}"
if (-not $running) {
    Write-Host "❌ 数据库容器未运行" -ForegroundColor Red
    pause
    exit 1
}

# 创建备份目录
$backupDir = "backups"
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
    Write-Host "创建备份目录: $backupDir" -ForegroundColor Green
}

# 生成备份文件名
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "$backupDir\supabase_backup_$timestamp.sql"

Write-Host "备份信息:" -ForegroundColor Green
Write-Host "  时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
Write-Host "  文件: $backupFile" -ForegroundColor White
Write-Host ""

Write-Host "开始备份..." -ForegroundColor Yellow

# 执行备份
docker exec supabase-db pg_dump -U postgres -d postgres > $backupFile

if ($LASTEXITCODE -eq 0) {
    $fileSize = (Get-Item $backupFile).Length
    $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
    
    Write-Host ""
    Write-Host "✅ 备份成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "备份详情:" -ForegroundColor Yellow
    Write-Host "  文件: $backupFile" -ForegroundColor White
    Write-Host "  大小: $fileSizeMB MB" -ForegroundColor White
    Write-Host ""
    
    # 列出所有备份
    Write-Host "所有备份文件:" -ForegroundColor Yellow
    Get-ChildItem $backupDir -Filter "*.sql" | ForEach-Object {
        $size = [math]::Round($_.Length / 1MB, 2)
        Write-Host "  - $($_.Name) ($size MB)" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "恢复命令:" -ForegroundColor Green
    Write-Host "  .\restore.ps1" -ForegroundColor Cyan
} else {
    Write-Host "❌ 备份失败" -ForegroundColor Red
}

Write-Host ""
pause


