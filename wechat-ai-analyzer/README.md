# 🤖 微信消息 AI 分析器

自动提取微信聊天记录，使用 Google Gemini AI 进行智能分析，生成每日报告。

## ✨ 功能特性

- 📱 **自动提取微信消息** - 从本地数据库提取聊天记录
- 🤖 **AI 智能分析** - 使用 Gemini AI 生成分析报告
- 📊 **多维度分析** - 重要信息摘要、待办事项、情感分析、联系人统计
- ⏰ **定时任务** - 支持每日自动运行
- 💾 **报告保存** - 自动保存分析报告和原始数据

## 📋 分析内容

每日报告包含：
1. **重要信息摘要** - 提取关键信息和重要对话
2. **待办事项** - 识别所有任务和 TODO
3. **情感分析** - 分析整体情感趋势
4. **关键联系人** - 统计主要沟通对象
5. **行动建议** - AI 给出的后续建议

## 🚀 快速开始

### 1. 安装依赖

```powershell
# 进入项目目录
cd wechat-ai-analyzer

# 安装 Python 依赖
pip install -r requirements.txt
```

### 2. 配置 API Key

复制配置文件模板：
```powershell
copy config.example.json config.json
```

编辑 `config.json`，填入你的 Gemini API Key：
```json
{
  "gemini_api_key": "你的API_KEY",
  "analyze_last_hours": 24,
  "output_dir": "./reports"
}
```

### 3. 测试连接

```powershell
python main.py --test
```

### 4. 运行分析

```powershell
# 分析最近24小时的消息
python main.py

# 分析最近48小时的消息
python main.py --hours 48

# 从文件分析
python main.py --file messages.txt
```

## 📁 项目结构

```
wechat-ai-analyzer/
├── main.py                 # 主程序
├── gemini_client.py        # Gemini API 客户端
├── wechat_extractor.py     # 微信消息提取器
├── schedule_daily.py       # 定时任务脚本
├── config.json             # 配置文件（需创建）
├── config.example.json     # 配置模板
├── requirements.txt        # Python 依赖
├── README.md              # 使用说明
├── 安装指南.md            # 详细安装说明
├── 快速启动.ps1           # 一键启动脚本
└── reports/               # 分析报告目录
    ├── messages_*.txt     # 原始消息
    └── report_*.md        # 分析报告
```

## 🔧 详细使用

### 方法一：手动运行

```powershell
# 默认分析最近24小时
python main.py

# 指定时间范围
python main.py --hours 48

# 使用自定义配置
python main.py --config my_config.json
```

### 方法二：定时任务

```powershell
# 启动定时任务（每天指定时间自动运行）
python schedule_daily.py
```

在 `config.json` 中配置执行时间：
```json
{
  "schedule_time": "09:00"
}
```

### 方法三：从文件分析

如果无法直接提取微信消息，可以：
1. 使用第三方工具导出消息（如 WeChatMsg）
2. 保存为文本文件
3. 使用 `--file` 参数分析

```powershell
python main.py --file exported_messages.txt
```

## 📱 微信消息提取

### 自动提取（推荐）

程序会自动尝试以下方法：
1. **简单方法** - 直接读取数据库（适用于未加密情况）
2. **高级方法** - 使用 pywxdump 解密（需安装）

### 使用 pywxdump

```powershell
pip install pywxdump
```

确保：
- ✅ 微信已登录
- ✅ 微信客户端正在运行
- ✅ 有足够的权限访问微信数据

### 使用第三方工具

如果自动提取失败，推荐使用：

**WeChatMsg** (图形界面，功能强大)
```powershell
# 访问 GitHub 下载
# https://github.com/LC044/WeChatMsg
```

导出后使用 `--file` 参数分析。

## ⚙️ 配置说明

### 完整配置示例

```json
{
  "gemini_api_key": "AIzaSy...",
  "analyze_last_hours": 24,
  "output_dir": "./reports",
  "wechat_data_path": "",
  "schedule_time": "09:00",
  "analysis_prompts": {
    "daily_summary": "自定义分析提示词...",
    "sentiment": "情感分析提示词...",
    "todo_extract": "待办事项提取提示词..."
  }
}
```

### 配置项说明

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| `gemini_api_key` | Gemini API 密钥 | **必填** |
| `analyze_last_hours` | 分析时间范围（小时） | 24 |
| `output_dir` | 报告输出目录 | ./reports |
| `wechat_data_path` | 微信数据路径 | 自动检测 |
| `schedule_time` | 定时任务执行时间 | 09:00 |

## 🎯 使用场景

### 场景1：每日工作总结
每天晚上自动分析工作群消息，提取重要信息和待办事项。

### 场景2：客户沟通管理
定期分析客户聊天记录，了解客户需求和问题。

### 场景3：团队协作优化
分析团队沟通内容，发现协作问题和改进点。

### 场景4：个人生活记录
分析私人聊天，记录生活重要事件。

## 📊 报告示例

生成的报告格式：

```markdown
# 微信消息分析报告

**生成时间**: 2025-11-05 20:30:00
**分析时段**: 最近 24 小时
**消息数量**: 156 条

---

## 重要信息摘要

1. 明天下午3点有项目会议，需要准备PPT
2. 客户提出了新的需求变更
3. 周五前需要提交月度报告

## 待办事项

- [ ] 准备项目会议PPT（明天3点前）
- [ ] 回复客户需求确认邮件
- [ ] 完成月度报告（周五前）

## 情感分析

整体情感: 积极向上 😊
主要情绪: 工作导向，略有压力

## 关键联系人

1. 张三 - 32条消息（工作讨论）
2. 李四 - 28条消息（项目协作）
3. 客户王总 - 15条消息（需求沟通）

## 建议

1. 优先处理客户需求确认
2. 合理安排时间准备会议材料
3. 注意工作压力管理
```

## 🔐 隐私和安全

- ✅ **本地运行** - 所有数据在本地处理
- ✅ **API加密** - 使用 HTTPS 传输
- ✅ **数据控制** - 你完全控制数据的使用
- ⚠️ **仅供个人** - 请勿用于未授权的数据分析
- ⚠️ **遵守法律** - 请遵守相关法律法规

## ❓ 常见问题

### Q1: 提示"未找到微信数据路径"
**A:** 手动指定路径：
```json
{
  "wechat_data_path": "C:\\Users\\你的用户名\\Documents\\WeChat Files"
}
```

### Q2: 提示"数据库已加密"
**A:** 安装 pywxdump：
```powershell
pip install pywxdump
```

### Q3: API 请求失败
**A:** 检查：
- API Key 是否正确
- 网络连接是否正常
- 是否超过 API 配额

### Q4: 提取不到消息
**A:** 尝试：
1. 确保微信已登录
2. 使用管理员权限运行
3. 使用第三方工具导出后用 `--file` 分析

### Q5: 想自定义分析内容
**A:** 在 `config.json` 中修改 `analysis_prompts`：
```json
{
  "analysis_prompts": {
    "daily_summary": "你的自定义提示词..."
  }
}
```

## 🛠️ 高级功能

### 自定义分析类型

修改 `main.py`，使用不同的分析类型：

```python
# 情感分析
analysis_result = analyzer.gemini.analyze_messages(
    formatted_messages,
    analysis_type='sentiment'
)

# 待办事项提取
analysis_result = analyzer.gemini.analyze_messages(
    formatted_messages,
    analysis_type='todo_extract'
)
```

### Windows 计划任务

创建 Windows 计划任务实现开机自启：

1. 打开"任务计划程序"
2. 创建基本任务
3. 设置触发器（每天指定时间）
4. 操作：运行 `python main.py`

## 📝 开发计划

- [ ] 支持多账号分析
- [ ] 添加 Web 界面
- [ ] 支持更多 AI 模型（OpenAI、Claude 等）
- [ ] 数据可视化
- [ ] 导出更多格式（Excel、PDF）

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可

仅供个人学习和研究使用。

## ⚠️ 免责声明

本工具仅供个人学习和研究使用。使用本工具时请：
- 遵守相关法律法规
- 尊重他人隐私
- 仅分析自己的消息或已获授权的消息
- 妥善保管 API Key 和敏感数据

作者不对使用本工具造成的任何后果负责。

---

**Made with ❤️ | Powered by Gemini AI**

