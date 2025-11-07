# 微信消息每日分析脚本
# 使用方法：双击运行，复制微信聊天，粘贴，保存，自动分析

$ErrorActionPreference = "Stop"

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  微信消息每日分析" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 生成今日文件名
$date = Get-Date -Format "yyyyMMdd"
$time = Get-Date -Format "HHmmss"
$fileName = "daily_${date}.txt"
$filePath = Join-Path $PSScriptRoot $fileName

Write-Host "📅 日期: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White
Write-Host "📄 文件: $fileName" -ForegroundColor White
Write-Host ""

# 检查文件是否已存在
if (Test-Path $filePath) {
    Write-Host "⚠️  今天的文件已存在" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "选择操作:" -ForegroundColor Cyan
    Write-Host "1. 打开并编辑现有文件" -ForegroundColor White
    Write-Host "2. 创建新文件（覆盖）" -ForegroundColor White
    Write-Host "3. 直接分析现有文件" -ForegroundColor White
    Write-Host "0. 退出" -ForegroundColor White
    Write-Host ""
    
    $choice = Read-Host "请输入选项 (0-3)"
    
    switch ($choice) {
        "1" {
            Write-Host ""
            Write-Host "📝 打开文件编辑..." -ForegroundColor Cyan
            notepad $filePath
        }
        "2" {
            Write-Host ""
            Write-Host "📝 创建新文件..." -ForegroundColor Cyan
            "" | Out-File -FilePath $filePath -Encoding UTF8
            notepad $filePath
        }
        "3" {
            Write-Host ""
            Write-Host "📊 使用现有文件..." -ForegroundColor Cyan
        }
        "0" {
            Write-Host "👋 再见！" -ForegroundColor Cyan
            exit 0
        }
        default {
            Write-Host "❌ 无效选项" -ForegroundColor Red
            exit 1
        }
    }
} else {
    Write-Host "📝 准备创建今日文件..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "操作步骤:" -ForegroundColor Yellow
    Write-Host "  1. 打开微信，找到要分析的对话" -ForegroundColor Gray
    Write-Host "  2. 按住 Shift，点选多条消息" -ForegroundColor Gray
    Write-Host "  3. Ctrl+C 复制" -ForegroundColor Gray
    Write-Host "  4. 在打开的记事本中 Ctrl+V 粘贴" -ForegroundColor Gray
    Write-Host "  5. Ctrl+S 保存，关闭记事本" -ForegroundColor Gray
    Write-Host ""
    
    $confirm = Read-Host "按回车继续（会打开记事本）"
    
    # 创建空文件
    "" | Out-File -FilePath $filePath -Encoding UTF8
    
    # 打开记事本
    Write-Host ""
    Write-Host "📝 记事本已打开，请粘贴微信聊天记录..." -ForegroundColor Cyan
    notepad $filePath
}

# 等待用户保存
Write-Host ""
Write-Host "⏳ 等待文件保存..." -ForegroundColor Cyan
Start-Sleep -Seconds 2

# 检查文件内容
if (-not (Test-Path $filePath)) {
    Write-Host "❌ 文件不存在" -ForegroundColor Red
    pause
    exit 1
}

$content = Get-Content $filePath -Raw
if ([string]::IsNullOrWhiteSpace($content)) {
    Write-Host "⚠️  文件是空的" -ForegroundColor Yellow
    Write-Host ""
    $retry = Read-Host "是否重新编辑？(y/n)"
    if ($retry -eq "y" -or $retry -eq "Y") {
        notepad $filePath
        Write-Host ""
        Write-Host "保存后按回车继续..." -ForegroundColor Yellow
        Read-Host
    } else {
        Write-Host "❌ 已取消" -ForegroundColor Red
        exit 1
    }
}

# 显示文件信息
$lines = (Get-Content $filePath).Count
$chars = $content.Length
Write-Host ""
Write-Host "✅ 文件就绪" -ForegroundColor Green
Write-Host "   行数: $lines" -ForegroundColor Gray
Write-Host "   字符: $chars" -ForegroundColor Gray
Write-Host ""

# 运行分析
Write-Host "================================" -ForegroundColor Cyan
Write-Host "🤖 开始 AI 分析..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

try {
    python main.py --file $fileName
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "================================" -ForegroundColor Green
        Write-Host "✅ 分析完成！" -ForegroundColor Green
        Write-Host "================================" -ForegroundColor Green
        Write-Host ""
        
        # 查找最新报告
        $reportsDir = Join-Path $PSScriptRoot "reports"
        if (Test-Path $reportsDir) {
            $latestReport = Get-ChildItem $reportsDir -Filter "*.md" | 
                Sort-Object LastWriteTime -Descending | 
                Select-Object -First 1
            
            if ($latestReport) {
                Write-Host "📊 报告文件: $($latestReport.Name)" -ForegroundColor Cyan
                Write-Host ""
                
                $openReport = Read-Host "是否打开报告？(y/n)"
                if ($openReport -eq "y" -or $openReport -eq "Y") {
                    notepad $latestReport.FullName
                }
                
                Write-Host ""
                Write-Host "报告位置: $($latestReport.FullName)" -ForegroundColor Gray
            }
        }
    } else {
        Write-Host ""
        Write-Host "❌ 分析失败" -ForegroundColor Red
    }
} catch {
    Write-Host ""
    Write-Host "❌ 发生错误: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "按任意键退出..." -ForegroundColor Gray
pause

