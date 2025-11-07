import type { BusinessCard, CardCombination, WorkflowTemplate } from './supabase'

// 模拟 Supabase 客户端
class MockSupabase {
  private cards: BusinessCard[]
  private combinations: CardCombination[]
  private workflows: WorkflowTemplate[]

  constructor() {
    // 尝试从 localStorage 恢复数据
    const savedCards = localStorage.getItem('business_cards')
    const savedCombinations = localStorage.getItem('card_combinations')
    const savedWorkflows = localStorage.getItem('workflow_templates')

    if (savedCards) {
      try {
        this.cards = JSON.parse(savedCards)
      } catch (e) {
        console.error('Failed to load saved cards', e)
        this.cards = this.getDefaultCards()
      }
    } else {
      this.cards = this.getDefaultCards()
    }

    if (savedCombinations) {
      try {
        this.combinations = JSON.parse(savedCombinations)
      } catch (e) {
        console.error('Failed to load saved combinations', e)
        this.combinations = []
      }
    } else {
      this.combinations = []
    }

    if (savedWorkflows) {
      try {
        this.workflows = JSON.parse(savedWorkflows)
      } catch (e) {
        console.error('Failed to load saved workflows', e)
        this.workflows = this.getDefaultWorkflows()
      }
    } else {
      this.workflows = this.getDefaultWorkflows()
    }
  }

  private getDefaultCards(): BusinessCard[] {
    return [
      // 核心能力卡 (Core)
      {
        id: '1',
        title: '创意灵感',
        description: '源源不断的创新想法，激发团队创造力',
        category: 'core',
        icon: '💡',
        color: '#f59e0b',
        position_x: 100,
        position_y: 100,
        z_index: 1,
        rarity: 'epic',
        level: 3,
        skill_power: 85,
        synergy_tags: ['innovation', 'creativity', 'thinking'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '2',
        title: '团队协作',
        description: '优秀的团队配合能力，1+1>2的效果',
        category: 'core',
        icon: '👥',
        color: '#3b82f6',
        position_x: 300,
        position_y: 100,
        z_index: 1,
        rarity: 'rare',
        level: 2,
        skill_power: 70,
        synergy_tags: ['teamwork', 'communication', 'synergy'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '3',
        title: '专注力',
        description: '深度工作，排除干扰，高效完成任务',
        category: 'core',
        icon: '🎯',
        color: '#8b5cf6',
        position_x: 500,
        position_y: 100,
        z_index: 1,
        rarity: 'epic',
        level: 4,
        skill_power: 90,
        synergy_tags: ['focus', 'productivity', 'efficiency'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '4',
        title: '客户关系',
        description: '维护良好的客户关系，建立信任',
        category: 'core',
        icon: '🤝',
        color: '#06b6d4',
        position_x: 700,
        position_y: 100,
        z_index: 1,
        rarity: 'rare',
        level: 2,
        skill_power: 75,
        synergy_tags: ['relationship', 'trust', 'service'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      // 策略能力卡 (Strategy)
      {
        id: '5',
        title: '市场洞察',
        description: '深刻理解市场需求和趋势',
        category: 'strategy',
        icon: '🔍',
        color: '#10b981',
        position_x: 100,
        position_y: 300,
        z_index: 1,
        rarity: 'rare',
        level: 3,
        skill_power: 80,
        synergy_tags: ['analysis', 'market', 'insight'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '6',
        title: '品牌建设',
        description: '建立强大的品牌影响力和认知度',
        category: 'strategy',
        icon: '🏆',
        color: '#ef4444',
        position_x: 300,
        position_y: 300,
        z_index: 1,
        rarity: 'epic',
        level: 3,
        skill_power: 85,
        synergy_tags: ['branding', 'marketing', 'influence'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '7',
        title: '战略规划',
        description: '制定长远目标和实现路径',
        category: 'strategy',
        icon: '🗺️',
        color: '#8b5cf6',
        position_x: 500,
        position_y: 300,
        z_index: 1,
        rarity: 'legendary',
        level: 5,
        skill_power: 95,
        synergy_tags: ['planning', 'strategy', 'vision'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '8',
        title: '竞争分析',
        description: '了解对手，找到差异化优势',
        category: 'strategy',
        icon: '⚔️',
        color: '#f59e0b',
        position_x: 700,
        position_y: 300,
        z_index: 1,
        rarity: 'rare',
        level: 2,
        skill_power: 70,
        synergy_tags: ['competition', 'analysis', 'positioning'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      // 执行能力卡 (Execution)
      {
        id: '9',
        title: '技术实力',
        description: '强大的技术实现和开发能力',
        category: 'execution',
        icon: '⚙️',
        color: '#8b5cf6',
        position_x: 100,
        position_y: 500,
        z_index: 1,
        rarity: 'epic',
        level: 4,
        skill_power: 90,
        synergy_tags: ['technology', 'development', 'implementation'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '10',
        title: '执行力',
        description: '强大的执行和落地能力，说干就干',
        category: 'execution',
        icon: '⚡',
        color: '#ec4899',
        position_x: 300,
        position_y: 500,
        z_index: 1,
        rarity: 'legendary',
        level: 5,
        skill_power: 95,
        synergy_tags: ['execution', 'action', 'delivery'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '11',
        title: '质量管理',
        description: '确保产出高质量的成果',
        category: 'execution',
        icon: '✓',
        color: '#10b981',
        position_x: 500,
        position_y: 500,
        z_index: 1,
        rarity: 'rare',
        level: 3,
        skill_power: 80,
        synergy_tags: ['quality', 'excellence', 'standards'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '12',
        title: '敏捷迭代',
        description: '快速响应变化，持续改进优化',
        category: 'execution',
        icon: '🔄',
        color: '#3b82f6',
        position_x: 700,
        position_y: 500,
        z_index: 1,
        rarity: 'epic',
        level: 3,
        skill_power: 85,
        synergy_tags: ['agile', 'iteration', 'improvement'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      // 资源能力卡 (Resource)
      {
        id: '13',
        title: '资金支持',
        description: '充足的资金保障和财务管理',
        category: 'resource',
        icon: '💰',
        color: '#f59e0b',
        position_x: 100,
        position_y: 700,
        z_index: 1,
        rarity: 'rare',
        level: 2,
        skill_power: 75,
        synergy_tags: ['finance', 'funding', 'capital'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '14',
        title: '时间管理',
        description: '合理分配时间，提高效率',
        category: 'resource',
        icon: '⏰',
        color: '#ef4444',
        position_x: 300,
        position_y: 700,
        z_index: 1,
        rarity: 'epic',
        level: 4,
        skill_power: 88,
        synergy_tags: ['time', 'scheduling', 'efficiency'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '15',
        title: '人脉资源',
        description: '广泛的人际网络和资源整合',
        category: 'resource',
        icon: '🌐',
        color: '#06b6d4',
        position_x: 500,
        position_y: 700,
        z_index: 1,
        rarity: 'rare',
        level: 3,
        skill_power: 77,
        synergy_tags: ['network', 'connections', 'resources'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '16',
        title: '工具赋能',
        description: '使用先进工具提升生产力',
        category: 'resource',
        icon: '🛠️',
        color: '#8b5cf6',
        position_x: 700,
        position_y: 700,
        z_index: 1,
        rarity: 'common',
        level: 2,
        skill_power: 65,
        synergy_tags: ['tools', 'automation', 'productivity'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      // 成长能力卡 (Growth)
      {
        id: '17',
        title: '持续学习',
        description: '不断学习新知识和适应变化',
        category: 'growth',
        icon: '📚',
        color: '#6366f1',
        position_x: 900,
        position_y: 100,
        z_index: 1,
        rarity: 'epic',
        level: 4,
        skill_power: 87,
        synergy_tags: ['learning', 'growth', 'adaptation'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '18',
        title: '导师指导',
        description: '获得经验丰富的导师指导',
        category: 'growth',
        icon: '🎓',
        color: '#10b981',
        position_x: 900,
        position_y: 300,
        z_index: 1,
        rarity: 'rare',
        level: 2,
        skill_power: 72,
        synergy_tags: ['mentorship', 'guidance', 'wisdom'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '19',
        title: '复盘总结',
        description: '定期回顾总结，提炼经验教训',
        category: 'growth',
        icon: '📝',
        color: '#f59e0b',
        position_x: 900,
        position_y: 500,
        z_index: 1,
        rarity: 'common',
        level: 2,
        skill_power: 68,
        synergy_tags: ['reflection', 'review', 'learning'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '20',
        title: '突破创新',
        description: '敢于尝试新事物，突破舒适区',
        category: 'growth',
        icon: '🚀',
        color: '#ec4899',
        position_x: 900,
        position_y: 700,
        z_index: 1,
        rarity: 'legendary',
        level: 5,
        skill_power: 92,
        synergy_tags: ['innovation', 'breakthrough', 'courage'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      }
    ]
  }

  private getDefaultWorkflows(): WorkflowTemplate[] {
    return [
      {
        id: 'w1',
        name: '高效工作日',
        description: '专注完成重要任务的日常工作流程',
        category: 'daily',
        card_ids: ['3', '14', '10'],
        difficulty: 'easy',
        estimated_time: 480,
        icon: '📅',
        color: '#3b82f6',
        created_at: new Date().toISOString()
      },
      {
        id: 'w2',
        name: '产品开发冲刺',
        description: '快速开发和迭代产品的完整流程',
        category: 'project',
        card_ids: ['9', '12', '2', '11'],
        difficulty: 'hard',
        estimated_time: 720,
        icon: '💻',
        color: '#8b5cf6',
        created_at: new Date().toISOString()
      },
      {
        id: 'w3',
        name: '市场营销方案',
        description: '制定并执行市场营销策略',
        category: 'business',
        card_ids: ['5', '6', '4', '1'],
        difficulty: 'medium',
        estimated_time: 360,
        icon: '📈',
        color: '#10b981',
        created_at: new Date().toISOString()
      },
      {
        id: 'w4',
        name: '个人成长计划',
        description: '持续学习和自我提升的路径',
        category: 'learning',
        card_ids: ['17', '18', '19', '20'],
        difficulty: 'medium',
        estimated_time: 240,
        icon: '🌱',
        color: '#f59e0b',
        created_at: new Date().toISOString()
      },
      {
        id: 'w5',
        name: '创业启动包',
        description: '创业初期必备的核心能力组合',
        category: 'business',
        card_ids: ['1', '10', '13', '5', '7'],
        difficulty: 'hard',
        estimated_time: 1440,
        icon: '🎯',
        color: '#ef4444',
        created_at: new Date().toISOString()
      }
    ]
  }

  from(table: string) {
    if (table === 'business_cards') {
      return {
        select: (columns: string) => ({
          order: (column: string, options?: { ascending: boolean }) => Promise.resolve({
            data: this.cards,
            error: null
          })
        }),
        update: (data: Partial<BusinessCard>) => ({
          eq: (column: string, value: string) => {
            const index = this.cards.findIndex(c => (c as any)[column] === value)
            if (index !== -1) {
              this.cards[index] = { ...this.cards[index], ...data, updated_at: new Date().toISOString() }
              localStorage.setItem('business_cards', JSON.stringify(this.cards))
            }
            return Promise.resolve({ data: this.cards[index] || null, error: null })
          }
        })
      }
    } else if (table === 'card_combinations') {
      return {
        select: (columns: string) => Promise.resolve({
          data: this.combinations,
          error: null
        }),
        insert: (data: any) => ({
          select: () => ({
            single: () => {
              const newCombo: CardCombination = {
                id: Date.now().toString(),
                synergy_bonus: 0,
                combo_effect: null,
                is_active: true,
                ...data,
                created_at: new Date().toISOString()
              }
              this.combinations.push(newCombo)
              localStorage.setItem('card_combinations', JSON.stringify(this.combinations))
              return Promise.resolve({ data: newCombo, error: null })
            }
          })
        })
      }
    } else if (table === 'workflow_templates') {
      return {
        select: (columns: string) => Promise.resolve({
          data: this.workflows,
          error: null
        })
      }
    }
    
    return {
      select: () => Promise.resolve({ data: [], error: null })
    }
  }
}

export const supabase = new MockSupabase() as any
