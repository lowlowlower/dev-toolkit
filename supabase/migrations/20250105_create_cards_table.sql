-- 创建卡牌稀有度枚举类型
CREATE TYPE card_rarity AS ENUM ('common', 'rare', 'epic', 'legendary');

-- 创建卡牌类型枚举
CREATE TYPE card_type AS ENUM ('skill', 'attack', 'power', 'resource');

-- 创建卡牌效果类型枚举
CREATE TYPE effect_type AS ENUM ('damage', 'block', 'draw', 'energy', 'buff', 'debuff', 'heal');

-- 创建目标类型枚举
CREATE TYPE target_type AS ENUM ('self', 'enemy', 'all', 'none');

-- 创建卡牌表
CREATE TABLE IF NOT EXISTS cards (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type card_type NOT NULL,
  rarity card_rarity NOT NULL,
  cost INTEGER NOT NULL CHECK (cost >= 0),
  description TEXT NOT NULL,
  icon TEXT NOT NULL,
  effect_type effect_type NOT NULL,
  effect_value INTEGER NOT NULL,
  target_type target_type NOT NULL,
  exhausts BOOLEAN DEFAULT FALSE,
  ethereal BOOLEAN DEFAULT FALSE,
  -- Buff 相关字段（JSON格式）
  buff_data JSONB,
  -- 元数据
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX idx_cards_type ON cards(type);
CREATE INDEX idx_cards_rarity ON cards(rarity);
CREATE INDEX idx_cards_cost ON cards(cost);

-- 创建更新时间触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_cards_updated_at
  BEFORE UPDATE ON cards
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 启用行级安全 (RLS)
ALTER TABLE cards ENABLE ROW LEVEL SECURITY;

-- 创建策略：所有人都可以读取卡牌
CREATE POLICY "Anyone can read cards"
  ON cards
  FOR SELECT
  TO public
  USING (true);

-- 注释
COMMENT ON TABLE cards IS '游戏卡牌数据表';
COMMENT ON COLUMN cards.id IS '卡牌唯一标识';
COMMENT ON COLUMN cards.name IS '卡牌名称';
COMMENT ON COLUMN cards.type IS '卡牌类型：技能/攻击/能力/资源';
COMMENT ON COLUMN cards.rarity IS '稀有度：普通/稀有/史诗/传说';
COMMENT ON COLUMN cards.cost IS '能量消耗';
COMMENT ON COLUMN cards.description IS '卡牌描述';
COMMENT ON COLUMN cards.icon IS '卡牌图标emoji';
COMMENT ON COLUMN cards.effect_type IS '效果类型';
COMMENT ON COLUMN cards.effect_value IS '效果数值';
COMMENT ON COLUMN cards.target_type IS '目标类型';
COMMENT ON COLUMN cards.exhausts IS '是否打出后移除';
COMMENT ON COLUMN cards.ethereal IS '是否回合结束消失';
COMMENT ON COLUMN cards.buff_data IS 'Buff数据（JSON格式）';


