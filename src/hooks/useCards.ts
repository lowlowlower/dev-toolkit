import { useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { Card, CardEffect } from '../types/card'

// 数据库中的卡牌数据类型
interface DbCard {
  id: string
  name: string
  type: 'skill' | 'attack' | 'power' | 'resource'
  rarity: 'common' | 'rare' | 'epic' | 'legendary'
  cost: number
  description: string
  icon: string
  effect_type: 'damage' | 'block' | 'draw' | 'energy' | 'buff' | 'debuff' | 'heal'
  effect_value: number
  target_type: 'self' | 'enemy' | 'all' | 'none'
  exhausts: boolean
  ethereal: boolean
  buff_data: {
    name: string
    duration: number
    power: number
  } | null
}

// 将数据库卡牌转换为游戏卡牌格式
function dbCardToGameCard(dbCard: DbCard): Card {
  const effect: CardEffect = {
    type: dbCard.effect_type,
    value: dbCard.effect_value,
  }

  // 如果有 buff 数据，添加到效果中
  if (dbCard.buff_data) {
    effect.buff = dbCard.buff_data
  }

  return {
    id: dbCard.id,
    name: dbCard.name,
    type: dbCard.type,
    rarity: dbCard.rarity,
    cost: dbCard.cost,
    description: dbCard.description,
    icon: dbCard.icon,
    effect,
    targetType: dbCard.target_type,
    exhausts: dbCard.exhausts || undefined,
    ethereal: dbCard.ethereal || undefined,
  }
}

export function useCards() {
  const [cards, setCards] = useState<Card[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    loadCards()
  }, [])

  async function loadCards() {
    try {
      setLoading(true)
      setError(null)

      const { data, error: fetchError } = await supabase
        .from('cards')
        .select('*')
        .order('rarity', { ascending: true })
        .order('cost', { ascending: true })

      if (fetchError) {
        throw fetchError
      }

      if (data) {
        const gameCards = data.map(dbCardToGameCard)
        setCards(gameCards)
        console.log(`✅ 从数据库加载了 ${gameCards.length} 张卡牌`)
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '加载卡牌失败'
      setError(errorMessage)
      console.error('❌ 加载卡牌错误:', err)
    } finally {
      setLoading(false)
    }
  }

  return {
    cards,
    loading,
    error,
    reloadCards: loadCards,
  }
}

// 获取单张卡牌
export async function getCardById(id: string): Promise<Card | null> {
  try {
    const { data, error } = await supabase
      .from('cards')
      .select('*')
      .eq('id', id)
      .single()

    if (error) throw error
    if (!data) return null

    return dbCardToGameCard(data as DbCard)
  } catch (err) {
    console.error('获取卡牌失败:', err)
    return null
  }
}

// 按类型获取卡牌
export async function getCardsByType(type: string): Promise<Card[]> {
  try {
    const { data, error } = await supabase
      .from('cards')
      .select('*')
      .eq('type', type)

    if (error) throw error
    if (!data) return []

    return data.map(dbCardToGameCard)
  } catch (err) {
    console.error('获取卡牌失败:', err)
    return []
  }
}

// 按稀有度获取卡牌
export async function getCardsByRarity(rarity: string): Promise<Card[]> {
  try {
    const { data, error } = await supabase
      .from('cards')
      .select('*')
      .eq('rarity', rarity)

    if (error) throw error
    if (!data) return []

    return data.map(dbCardToGameCard)
  } catch (err) {
    console.error('获取卡牌失败:', err)
    return []
  }
}


