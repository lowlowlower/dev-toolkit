-- 创建必要的扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 创建必要的角色（如果不存在）
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'anon') THEN
    CREATE ROLE anon NOLOGIN NOINHERIT;
  END IF;
  
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'authenticator') THEN
    CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'your-super-secret-jwt-token-with-at-least-32-characters-long';
  END IF;
  
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'service_role') THEN
    CREATE ROLE service_role NOLOGIN NOINHERIT BYPASSRLS;
  END IF;
END
$$;

-- 授予权限
GRANT anon TO authenticator;
GRANT service_role TO authenticator;

-- 授予表权限给 anon 角色
GRANT USAGE ON SCHEMA public TO anon;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon;

-- 创建事业要素卡片表（增强版）
CREATE TABLE IF NOT EXISTS business_cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  icon TEXT,
  color TEXT DEFAULT '#6366f1',
  position_x INTEGER DEFAULT 0,
  position_y INTEGER DEFAULT 0,
  z_index INTEGER DEFAULT 1,
  rarity TEXT DEFAULT 'common', -- 稀有度: common, rare, epic, legendary
  level INTEGER DEFAULT 1, -- 卡牌等级
  skill_power INTEGER DEFAULT 10, -- 技能强度
  synergy_tags TEXT[], -- 协同标签数组
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 创建组合关系表（增强版）
CREATE TABLE IF NOT EXISTS card_combinations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id_1 UUID NOT NULL REFERENCES business_cards(id) ON DELETE CASCADE,
  card_id_2 UUID NOT NULL REFERENCES business_cards(id) ON DELETE CASCADE,
  combination_name TEXT,
  description TEXT,
  synergy_bonus INTEGER DEFAULT 0, -- 协同加成
  combo_effect TEXT, -- 组合效果描述
  is_active BOOLEAN DEFAULT true, -- 是否激活
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  UNIQUE(card_id_1, card_id_2)
);

-- 创建工作流模板表
CREATE TABLE IF NOT EXISTS workflow_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL, -- daily, project, learning, business
  card_ids UUID[] NOT NULL, -- 包含的卡片ID数组
  difficulty TEXT DEFAULT 'medium', -- easy, medium, hard
  estimated_time INTEGER, -- 预计完成时间（分钟）
  icon TEXT,
  color TEXT DEFAULT '#6366f1',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 创建用户进度表
CREATE TABLE IF NOT EXISTS user_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_id UUID REFERENCES workflow_templates(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'pending', -- pending, in_progress, completed
  completion_date TIMESTAMP WITH TIME ZONE,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 启用 Row Level Security
ALTER TABLE business_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE card_combinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflow_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- 创建策略：允许所有人读取和写入（本地开发）
CREATE POLICY "Allow all operations for business_cards" ON business_cards
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations for card_combinations" ON card_combinations
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations for workflow_templates" ON workflow_templates
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations for user_progress" ON user_progress
  FOR ALL USING (true) WITH CHECK (true);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 创建触发器
CREATE TRIGGER update_business_cards_updated_at BEFORE UPDATE ON business_cards
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_progress_updated_at BEFORE UPDATE ON user_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 插入示例卡片数据（增强版）
INSERT INTO business_cards (title, description, category, icon, color, position_x, position_y, rarity, level, skill_power, synergy_tags) VALUES
-- 核心能力卡 (Core)
('创意灵感', '源源不断的创新想法，激发团队创造力', 'core', '💡', '#f59e0b', 100, 100, 'epic', 3, 85, ARRAY['innovation', 'creativity', 'thinking']),
('团队协作', '优秀的团队配合能力，1+1>2的效果', 'core', '👥', '#3b82f6', 300, 100, 'rare', 2, 70, ARRAY['teamwork', 'communication', 'synergy']),
('专注力', '深度工作，排除干扰，高效完成任务', 'core', '🎯', '#8b5cf6', 500, 100, 'epic', 4, 90, ARRAY['focus', 'productivity', 'efficiency']),
('客户关系', '维护良好的客户关系，建立信任', 'core', '🤝', '#06b6d4', 700, 100, 'rare', 2, 75, ARRAY['relationship', 'trust', 'service']),

-- 策略能力卡 (Strategy)
('市场洞察', '深刻理解市场需求和趋势', 'strategy', '🔍', '#10b981', 100, 300, 'rare', 3, 80, ARRAY['analysis', 'market', 'insight']),
('品牌建设', '建立强大的品牌影响力和认知度', 'strategy', '🏆', '#ef4444', 300, 300, 'epic', 3, 85, ARRAY['branding', 'marketing', 'influence']),
('战略规划', '制定长远目标和实现路径', 'strategy', '🗺️', '#8b5cf6', 500, 300, 'legendary', 5, 95, ARRAY['planning', 'strategy', 'vision']),
('竞争分析', '了解对手，找到差异化优势', 'strategy', '⚔️', '#f59e0b', 700, 300, 'rare', 2, 70, ARRAY['competition', 'analysis', 'positioning']),

-- 执行能力卡 (Execution)
('技术实力', '强大的技术实现和开发能力', 'execution', '⚙️', '#8b5cf6', 100, 500, 'epic', 4, 90, ARRAY['technology', 'development', 'implementation']),
('执行力', '强大的执行和落地能力，说干就干', 'execution', '⚡', '#ec4899', 300, 500, 'legendary', 5, 95, ARRAY['execution', 'action', 'delivery']),
('质量管理', '确保产出高质量的成果', 'execution', '✓', '#10b981', 500, 500, 'rare', 3, 80, ARRAY['quality', 'excellence', 'standards']),
('敏捷迭代', '快速响应变化，持续改进优化', 'execution', '🔄', '#3b82f6', 700, 500, 'epic', 3, 85, ARRAY['agile', 'iteration', 'improvement']),

-- 资源能力卡 (Resource)
('资金支持', '充足的资金保障和财务管理', 'resource', '💰', '#f59e0b', 100, 700, 'rare', 2, 75, ARRAY['finance', 'funding', 'capital']),
('时间管理', '合理分配时间，提高效率', 'resource', '⏰', '#ef4444', 300, 700, 'epic', 4, 88, ARRAY['time', 'scheduling', 'efficiency']),
('人脉资源', '广泛的人际网络和资源整合', 'resource', '🌐', '#06b6d4', 500, 700, 'rare', 3, 77, ARRAY['network', 'connections', 'resources']),
('工具赋能', '使用先进工具提升生产力', 'resource', '🛠️', '#8b5cf6', 700, 700, 'common', 2, 65, ARRAY['tools', 'automation', 'productivity']),

-- 成长能力卡 (Growth)
('持续学习', '不断学习新知识和适应变化', 'growth', '📚', '#6366f1', 900, 100, 'epic', 4, 87, ARRAY['learning', 'growth', 'adaptation']),
('导师指导', '获得经验丰富的导师指导', 'growth', '🎓', '#10b981', 900, 300, 'rare', 2, 72, ARRAY['mentorship', 'guidance', 'wisdom']),
('复盘总结', '定期回顾总结，提炼经验教训', 'growth', '📝', '#f59e0b', 900, 500, 'common', 2, 68, ARRAY['reflection', 'review', 'learning']),
('突破创新', '敢于尝试新事物，突破舒适区', 'growth', '🚀', '#ec4899', 900, 700, 'legendary', 5, 92, ARRAY['innovation', 'breakthrough', 'courage']);

-- 插入工作流模板
INSERT INTO workflow_templates (name, description, category, card_ids, difficulty, estimated_time, icon, color) VALUES
('高效工作日', '专注完成重要任务的日常工作流程', 'daily', 
  (SELECT ARRAY_AGG(id) FROM business_cards WHERE title IN ('专注力', '时间管理', '执行力')), 
  'easy', 480, '📅', '#3b82f6'),
  
('产品开发冲刺', '快速开发和迭代产品的完整流程', 'project', 
  (SELECT ARRAY_AGG(id) FROM business_cards WHERE title IN ('技术实力', '敏捷迭代', '团队协作', '质量管理')), 
  'hard', 720, '💻', '#8b5cf6'),
  
('市场营销方案', '制定并执行市场营销策略', 'business', 
  (SELECT ARRAY_AGG(id) FROM business_cards WHERE title IN ('市场洞察', '品牌建设', '客户关系', '创意灵感')), 
  'medium', 360, '📈', '#10b981'),
  
('个人成长计划', '持续学习和自我提升的路径', 'learning', 
  (SELECT ARRAY_AGG(id) FROM business_cards WHERE title IN ('持续学习', '导师指导', '复盘总结', '突破创新')), 
  'medium', 240, '🌱', '#f59e0b'),
  
('创业启动包', '创业初期必备的核心能力组合', 'business', 
  (SELECT ARRAY_AGG(id) FROM business_cards WHERE title IN ('创意灵感', '执行力', '资金支持', '市场洞察', '战略规划')), 
  'hard', 1440, '🎯', '#ef4444');

