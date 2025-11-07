import { useDrag } from 'react-dnd'
import { motion } from 'framer-motion'
import { BusinessCard } from '../lib/supabase'
import './BusinessCard.css'

interface BusinessCardProps {
  card: BusinessCard
  onDrop: (cardId: string, x: number, y: number) => void
  isSelected: boolean
  onSelect: () => void
}

export default function BusinessCardComponent({
  card,
  onDrop,
  isSelected,
  onSelect
}: BusinessCardProps) {
  const [{ isDragging }, drag] = useDrag(() => ({
    type: 'card',
    item: { id: card.id, x: card.position_x, y: card.position_y },
    collect: (monitor) => ({
      isDragging: monitor.isDragging(),
    }),
  }))

  const handleMouseDown = (e: React.MouseEvent) => {
    if (e.button === 0) {
      const handleMouseMove = (moveEvent: MouseEvent) => {
        const newX = card.position_x + moveEvent.movementX
        const newY = card.position_y + moveEvent.movementY
        onDrop(card.id, newX, newY)
      }

      const handleMouseUp = () => {
        document.removeEventListener('mousemove', handleMouseMove)
        document.removeEventListener('mouseup', handleMouseUp)
      }

      document.addEventListener('mousemove', handleMouseMove)
      document.addEventListener('mouseup', handleMouseUp)
    }
  }

  const getRarityColor = (rarity: string) => {
    switch (rarity) {
      case 'common': return '#9ca3af'
      case 'rare': return '#3b82f6'
      case 'epic': return '#a855f7'
      case 'legendary': return '#f59e0b'
      default: return '#6b7280'
    }
  }

  const getRarityLabel = (rarity: string) => {
    switch (rarity) {
      case 'common': return '普通'
      case 'rare': return '稀有'
      case 'epic': return '史诗'
      case 'legendary': return '传说'
      default: return '未知'
    }
  }

  return (
    <motion.div
      ref={drag}
      className={`business-card rarity-${card.rarity} ${isSelected ? 'selected' : ''}`}
      style={{
        position: 'absolute',
        left: card.position_x,
        top: card.position_y,
        backgroundColor: card.color,
        opacity: isDragging ? 0.5 : 1,
        cursor: 'move',
        zIndex: isSelected ? 1000 : card.z_index,
        borderColor: getRarityColor(card.rarity),
        borderWidth: '3px',
        borderStyle: 'solid',
        boxShadow: `0 0 20px ${getRarityColor(card.rarity)}40`
      }}
      onMouseDown={handleMouseDown}
      onClick={onSelect}
      whileHover={{ scale: 1.05, boxShadow: `0 0 30px ${getRarityColor(card.rarity)}60` }}
      whileTap={{ scale: 0.95 }}
      initial={{ opacity: 0, scale: 0.8 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ duration: 0.2 }}
    >
      <div className="card-header">
        <div className="card-rarity" style={{ color: getRarityColor(card.rarity) }}>
          {getRarityLabel(card.rarity)}
        </div>
        <div className="card-level">Lv.{card.level}</div>
      </div>
      
      <div className="card-icon">{card.icon || '💼'}</div>
      <div className="card-title">{card.title}</div>
      
      {card.description && (
        <div className="card-description">{card.description}</div>
      )}
      
      <div className="card-stats">
        <div className="stat-bar">
          <div className="stat-label">技能强度</div>
          <div className="stat-value">
            <div className="stat-progress" style={{ width: `${card.skill_power}%` }} />
            <span className="stat-number">{card.skill_power}</span>
          </div>
        </div>
      </div>
      
      <div className="card-category">{card.category}</div>
      
      {isSelected && (
        <motion.div
          className="card-glow"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.2 }}
        />
      )}
    </motion.div>
  )
}


