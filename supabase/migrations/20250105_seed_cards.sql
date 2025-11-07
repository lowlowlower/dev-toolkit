-- 导入卡牌数据

-- 攻击牌 - 推进项目
INSERT INTO cards (id, name, type, rarity, cost, description, icon, effect_type, effect_value, target_type, buff_data) VALUES
('attack_execute', '高效执行', 'attack', 'common', 1, '推进项目进度 8点', '⚡', 'damage', 8, 'enemy', NULL),
('attack_sprint', '敏捷冲刺', 'attack', 'common', 2, '推进项目进度 12点', '🏃', 'damage', 12, 'enemy', NULL),
('attack_innovation', '创新突破', 'attack', 'rare', 2, '推进项目进度 15点，抽1张牌', '💡', 'damage', 15, 'enemy', NULL),
('attack_team', '团队协作', 'attack', 'epic', 3, '推进项目进度 20点，获得5点防御', '👥', 'damage', 20, 'enemy', NULL);

-- 防御牌 - 风险管理
INSERT INTO cards (id, name, type, rarity, cost, description, icon, effect_type, effect_value, target_type, buff_data) VALUES
('skill_prepare', '充分准备', 'skill', 'common', 1, '获得 5点 风险防御', '🛡️', 'block', 5, 'self', NULL),
('skill_plan', '战略规划', 'skill', 'rare', 2, '获得 12点 风险防御', '🗺️', 'block', 12, 'self', NULL),
('skill_quality', '质量把控', 'skill', 'epic', 1, '获得 8点 风险防御，抽1张牌', '✓', 'block', 8, 'self', NULL);

-- 技能牌 - 抽牌和资源
INSERT INTO cards (id, name, type, rarity, cost, description, icon, effect_type, effect_value, target_type, buff_data) VALUES
('skill_study', '持续学习', 'skill', 'common', 1, '抽 2张 牌', '📚', 'draw', 2, 'none', NULL),
('skill_insight', '市场洞察', 'skill', 'rare', 0, '抽 1张 牌，获得1点能量', '🔍', 'draw', 1, 'none', NULL),
('skill_mentor', '导师指导', 'skill', 'epic', 2, '抽 3张 牌，获得5点防御', '🎓', 'draw', 3, 'none', NULL);

-- 能力牌 - 持续效果
INSERT INTO cards (id, name, type, rarity, cost, description, icon, effect_type, effect_value, target_type, buff_data) VALUES
('power_focus', '专注力', 'power', 'rare', 1, '每回合开始时，获得2点能量', '🎯', 'buff', 2, 'self', 
  '{"name": "专注", "duration": 999, "power": 2}'::jsonb),
('power_passion', '激情驱动', 'power', 'epic', 2, '每回合额外推进项目 3点', '🔥', 'buff', 3, 'self',
  '{"name": "激情", "duration": 999, "power": 3}'::jsonb),
('power_network', '人脉资源', 'power', 'rare', 1, '每回合开始时，抽1张牌', '🌐', 'buff', 1, 'self',
  '{"name": "人脉", "duration": 999, "power": 1}'::jsonb);

-- 资源牌
INSERT INTO cards (id, name, type, rarity, cost, description, icon, effect_type, effect_value, target_type, exhausts, buff_data) VALUES
('resource_funding', '资金支持', 'resource', 'common', 0, '获得 1点 能量', '💰', 'energy', 1, 'none', TRUE, NULL),
('resource_tools', '工具赋能', 'resource', 'rare', 0, '获得 2点 能量，抽1张牌', '🛠️', 'energy', 2, 'none', TRUE, NULL);

-- 传说牌
INSERT INTO cards (id, name, type, rarity, cost, description, icon, effect_type, effect_value, target_type, buff_data) VALUES
('legendary_vision', '战略愿景', 'power', 'legendary', 3, '每回合推进项目 5点，抽1张牌，获得3点防御', '🌟', 'buff', 5, 'self',
  '{"name": "愿景", "duration": 999, "power": 5}'::jsonb),
('legendary_breakthrough', '突破创新', 'attack', 'legendary', 4, '推进项目进度 40点', '🚀', 'damage', 40, 'enemy', NULL);

-- 验证数据
SELECT 
  '总卡牌数量: ' || COUNT(*) as summary,
  COUNT(CASE WHEN rarity = 'common' THEN 1 END) as common,
  COUNT(CASE WHEN rarity = 'rare' THEN 1 END) as rare,
  COUNT(CASE WHEN rarity = 'epic' THEN 1 END) as epic,
  COUNT(CASE WHEN rarity = 'legendary' THEN 1 END) as legendary
FROM cards;


