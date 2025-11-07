import { motion } from 'framer-motion'
import { GameCard as GameCardType } from '../types/card'
import { getRarityColor, getCardTypeColor } from '../data/cards'
import './GameCard.css'

interface GameCardProps {
  card: GameCardType
  onClick?: () => void
  disabled?: boolean
  inHand?: boolean
}

export default function GameCard({ card, onClick, disabled, inHand }: GameCardProps) {
  const rarityColor = getRarityColor(card.rarity)
  const typeColor = getCardTypeColor(card.type)

  return (
    <motion.div
      className={`game-card ${disabled ? 'disabled' : ''} ${inHand ? 'in-hand' : ''}`}
      onClick={!disabled ? onClick : undefined}
      whileHover={!disabled ? { scale: 1.1, y: inHand ? -20 : 0 } : {}}
      whileTap={!disabled ? { scale: 0.95 } : {}}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      style={{
        borderColor: rarityColor,
        cursor: disabled ? 'not-allowed' : 'pointer'
      }}
    >
      {/* 卡牌顶部 - 费用 */}
      <div className="card-cost" style={{ backgroundColor: typeColor }}>
        {card.cost}
      </div>

      {/* 卡牌类型标签 */}
      <div className="card-type-badge" style={{ backgroundColor: typeColor }}>
        {card.type === 'attack' ? '攻击' :
         card.type === 'skill' ? '技能' :
         card.type === 'power' ? '能力' : '资源'}
      </div>

      {/* 卡牌图标 */}
      <div className="card-icon-large">
        {card.icon}
      </div>

      {/* 卡牌名称 */}
      <div className="card-name">
        {card.name}
      </div>

      {/* 卡牌描述 */}
      <div className="card-description">
        {card.description}
      </div>

      {/* 稀有度 */}
      <div className="card-rarity-indicator" style={{ backgroundColor: rarityColor }}>
        {card.rarity === 'legendary' && '★★★'}
        {card.rarity === 'epic' && '★★'}
        {card.rarity === 'rare' && '★'}
      </div>

      {/* 特殊标记 */}
      {card.exhausts && (
        <div className="card-badge exhausts">消耗</div>
      )}
      {card.ethereal && (
        <div className="card-badge ethereal">虚无</div>
      )}
    </motion.div>
  )
}

