import { useState, useCallback } from 'react'
import { Card, GameCard } from '../types/card'
import { CARD_DATABASE } from '../data/cards'
import { useCards } from './useCards'

interface GameState {
  energy: number
  maxEnergy: number
  hp: number
  maxHp: number
  block: number
  turn: number
  projectProgress: number
  projectGoal: number
}

export function useGameState() {
  // 从数据库加载卡牌
  const { cards: dbCards, loading: cardsLoading } = useCards()
  
  // 游戏状态
  const [gameState, setGameState] = useState<GameState>({
    energy: 3,
    maxEnergy: 3,
    hp: 80,
    maxHp: 80,
    block: 0,
    turn: 1,
    projectProgress: 0,
    projectGoal: 100
  })

  // 牌堆
  const [drawPile, setDrawPile] = useState<GameCard[]>([])
  const [hand, setHand] = useState<GameCard[]>([])
  const [discardPile, setDiscardPile] = useState<GameCard[]>([])
  const [exhaustPile, setExhaustPile] = useState<GameCard[]>([])

  // 初始化牌库
  const initializeDeck = useCallback(() => {
    // 使用数据库卡牌或回退到本地数据
    const cardSource = dbCards.length > 0 ? dbCards : CARD_DATABASE
    
    console.log(`🎴 使用 ${dbCards.length > 0 ? '数据库' : '本地'} 卡牌数据，共 ${cardSource.length} 张`)
    
    const starterDeck: Card[] = [
      ...Array(5).fill(cardSource.find(c => c.id === 'attack_execute')),
      ...Array(5).fill(cardSource.find(c => c.id === 'skill_prepare')),
      ...Array(2).fill(cardSource.find(c => c.id === 'skill_study')),
      ...Array(1).fill(cardSource.find(c => c.id === 'attack_innovation')),
      ...Array(1).fill(cardSource.find(c => c.id === 'resource_funding')),
    ].filter(Boolean) as Card[]

    const gameCards: GameCard[] = starterDeck.map((card, index) => ({
      ...card,
      instanceId: `${card.id}_${index}_${Date.now()}`
    }))

    // 洗牌
    const shuffled = [...gameCards].sort(() => Math.random() - 0.5)
    setDrawPile(shuffled)
    setHand([])
    setDiscardPile([])
    setExhaustPile([])
  }, [dbCards])

  // 抽牌
  const drawCards = useCallback((count: number) => {
    setDrawPile(prev => {
      let newDrawPile = [...prev]
      let newHand = [...hand]
      let newDiscard = [...discardPile]

      for (let i = 0; i < count; i++) {
        // 如果抽牌堆为空，洗入弃牌堆
        if (newDrawPile.length === 0) {
          if (newDiscard.length === 0) break
          newDrawPile = [...newDiscard].sort(() => Math.random() - 0.5)
          newDiscard = []
        }

        const card = newDrawPile.pop()
        if (card) {
          // 检查是否虚无（Ethereal）
          if (card.ethereal) {
            card.ethereal = true
          }
          newHand.push(card)
        }
      }

      setHand(newHand)
      setDiscardPile(newDiscard)
      return newDrawPile
    })
  }, [hand, discardPile])

  // 打出卡牌
  const playCard = useCallback((card: GameCard) => {
    if (gameState.energy < card.cost) {
      return { success: false, message: '能量不足！' }
    }

    // 扣除能量
    setGameState(prev => ({
      ...prev,
      energy: prev.energy - card.cost
    }))

    // 移除手牌
    setHand(prev => prev.filter(c => c.instanceId !== card.instanceId))

    // 应用卡牌效果
    applyCardEffect(card)

    // 处理卡牌去向
    if (card.exhausts) {
      setExhaustPile(prev => [...prev, card])
    } else {
      setDiscardPile(prev => [...prev, card])
    }

    return { success: true, message: `打出 ${card.name}` }
  }, [gameState.energy])

  // 应用卡牌效果
  const applyCardEffect = useCallback((card: GameCard) => {
    const effect = card.effect

    switch (effect.type) {
      case 'damage':
        setGameState(prev => ({
          ...prev,
          projectProgress: Math.min(prev.projectProgress + effect.value, prev.projectGoal)
        }))
        break

      case 'block':
        setGameState(prev => ({
          ...prev,
          block: prev.block + effect.value
        }))
        break

      case 'draw':
        drawCards(effect.value)
        break

      case 'energy':
        setGameState(prev => ({
          ...prev,
          energy: prev.energy + effect.value
        }))
        break

      case 'heal':
        setGameState(prev => ({
          ...prev,
          hp: Math.min(prev.hp + effect.value, prev.maxHp)
        }))
        break
    }
  }, [drawCards])

  // 结束回合
  const endTurn = useCallback(() => {
    // 弃置所有手牌
    const cardsToDiscard = hand.filter(c => !c.ethereal)
    const etherealCards = hand.filter(c => c.ethereal)

    setDiscardPile(prev => [...prev, ...cardsToDiscard])
    setExhaustPile(prev => [...prev, ...etherealCards])
    setHand([])

    // 重置防御
    // 抽新手牌
    setGameState(prev => ({
      ...prev,
      energy: prev.maxEnergy,
      block: 0,
      turn: prev.turn + 1
    }))

    // 抽5张牌
    setTimeout(() => {
      drawCards(5)
    }, 100)
  }, [hand, drawCards])

  // 开始新游戏
  const startNewGame = useCallback(() => {
    initializeDeck()
    setGameState({
      energy: 3,
      maxEnergy: 3,
      hp: 80,
      maxHp: 80,
      block: 0,
      turn: 1,
      projectProgress: 0,
      projectGoal: 100
    })
    setTimeout(() => {
      drawCards(5)
    }, 100)
  }, [initializeDeck, drawCards])

  return {
    gameState,
    drawPile,
    hand,
    discardPile,
    exhaustPile,
    playCard,
    drawCards,
    endTurn,
    startNewGame,
    cardsLoading
  }
}

