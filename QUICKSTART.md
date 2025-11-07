# 快速启动指南

## 步骤 1: 启动 Supabase Docker 服务

```bash
docker-compose up -d
```

等待所有服务启动（大约需要 1-2 分钟）。你可以使用以下命令检查服务状态：

```bash
docker-compose ps
```

## 步骤 2: 初始化数据库

### 方法 1: 使用 Supabase Studio (推荐)

1. 访问 http://localhost:54323
2. 点击左侧菜单的 "SQL Editor"
3. 复制并粘贴 `supabase/init.sql` 文件中的所有内容
4. 点击 "Run" 执行脚本

### 方法 2: 使用 psql 命令行

```bash
docker exec -i supabase-db psql -U postgres < supabase/init.sql
```

## 步骤 3: 安装前端依赖

```bash
npm install
```

## 步骤 4: 启动开发服务器

```bash
npm run dev
```

访问 http://localhost:5173 查看应用

## 验证服务

- Supabase Studio: http://localhost:54323
- API Gateway: http://localhost:54324
- 前端应用: http://localhost:5173

## 停止服务

```bash
docker-compose down
```

如果需要删除所有数据：

```bash
docker-compose down -v
```



