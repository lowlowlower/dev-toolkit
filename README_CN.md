# 🎯 事业构建器 - 卡牌工作流系统

一个创新的工作效率工具，通过卡牌组合的方式帮助你构建高效的工作流程。

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![React](https://img.shields.io/badge/React-18-61dafb.svg)
![TypeScript](https://img.shields.io/badge/TypeScript-5.2-3178c6.svg)

## ✨ 特性

- 🎴 **20张增强卡片** - 包含稀有度、等级、技能强度系统
- 🔗 **智能组合** - 自动识别并创建卡片组合，显示协同加成
- 📚 **工作流模板** - 5个预设的高效工作流，一键应用
- 🎨 **精美UI** - 流畅动画、炫酷光效、响应式设计
- 💾 **双模式** - 支持本地模拟数据或完整Docker Supabase

## 🚀 快速开始

### 方式一: 简单模式（推荐新手）

```powershell
# 1. 双击运行启动脚本
.\启动项目.ps1

# 2. 选择选项 1（仅前端，无需Docker）

# 3. 浏览器访问 http://localhost:5173
```

### 方式二: Docker 完整模式（推荐）⭐

#### 一键启动（最简单）
```powershell
cd docker
.\一键启动.ps1
```

#### 或分步操作
```powershell
# 1. 进入 docker 目录
cd docker

# 2. 安装（仅首次）
.\install.ps1

# 3. 启动服务
.\start.ps1

# 4. 初始化数据库
.\init-db.ps1

# 5. 返回根目录，启动前端
cd ..
npm run dev
```

**详细使用说明:** 查看 [DOCKER使用指南.md](DOCKER使用指南.md)

## 🎮 使用方法

1. **拖动卡片** - 在画布上自由移动卡片
2. **创建组合** - 将两张卡片拖到靠近位置（距离<200px）
3. **应用模板** - 点击右侧"工作流"按钮选择预设模板
4. **查看详情** - 点击卡片查看完整信息

## 📦 卡片系统

### 5大类别，20张卡片

- **核心能力** (Core): 创意灵感💡、团队协作👥、专注力🎯、客户关系🤝
- **策略能力** (Strategy): 市场洞察🔍、品牌建设🏆、战略规划🗺️、竞争分析⚔️
- **执行能力** (Execution): 技术实力⚙️、执行力⚡、质量管理✓、敏捷迭代🔄
- **资源能力** (Resource): 资金支持💰、时间管理⏰、人脉资源🌐、工具赋能🛠️
- **成长能力** (Growth): 持续学习📚、导师指导🎓、复盘总结📝、突破创新🚀

### 4种稀有度

- **普通** (Common) - 灰色边框
- **稀有** (Rare) - 蓝色边框
- **史诗** (Epic) - 紫色边框，呼吸光效
- **传说** (Legendary) - 金色边框，强烈光效

## 🛠️ 技术栈

- React 18 + TypeScript
- Framer Motion (动画)
- React DnD (拖拽)
- Supabase (数据库)
- Docker (容器化)
- Vite (构建工具)

## 🐳 Docker 命令行工具

提供完整的命令行脚本管理 Docker Supabase：

| 脚本 | 功能 | 使用场景 |
|------|------|----------|
| `一键启动.ps1` | 自动完成所有步骤 | ⭐ 推荐首次使用 |
| `install.ps1` | 安装镜像 | 首次使用 |
| `start.ps1` | 启动服务 | 每次启动 |
| `stop.ps1` | 停止服务 | 关闭服务 |
| `status.ps1` | 查看状态 | 检查服务 |
| `logs.ps1` | 查看日志 | 调试问题 |
| `init-db.ps1` | 初始化数据库 | 首次或重置 |
| `query.ps1` | 查询数据 | 查看数据 |
| `backup.ps1` | 备份数据 | 定期备份 |
| `restore.ps1` | 恢复数据 | 从备份恢复 |

**快速参考:** `docker/快速参考.txt`

## 📁 项目结构

```
环境营造/
├── src/
│   ├── components/      # 组件
│   │   ├── BusinessCard.tsx/css
│   │   └── WorkflowPanel.tsx/css
│   ├── lib/            # 工具库
│   │   ├── supabase.ts
│   │   └── supabase-mock.ts
│   ├── App.tsx/css     # 主应用
│   └── main.tsx        # 入口
├── supabase/
│   └── init.sql        # 数据库初始化
├── docker-compose.yml  # Docker配置
├── 启动项目.ps1       # 启动脚本
├── 停止服务.ps1       # 停止脚本
└── 项目说明.md        # 详细文档
```

## 🎯 预设工作流

1. **📅 高效工作日** - 专注力+时间管理+执行力
2. **💻 产品开发冲刺** - 技术实力+敏捷迭代+团队协作+质量管理
3. **📈 市场营销方案** - 市场洞察+品牌建设+客户关系+创意灵感
4. **🌱 个人成长计划** - 持续学习+导师指导+复盘总结+突破创新
5. **🎯 创业启动包** - 创意灵感+执行力+资金支持+市场洞察+战略规划

## 🔧 环境变量

复制 `.env.example` 为 `.env` 并配置：

```env
# 使用模拟数据（true）或真实数据库（false）
VITE_USE_MOCK=true

# Supabase配置（仅完整模式需要）
VITE_SUPABASE_URL=http://localhost:54324
VITE_SUPABASE_ANON_KEY=your-key
```

## 📝 待办事项

- [ ] 添加自定义卡片功能
- [ ] 支持导出/导入工作流
- [ ] 添加协作功能
- [ ] 移动端优化
- [ ] 添加成就系统

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

---

**开始你的高效工作流之旅！** 🚀

