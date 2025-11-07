import { Card } from '../types/card'

// 卡牌库 - 事业发展主题
export const CARD_DATABASE: Card[] = [
  // 攻击牌 - 推进项目
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
  },
  {
    id: 'attack_sprint',
    name: '敏捷冲刺',
    type: 'attack',
    rarity: 'common',
    cost: 2,
    description: '推进项目进度 12点',
    icon: '🏃',
    effect: { type: 'damage', value: 12 },
    targetType: 'enemy'
  },
  {
    id: 'attack_innovation',
    name: '创新突破',
    type: 'attack',
    rarity: 'rare',
    cost: 2,
    description: '推进项目进度 15点，抽1张牌',
    icon: '💡',
    effect: { type: 'damage', value: 15 },
    targetType: 'enemy'
  },
  {
    id: 'attack_team',
    name: '团队协作',
    type: 'attack',
    rarity: 'epic',
    cost: 3,
    description: '推进项目进度 20点，获得5点防御',
    icon: '👥',
    effect: { type: 'damage', value: 20 },
    targetType: 'enemy'
  },

  // 防御牌 - 风险管理
  {
    id: 'skill_prepare',
    name: '充分准备',
    type: 'skill',
    rarity: 'common',
    cost: 1,
    description: '获得 5点 风险防御',
    icon: '🛡️',
    effect: { type: 'block', value: 5 },
    targetType: 'self'
  },
  {
    id: 'skill_plan',
    name: '战略规划',
    type: 'skill',
    rarity: 'rare',
    cost: 2,
    description: '获得 12点 风险防御',
    icon: '🗺️',
    effect: { type: 'block', value: 12 },
    targetType: 'self'
  },
  {
    id: 'skill_quality',
    name: '质量把控',
    type: 'skill',
    rarity: 'epic',
    cost: 1,
    description: '获得 8点 风险防御，抽1张牌',
    icon: '✓',
    effect: { type: 'block', value: 8 },
    targetType: 'self'
  },

  // 技能牌 - 抽牌和资源
  {
    id: 'skill_study',
    name: '持续学习',
    type: 'skill',
    rarity: 'common',
    cost: 1,
    description: '抽 2张 牌',
    icon: '📚',
    effect: { type: 'draw', value: 2 },
    targetType: 'none'
  },
  {
    id: 'skill_insight',
    name: '市场洞察',
    type: 'skill',
    rarity: 'rare',
    cost: 0,
    description: '抽 1张 牌，获得1点能量',
    icon: '🔍',
    effect: { type: 'draw', value: 1 },
    targetType: 'none'
  },
  {
    id: 'skill_mentor',
    name: '导师指导',
    type: 'skill',
    rarity: 'epic',
    cost: 2,
    description: '抽 3张 牌，获得5点防御',
    icon: '🎓',
    effect: { type: 'draw', value: 3 },
    targetType: 'none'
  },

  // 能力牌 - 持续效果
  {
    id: 'power_focus',
    name: '专注力',
    type: 'power',
    rarity: 'rare',
    cost: 1,
    description: '每回合开始时，获得2点能量',
    icon: '🎯',
    effect: { 
      type: 'buff', 
      value: 2,
      buff: {
        name: '专注',
        duration: 999,
        power: 2
      }
    },
    targetType: 'self'
  },
  {
    id: 'power_passion',
    name: '激情驱动',
    type: 'power',
    rarity: 'epic',
    cost: 2,
    description: '每回合额外推进项目 3点',
    icon: '🔥',
    effect: { 
      type: 'buff', 
      value: 3,
      buff: {
        name: '激情',
        duration: 999,
        power: 3
      }
    },
    targetType: 'self'
  },
  {
    id: 'power_network',
    name: '人脉资源',
    type: 'power',
    rarity: 'rare',
    cost: 1,
    description: '每回合开始时，抽1张牌',
    icon: '🌐',
    effect: { 
      type: 'buff', 
      value: 1,
      buff: {
        name: '人脉',
        duration: 999,
        power: 1
      }
    },
    targetType: 'self'
  },

  // 资源牌
  {
    id: 'resource_funding',
    name: '资金支持',
    type: 'resource',
    rarity: 'common',
    cost: 0,
    description: '获得 1点 能量',
    icon: '💰',
    effect: { type: 'energy', value: 1 },
    targetType: 'none',
    exhausts: true
  },
  {
    id: 'resource_tools',
    name: '工具赋能',
    type: 'resource',
    rarity: 'rare',
    cost: 0,
    description: '获得 2点 能量，抽1张牌',
    icon: '🛠️',
    effect: { type: 'energy', value: 2 },
    targetType: 'none',
    exhausts: true
  },

  // 传说牌
  {
    id: 'legendary_vision',
    name: '战略愿景',
    type: 'power',
    rarity: 'legendary',
    cost: 3,
    description: '每回合推进项目 5点，抽1张牌，获得3点防御',
    icon: '🌟',
    effect: { 
      type: 'buff', 
      value: 5,
      buff: {
        name: '愿景',
        duration: 999,
        power: 5
      }
    },
    targetType: 'self'
  },
  {
    id: 'legendary_breakthrough',
    name: '突破创新',
    type: 'attack',
    rarity: 'legendary',
    cost: 4,
    description: '推进项目进度 40点',
    icon: '🚀',
    effect: { type: 'damage', value: 40 },
    targetType: 'enemy'
  }
]

// 获取稀有度颜色
export function getRarityColor(rarity: string): string {
  switch (rarity) {
    case 'common': return '#9ca3af'
    case 'rare': return '#3b82f6'
    case 'epic': return '#a855f7'
    case 'legendary': return '#f59e0b'
    default: return '#6b7280'
  }
}

// 获取卡牌类型颜色
export function getCardTypeColor(type: string): string {
  switch (type) {
    case 'attack': return '#ef4444'
    case 'skill': return '#10b981'
    case 'power': return '#8b5cf6'
    case 'resource': return '#f59e0b'
    default: return '#6b7280'
  }
}

