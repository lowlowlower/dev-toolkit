# 🛠️ Dev Toolkit - 开发工具集

> 一个集成了多种实用开发工具和脚本的项目，旨在提升开发效率和环境配置体验。

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/lowlowlower/dev-toolkit.svg)](https://github.com/lowlowlower/dev-toolkit/stargazers)

## ✨ 主要功能

### 1. 🔧 微信工具集

#### 微信多开工具
- **一键多开微信** - 支持同时登录多个微信账号
- 提供批处理 (.bat) 和 PowerShell (.ps1) 两个版本
- 友好的交互界面，支持自定义开启数量

**使用方法：**
```bash
# 双击运行
.\微信多开.bat

# 或使用 PowerShell
.\微信多开.ps1 -Count 3
```

#### 微信消息 AI 分析器
- 📱 自动提取微信聊天记录
- 🤖 使用 Google Gemini AI 智能分析
- 📊 生成多维度分析报告
- ⏰ 支持定时任务

**功能特性：**
- 重要信息摘要
- 待办事项提取
- 情感分析
- 联系人统计
- 行动建议

[查看详细文档](./wechat-ai-analyzer/README.md)

### 2. 🐳 Docker 配置管理

完整的 Docker 环境配置工具集：

- **一键启动脚本** - 快速启动 Docker 服务
- **代理配置** - 解决国内 Docker 镜像拉取问题
- **镜像管理** - 镜像源配置和切换
- **故障诊断** - 自动诊断 Docker 网络问题

**提供的脚本：**
```bash
.\docker\一键启动.ps1        # 启动所有服务
.\docker\stop.ps1           # 停止服务
.\docker\status.ps1         # 查看状态
.\docker\logs.ps1           # 查看日志
.\docker\backup.ps1         # 数据备份
.\docker\restore.ps1        # 数据恢复
```

### 3. 💾 Supabase 集成

- 完整的 Supabase 配置
- 数据库迁移脚本
- 示例数据初始化
- 卡牌数据管理

### 4. 🎮 React 卡牌游戏

一个基于 React + TypeScript 的卡牌游戏项目：

- 商业卡牌系统
- 游戏状态管理
- Supabase 数据持久化
- 现代化 UI 设计

## 🚀 快速开始

### 环境要求

- **Node.js**: 16+ (用于前端项目)
- **Python**: 3.8+ (用于微信AI分析器)
- **Docker**: 20+ (用于容器化部署)
- **Git**: 2.0+

### 安装步骤

1. **克隆仓库**
```bash
git clone https://github.com/lowlowlower/dev-toolkit.git
cd dev-toolkit
```

2. **安装前端依赖**
```bash
npm install
```

3. **配置微信AI分析器**
```bash
cd wechat-ai-analyzer
pip install -r requirements.txt
cp config.example.json config.json
# 编辑 config.json，填入你的 Gemini API Key
```

4. **启动项目**
```bash
# 前端开发服务器
npm run dev

# 或启动 Docker 服务
.\docker\一键启动.ps1
```

## 📖 文档索引

### 核心文档
- [项目说明](./项目说明.md) - 项目整体介绍
- [快速开始](./QUICKSTART.md) - 5分钟上手指南
- [如何安装](./如何安装.txt) - 详细安装步骤
- [配置说明](./配置说明.md) - 各项配置详解
- [部署指南](./部署指南.md) - 生产环境部署

### Docker 相关
- [Docker 使用指南](./DOCKER使用指南.md)
- [Docker 安装说明](./Docker安装说明.txt)
- [Docker 网络问题解决](./Docker网络问题解决.md)
- [Docker 代理配置](./DOCKER_PROXY_SETUP.md)
- [Docker 故障排查](./DOCKER_TROUBLESHOOTING.md)

### 微信工具
- [微信AI分析器 README](./wechat-ai-analyzer/README.md)
- [使用说明](./wechat-ai-analyzer/使用说明.md)
- [安装指南](./wechat-ai-analyzer/安装指南.md)
- [快速启动](./wechat-ai-analyzer/QUICKSTART.md)

### 数据库
- [卡牌数据库迁移](./CARDS_DATABASE_MIGRATION.md)
- [Supabase 安装](./安装Supabase.ps1)

## 🎯 使用场景

### 场景 1：多账号管理
需要同时登录多个微信账号（工作号、私人号）时，使用微信多开工具。

### 场景 2：消息分析与总结
每天晚上自动分析微信工作群消息，提取重要信息和待办事项。

### 场景 3：Docker 开发环境
快速搭建包含数据库、API 网关等服务的 Docker 开发环境。

### 场景 4：全栈开发
使用 React + Supabase 进行全栈应用开发，包含前端、后端、数据库。

## 🛠️ 技术栈

### 前端
- **框架**: React 18
- **语言**: TypeScript
- **构建工具**: Vite
- **样式**: CSS Modules

### 后端 & 数据库
- **BaaS**: Supabase
- **数据库**: PostgreSQL
- **容器化**: Docker & Docker Compose

### AI & 自动化
- **AI 模型**: Google Gemini
- **语言**: Python 3.8+
- **任务调度**: schedule

### DevOps
- **容器编排**: Docker Compose
- **API 网关**: Kong
- **脚本**: PowerShell, Bash

## 📊 项目结构

```
dev-toolkit/
├── 📱 微信工具
│   ├── 微信多开.bat            # 微信多开批处理脚本
│   ├── 微信多开.ps1            # 微信多开 PowerShell 脚本
│   └── wechat-ai-analyzer/    # 微信AI分析器
│       ├── main.py
│       ├── gemini_client.py
│       └── wechat_extractor.py
│
├── 🐳 Docker 配置
│   ├── docker-compose.yml     # 主配置文件
│   ├── kong.yml               # Kong API 网关配置
│   └── docker/                # Docker 管理脚本
│       ├── 一键启动.ps1
│       ├── start.ps1
│       ├── stop.ps1
│       └── ...
│
├── 💻 前端项目
│   ├── src/
│   │   ├── components/        # React 组件
│   │   ├── hooks/             # 自定义 Hooks
│   │   ├── lib/               # 工具库
│   │   └── types/             # TypeScript 类型
│   ├── package.json
│   └── vite.config.ts
│
├── 💾 数据库
│   └── supabase/
│       ├── config.toml
│       ├── init.sql
│       └── migrations/        # 数据库迁移文件
│
└── 📚 文档
    ├── README.md              # 本文件
    ├── 项目说明.md
    ├── 配置说明.md
    └── ...
```

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📝 待办事项

- [ ] 添加微信工具的图形界面
- [ ] 支持更多 AI 模型（OpenAI、Claude）
- [ ] 添加自动化测试
- [ ] 完善文档和示例
- [ ] 添加 CI/CD 配置
- [ ] 支持 QQ 消息分析（基于 NapCat）

## ⚠️ 免责声明

本工具集仅供个人学习和研究使用。使用本工具时请：

- ✅ 遵守相关法律法规
- ✅ 尊重他人隐私
- ✅ 仅分析自己的消息或已获授权的消息
- ✅ 妥善保管 API Key 和敏感数据

作者不对使用本工具造成的任何后果负责。

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- Google Gemini AI
- Supabase
- React 社区
- Docker 社区
- 所有贡献者

## 📞 联系方式

- **GitHub**: [@lowlowlower](https://github.com/lowlowlower)
- **仓库**: [dev-toolkit](https://github.com/lowlowlower/dev-toolkit)
- **Issues**: [提交问题](https://github.com/lowlowlower/dev-toolkit/issues)

---

**Made with ❤️ | Powered by AI & Open Source**

如果觉得有用，请给个 ⭐ Star！
