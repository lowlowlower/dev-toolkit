import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { WorkflowTemplate, BusinessCard } from '../lib/supabase'
import './WorkflowPanel.css'

interface WorkflowPanelProps {
  workflows: WorkflowTemplate[]
  cards: BusinessCard[]
  onApplyWorkflow: (workflow: WorkflowTemplate) => void
  isOpen: boolean
  onToggle: () => void
}

export default function WorkflowPanel({ workflows, cards, onApplyWorkflow, isOpen, onToggle }: WorkflowPanelProps) {
  const [selectedWorkflow, setSelectedWorkflow] = useState<string | null>(null)

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'easy': return '#10b981'
      case 'medium': return '#f59e0b'
      case 'hard': return '#ef4444'
      default: return '#6b7280'
    }
  }

  const getDifficultyLabel = (difficulty: string) => {
    switch (difficulty) {
      case 'easy': return '简单'
      case 'medium': return '中等'
      case 'hard': return '困难'
      default: return '未知'
    }
  }

  const getCategoryIcon = (category: string) => {
    switch (category) {
      case 'daily': return '📅'
      case 'project': return '💻'
      case 'learning': return '🌱'
      case 'business': return '📈'
      default: return '📋'
    }
  }

  const formatTime = (minutes: number | null) => {
    if (!minutes) return '未知'
    if (minutes < 60) return `${minutes}分钟`
    const hours = Math.floor(minutes / 60)
    const mins = minutes % 60
    return mins > 0 ? `${hours}小时${mins}分钟` : `${hours}小时`
  }

  const getWorkflowCards = (workflow: WorkflowTemplate) => {
    return workflow.card_ids
      .map(id => cards.find(c => c.id === id))
      .filter(Boolean) as BusinessCard[]
  }

  return (
    <>
      <button 
        className={`workflow-toggle ${isOpen ? 'open' : ''}`}
        onClick={onToggle}
        title="工作流模板"
      >
        <span className="toggle-icon">📚</span>
        <span className="toggle-label">工作流</span>
      </button>

      <AnimatePresence>
        {isOpen && (
          <motion.div
            className="workflow-panel"
            initial={{ x: 300, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
            exit={{ x: 300, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 300, damping: 30 }}
          >
            <div className="workflow-header">
              <h2>🎯 工作流模板</h2>
              <p className="workflow-subtitle">选择预设的高效组合</p>
            </div>

            <div className="workflow-list">
              {workflows.map(workflow => {
                const workflowCards = getWorkflowCards(workflow)
                const isSelected = selectedWorkflow === workflow.id

                return (
                  <motion.div
                    key={workflow.id}
                    className={`workflow-item ${isSelected ? 'selected' : ''}`}
                    onClick={() => setSelectedWorkflow(isSelected ? null : workflow.id)}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <div className="workflow-item-header">
                      <div className="workflow-icon" style={{ backgroundColor: workflow.color }}>
                        {workflow.icon || getCategoryIcon(workflow.category)}
                      </div>
                      <div className="workflow-title-section">
                        <h3 className="workflow-name">{workflow.name}</h3>
                        <div className="workflow-badges">
                          <span 
                            className="difficulty-badge"
                            style={{ backgroundColor: getDifficultyColor(workflow.difficulty) }}
                          >
                            {getDifficultyLabel(workflow.difficulty)}
                          </span>
                          <span className="time-badge">
                            ⏰ {formatTime(workflow.estimated_time)}
                          </span>
                        </div>
                      </div>
                    </div>

                    {workflow.description && (
                      <p className="workflow-description">{workflow.description}</p>
                    )}

                    <div className="workflow-cards">
                      <div className="cards-label">包含卡片:</div>
                      <div className="cards-grid">
                        {workflowCards.map(card => (
                          <div 
                            key={card.id}
                            className="mini-card"
                            style={{ 
                              backgroundColor: card.color,
                              borderColor: card.rarity === 'legendary' ? '#f59e0b' : 
                                          card.rarity === 'epic' ? '#a855f7' : 
                                          card.rarity === 'rare' ? '#3b82f6' : '#9ca3af'
                            }}
                            title={card.title}
                          >
                            <span className="mini-card-icon">{card.icon}</span>
                            <span className="mini-card-title">{card.title}</span>
                          </div>
                        ))}
                      </div>
                    </div>

                    <button
                      className="apply-workflow-btn"
                      onClick={(e) => {
                        e.stopPropagation()
                        onApplyWorkflow(workflow)
                      }}
                    >
                      ✨ 应用此工作流
                    </button>
                  </motion.div>
                )
              })}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  )
}

