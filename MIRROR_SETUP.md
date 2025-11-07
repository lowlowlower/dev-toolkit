# Docker 镜像加速器配置指南

## 问题
代理连接不稳定，Docker 无法拉取镜像

## 解决方案：使用镜像加速器

### 步骤 1: 配置镜像加速器

1. 打开 Docker Desktop
2. 点击 **Settings** (设置)
3. 选择 **Docker Engine**
4. 在配置 JSON 中添加以下内容：

```json
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

5. 点击 **Apply & Restart**

### 步骤 2: 禁用代理（如果使用镜像加速器）

如果使用镜像加速器，可以暂时禁用代理设置：

1. Settings → Resources → Proxies
2. 关闭 **Manual proxy configuration**
3. 点击 **Apply & Restart**

### 步骤 3: 测试

重启后运行：
```powershell
docker pull hello-world
```

如果成功，运行：
```powershell
docker compose up -d
```

## 备选方案

如果镜像加速器也不可用，可以：
1. 继续使用应用的模拟模式（功能完整）
2. 联系网络管理员检查代理设置
3. 尝试使用手机热点等其他网络


