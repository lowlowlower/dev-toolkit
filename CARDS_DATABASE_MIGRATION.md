# 🎴 卡牌数据迁移到 Supabase 数据库

## ✅ 迁移完成！

卡牌数据已成功从静态文件迁移到 Supabase 数据库。

---

## 📋 迁移内容

### 1. 数据库表结构
创建了 `cards` 表，包含以下字段：
- `id` - 卡牌唯一标识
- `name` - 卡牌名称
- `type` - 卡牌类型（skill/attack/power/resource）
- `rarity` - 稀有度（common/rare/epic/legendary）
- `cost` - 能量消耗
- `description` - 卡牌描述
- `icon` - 卡牌图标（emoji）
- `effect_type` - 效果类型
- `effect_value` - 效果数值
- `target_type` - 目标类型
- `exhausts` - 是否消耗
- `ethereal` - 是否虚无
- `buff_data` - Buff 数据（JSON格式）

### 2. 迁移的卡牌
共导入 **16张卡牌**：
- 4张攻击牌（推进项目）
- 3张防御牌（风险管理）
- 3张技能牌（抽牌和资源）
- 3张能力牌（持续效果）
- 2张资源牌
- 2张传说牌

### 3. 新增功能
- ✅ 创建了 `useCards` hook 从数据库加载卡牌
- ✅ 更新了 `useGameState` 支持数据库和本地数据双模式
- ✅ 添加了加载状态显示
- ✅ 保留了本地数据作为后备方案

---

## 🔧 技术实现

### 数据库迁移文件
```
supabase/migrations/
├── 20251105232200_create_cards_table.sql   # 创建表结构
└── 20251105232201_seed_cards.sql          # 导入卡牌数据
```

### 新增代码文件
```
src/hooks/useCards.ts                      # 卡牌数据 hook
```

### 修改的文件
```
src/lib/supabase.ts                        # 更新配置
src/hooks/useGameState.ts                  # 支持数据库数据
src/App.tsx                                # 添加加载状态
```

---

## 🚀 使用方法

### 查看数据库中的卡牌
1. 打开 Supabase Studio：http://127.0.0.1:54323
2. 选择 "Table Editor"
3. 选择 `cards` 表
4. 可以查看、编辑、添加卡牌

### 修改卡牌数据
有两种方式：

#### 方式1：通过 Studio 界面（推荐）
1. 访问 http://127.0.0.1:54323
2. 在表编辑器中直接修改
3. 刷新游戏页面即可看到变化

#### 方式2：通过 SQL
```sql
-- 修改卡牌
UPDATE cards 
SET description = '新的描述', effect_value = 10 
WHERE id = 'attack_execute';

-- 添加新卡牌
INSERT INTO cards (
  id, name, type, rarity, cost, 
  description, icon, effect_type, effect_value, target_type
) VALUES (
  'new_card', '新卡牌', 'attack', 'rare', 2,
  '这是一张新卡牌', '⚡', 'damage', 15, 'enemy'
);
```

---

## 💡 优势

### 之前（静态文件）
- ❌ 修改需要编辑代码
- ❌ 需要重新部署
- ❌ 无法动态管理
- ❌ 无法做数据统计

### 现在（数据库）
- ✅ 通过界面可视化管理
- ✅ 实时更新，无需重新部署
- ✅ 可以动态添加/删除卡牌
- ✅ 可以记录使用数据
- ✅ 支持用户自定义卡牌（未来功能）
- ✅ 保留本地数据作为后备

---

## 🔍 验证迁移

### 1. 检查数据库
访问 Studio: http://127.0.0.1:54323

### 2. 查看控制台
打开浏览器开发者工具（F12），在控制台中应该看到：
```
🗄️ 使用 Supabase 本地数据库
✅ 从数据库加载了 16 张卡牌
🎴 使用 数据库 卡牌数据，共 16 张
```

### 3. 游戏测试
- ✅ 启动新游戏
- ✅ 查看手牌
- ✅ 打出卡牌
- ✅ 验证卡牌效果

---

## 📊 数据结构对比

### 原始格式（TypeScript）
```typescript
{
  id: 'attack_execute',
  name: '高效执行',
  type: 'attack',
  rarity: 'common',
  cost: 1,
  description: '推进项目进度 8点',
  icon: '⚡',
  effect: { type: 'damage', value: 8 },
  targetType: 'enemy'
}
```

### 数据库格式（扁平化）
```sql
id: 'attack_execute'
name: '高效执行'
type: 'attack'
rarity: 'common'
cost: 1
description: '推进项目进度 8点'
icon: '⚡'
effect_type: 'damage'
effect_value: 8
target_type: 'enemy'
```

代码中自动转换，使用时无感知！

---

## 🎯 未来扩展

有了数据库后，可以轻松实现：

1. **用户系统**
   - 保存用户的卡组
   - 记录游戏进度
   - 成就系统

2. **卡牌收集**
   - 解锁新卡牌
   - 升级卡牌
   - 稀有卡牌掉落

3. **数据分析**
   - 卡牌使用率
   - 胜率统计
   - 平衡性调整

4. **多人功能**
   - 分享卡组
   - 排行榜
   - 对战系统

---

## 🛠️ 故障排除

### 如果卡牌无法加载
1. 检查 Supabase 是否运行：`npx supabase status`
2. 查看浏览器控制台错误
3. 系统会自动回退到本地数据

### 如果需要重置数据
```bash
npx supabase db reset
```

### 如果需要查看日志
```bash
npx supabase logs
```

---

## ✨ 总结

卡牌数据成功迁移到 Supabase 数据库！
- 📦 16张卡牌已导入
- 🔄 支持实时更新
- 🛡️ 有本地数据后备
- 🚀 为未来功能打好基础

**现在可以通过 Supabase Studio 轻松管理所有卡牌了！** 🎉


