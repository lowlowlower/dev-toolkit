// 卡牌类型定义
export type CardRarity = 'common' | 'rare' | 'epic' | 'legendary'
export type CardType = 'skill' | 'attack' | 'power' | 'resource'

export interface Card {
  id: string
  name: string
  type: CardType
  rarity: CardRarity
  cost: number // 能量消耗
  description: string
  icon: string
  effect: CardEffect
  targetType: 'self' | 'enemy' | 'all' | 'none'
  exhausts?: boolean // 打出后移除
  ethereal?: boolean // 回合结束消失
}

export interface CardEffect {
  type: 'damage' | 'block' | 'draw' | 'energy' | 'buff' | 'debuff' | 'heal'
  value: number
  buff?: {
    name: string
    duration: number
    power: number
  }
}

export interface GameCard extends Card {
  instanceId: string // 实例ID，用于区分同名卡牌
  upgraded?: boolean
  position?: { x: number; y: number }
}

export interface DeckCard {
  card: Card
  count: number
}


