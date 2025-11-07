# 事业构建器 - Business Builder

一个有趣的可视化工具，通过拖拽卡片来模拟和构建成功事业所需的要素。

## 功能特性

- 🎴 可拖动的卡片系统
- 🎨 美观的现代化 UI
- 💾 基于 Supabase 的数据持久化
- 🔗 卡片组合和关系展示
- 📊 可视化的事业要素管理

## 技术栈

- React + TypeScript
- Vite
- Supabase
- Framer Motion (动画)
- React DnD (拖拽)

## 快速开始

### 1. 启动 Supabase (Docker)

```bash
docker-compose up -d
```

等待所有服务启动完成后，访问：
- Supabase Studio: http://localhost:54323
- API Gateway: http://localhost:54324

### 2. 初始化数据库

连接到 PostgreSQL 数据库（端口 54322）并执行 `supabase/init.sql` 中的 SQL 脚本。

或者使用 Supabase Studio 的 SQL 编辑器执行脚本。

### 3. 安装前端依赖

```bash
npm install
```

### 4. 启动开发服务器

```bash
npm run dev
```

访问 http://localhost:5173

## 环境变量

创建 `.env` 文件（如果需要自定义配置）：

```env
VITE_SUPABASE_URL=http://localhost:54324
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
```

## Docker 服务说明

- **supabase-db**: PostgreSQL 数据库 (端口 54322)
- **supabase-studio**: Supabase Studio 管理界面 (端口 54323)
- **supabase-kong**: API 网关 (端口 54324)
- **supabase-auth**: 认证服务 (端口 54325)
- **supabase-rest**: REST API (端口 54326)
- **supabase-storage**: 存储服务 (端口 54327)

## 项目结构

```
.
├── docker-compose.yml      # Docker Compose 配置
├── kong.yml               # Kong API 网关配置
├── supabase/
│   └── init.sql          # 数据库初始化脚本
├── src/
│   ├── components/       # React 组件
│   ├── lib/             # 工具函数和 Supabase 客户端
│   └── App.tsx          # 主应用组件
└── package.json
```

## 使用说明

1. 启动 Docker 服务后，卡片会自动加载
2. 拖动卡片到任意位置
3. 将两个卡片靠近可以创建组合关系
4. 点击卡片可以查看详情



