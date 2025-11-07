export interface BusinessCard {
  id: string
  title: string
  description: string | null
  category: string
  icon: string | null
  color: string
  position_x: number
  position_y: number
  z_index: number
  rarity: 'common' | 'rare' | 'epic' | 'legendary'
  level: number
  skill_power: number
  synergy_tags: string[]
  created_at: string
  updated_at: string
}

export interface CardCombination {
  id: string
  card_id_1: string
  card_id_2: string
  combination_name: string | null
  description: string | null
  synergy_bonus: number
  combo_effect: string | null
  is_active: boolean
  created_at: string
}

export interface WorkflowTemplate {
  id: string
  name: string
  description: string | null
  category: 'daily' | 'project' | 'learning' | 'business'
  card_ids: string[]
  difficulty: 'easy' | 'medium' | 'hard'
  estimated_time: number | null
  icon: string | null
  color: string
  created_at: string
}

export interface UserProgress {
  id: string
  workflow_id: string
  status: 'pending' | 'in_progress' | 'completed'
  completion_date: string | null
  notes: string | null
  created_at: string
  updated_at: string
}

import { createClient } from '@supabase/supabase-js'
import { supabase as mockSupabase } from './supabase-mock'

// 检查是否使用模拟模式
const USE_MOCK = import.meta.env.VITE_USE_MOCK === 'true' || !import.meta.env.VITE_SUPABASE_URL

let supabaseClient: any

if (USE_MOCK) {
  // 使用模拟数据
  supabaseClient = mockSupabase
  console.log('📦 使用模拟数据模式（无需 Docker）')
} else {
  // 使用真实的 Supabase 本地开发环境
  const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'http://127.0.0.1:54321'
  const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH'
  supabaseClient = createClient(supabaseUrl, supabaseAnonKey)
  console.log('🗄️ 使用 Supabase 本地数据库')
}

export const supabase = supabaseClient
