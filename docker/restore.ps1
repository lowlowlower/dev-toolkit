# ====================================
# 数据库恢复脚本
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🔄 数据库恢复工具" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查容器是否运行
$running = docker ps --filter "name=supabase-db" --format "{{.Names}}"
if (-not $running) {
    Write-Host "❌ 数据库容器未运行" -ForegroundColor Red
    Write-Host "请先运行: .\start.ps1" -ForegroundColor Yellow
    pause
    exit 1
}

# 检查备份目录
$backupDir = "backups"
if (-not (Test-Path $backupDir)) {
    Write-Host "❌ 未找到备份目录" -ForegroundColor Red
    Write-Host "请先运行: .\backup.ps1 创建备份" -ForegroundColor Yellow
    pause
    exit 1
}

# 列出所有备份文件
$backups = Get-ChildItem $backupDir -Filter "*.sql" | Sort-Object LastWriteTime -Descending

if ($backups.Count -eq 0) {
    Write-Host "❌ 未找到备份文件" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "可用的备份文件:" -ForegroundColor Green
Write-Host ""

for ($i = 0; $i -lt $backups.Count; $i++) {
    $backup = $backups[$i]
    $size = [math]::Round($backup.Length / 1MB, 2)
    $date = $backup.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
    Write-Host "  [$($i+1)] $($backup.Name)" -ForegroundColor White
    Write-Host "      大小: $size MB | 时间: $date" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "请选择要恢复的备份 (1-$($backups.Count)):" -ForegroundColor Yellow
$choice = Read-Host

if ($choice -lt 1 -or $choice -gt $backups.Count) {
    Write-Host "❌ 无效选择" -ForegroundColor Red
    pause
    exit 1
}

$selectedBackup = $backups[$choice - 1]
$backupFile = $selectedBackup.FullName

Write-Host ""
Write-Host "⚠️  警告: 恢复操作将替换当前数据库中的所有数据！" -ForegroundColor Red
Write-Host "选中的备份: $($selectedBackup.Name)" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "确认恢复？(yes/no)"

if ($confirm -ne "yes") {
    Write-Host "操作已取消" -ForegroundColor Yellow
    pause
    exit 0
}

Write-Host ""
Write-Host "开始恢复数据库..." -ForegroundColor Green
Write-Host "这可能需要几秒钟..." -ForegroundColor Yellow
Write-Host ""

# 首先删除现有数据（可选）
Write-Host "清理现有数据..." -ForegroundColor Yellow
$dropSql = @"
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
"@
$dropSql | docker exec -i supabase-db psql -U postgres -d postgres | Out-Null

# 恢复备份
Write-Host "恢复备份数据..." -ForegroundColor Yellow
Get-Content $backupFile | docker exec -i supabase-db psql -U postgres -d postgres

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ 数据库恢复成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "恢复的备份: $($selectedBackup.Name)" -ForegroundColor White
    Write-Host "恢复时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "❌ 恢复失败" -ForegroundColor Red
    Write-Host "请查看上面的错误信息" -ForegroundColor Yellow
}

pause


