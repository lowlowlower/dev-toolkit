# 微信消息 AI 分析器 - 快速启动脚本
# 一键运行分析

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  微信消息 AI 分析器" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Python
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ 未找到 Python，请先安装 Python 3.8+" -ForegroundColor Red
    Write-Host "   下载地址: https://www.python.org/downloads/" -ForegroundColor Yellow
    pause
    exit 1
}

# 检查配置文件
if (-not (Test-Path "config.json")) {
    Write-Host "⚠️  未找到配置文件" -ForegroundColor Yellow
    
    if (Test-Path "config.example.json") {
        Write-Host "📝 正在创建配置文件..." -ForegroundColor Cyan
        Copy-Item "config.example.json" "config.json"
        Write-Host "✅ 已创建 config.json" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  请先编辑 config.json 填入你的 Gemini API Key" -ForegroundColor Yellow
        Write-Host "   然后重新运行此脚本" -ForegroundColor Yellow
        
        # 打开配置文件
        notepad config.json
        pause
        exit 0
    } else {
        Write-Host "❌ 未找到配置文件模板" -ForegroundColor Red
        pause
        exit 1
    }
}

# 检查 API Key
$config = Get-Content "config.json" -Raw | ConvertFrom-Json
if ($config.gemini_api_key -eq "your_api_key_here" -or $config.gemini_api_key -eq "AIzaSyApuy_ax9jhGXpUdlgI6w_0H5aZ7XiY9vU") {
    Write-Host "⚠️  检测到默认 API Key，建议使用你自己的 Key" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "是否继续？(y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 0
    }
}

# 检查依赖
Write-Host ""
Write-Host "🔍 检查依赖..." -ForegroundColor Cyan

$required = @("requests", "schedule", "pandas")
$missing = @()

foreach ($module in $required) {
    $installed = pip show $module 2>&1
    if ($LASTEXITCODE -ne 0) {
        $missing += $module
    }
}

if ($missing.Count -gt 0) {
    Write-Host "⚠️  缺少依赖: $($missing -join ', ')" -ForegroundColor Yellow
    Write-Host "📦 正在安装..." -ForegroundColor Cyan
    
    pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 依赖安装失败" -ForegroundColor Red
        pause
        exit 1
    }
    
    Write-Host "✅ 依赖安装完成" -ForegroundColor Green
}

# 显示菜单
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "  请选择操作" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. 🧪 测试 Gemini API 连接" -ForegroundColor White
Write-Host "2. 📱 分析最近 24 小时消息" -ForegroundColor White
Write-Host "3. 📱 分析最近 48 小时消息" -ForegroundColor White
Write-Host "4. 📂 从文件分析消息" -ForegroundColor White
Write-Host "5. ⏰ 启动定时任务" -ForegroundColor White
Write-Host "6. 📊 查看历史报告" -ForegroundColor White
Write-Host "7. ⚙️  编辑配置文件" -ForegroundColor White
Write-Host "0. ❌ 退出" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请输入选项 (0-7)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🧪 测试 API 连接..." -ForegroundColor Cyan
        python main.py --test
    }
    "2" {
        Write-Host ""
        Write-Host "📱 分析最近 24 小时消息..." -ForegroundColor Cyan
        python main.py --hours 24
    }
    "3" {
        Write-Host ""
        Write-Host "📱 分析最近 48 小时消息..." -ForegroundColor Cyan
        python main.py --hours 48
    }
    "4" {
        Write-Host ""
        $filePath = Read-Host "请输入消息文件路径"
        if (Test-Path $filePath) {
            python main.py --file $filePath
        } else {
            Write-Host "❌ 文件不存在: $filePath" -ForegroundColor Red
        }
    }
    "5" {
        Write-Host ""
        Write-Host "⏰ 启动定时任务..." -ForegroundColor Cyan
        Write-Host "按 Ctrl+C 停止" -ForegroundColor Yellow
        python schedule_daily.py
    }
    "6" {
        Write-Host ""
        if (Test-Path "reports") {
            Write-Host "📊 历史报告:" -ForegroundColor Cyan
            Get-ChildItem "reports\*.md" | Sort-Object LastWriteTime -Descending | ForEach-Object {
                Write-Host "  - $($_.Name) ($(Get-Date $_.LastWriteTime -Format 'yyyy-MM-dd HH:mm'))"
            }
            Write-Host ""
            $open = Read-Host "是否打开最新报告？(y/n)"
            if ($open -eq "y" -or $open -eq "Y") {
                $latest = Get-ChildItem "reports\report_*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
                if ($latest) {
                    notepad $latest.FullName
                }
            }
        } else {
            Write-Host "📂 还没有生成报告" -ForegroundColor Yellow
        }
    }
    "7" {
        notepad config.json
    }
    "0" {
        Write-Host "👋 再见！" -ForegroundColor Cyan
        exit 0
    }
    default {
        Write-Host "❌ 无效选项" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "按任意键退出..." -ForegroundColor Gray
pause

