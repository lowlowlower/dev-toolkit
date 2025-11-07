import { useEffect } from 'react'
import { useGameState } from './hooks/useGameState'
import GameCard from './components/GameCard'
import './App.css'

function App() {
  const {
    gameState,
    drawPile,
    hand,
    discardPile,
    exhaustPile,
    playCard,
    endTurn,
    startNewGame,
    cardsLoading
  } = useGameState()

  useEffect(() => {
    // 等待卡牌加载完成后再开始游戏
    if (!cardsLoading) {
      startNewGame()
    }
  }, [cardsLoading])

  const handlePlayCard = (card: any) => {
    const result = playCard(card)
    if (!result.success) {
      alert(result.message)
    }
  }

  const progressPercent = (gameState.projectProgress / gameState.projectGoal) * 100

  // 显示加载状态
  if (cardsLoading) {
    return (
      <div className="game-container" style={{ 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'center',
        minHeight: '100vh'
      }}>
        <div style={{ textAlign: 'center' }}>
          <h2>🎴 正在加载卡牌...</h2>
          <p>请稍候</p>
        </div>
      </div>
    )
  }

  return (
    <div className="game-container">
      {/* 顶部状态栏 */}
      <div className="top-bar">
        <div className="stats-left">
          <div className="stat-item hp">
            <span className="stat-icon">❤️</span>
            <span className="stat-value">{gameState.hp}/{gameState.maxHp}</span>
          </div>
          <div className="stat-item block">
            <span className="stat-icon">🛡️</span>
            <span className="stat-value">{gameState.block}</span>
          </div>
        </div>

        <div className="stats-center">
          <div className="turn-counter">
            <span>回合 {gameState.turn}</span>
          </div>
        </div>

        <div className="stats-right">
          <div className="stat-item energy">
            <span className="stat-icon">⚡</span>
            <span className="stat-value">{gameState.energy}/{gameState.maxEnergy}</span>
          </div>
          <button className="menu-btn" onClick={startNewGame}>
            🔄 重新开始
          </button>
        </div>
      </div>

      {/* 游戏主区域 */}
      <div className="game-main">
        {/* 左侧 - 牌堆信息 */}
        <div className="pile-area">
          <div className="pile-info">
            <div className="pile-card draw-pile">
              <div className="pile-icon">🎴</div>
              <div className="pile-count">{drawPile.length}</div>
              <div className="pile-label">抽牌堆</div>
            </div>
            <div className="pile-card discard-pile" onClick={() => {
              if (discardPile.length > 0) {
                alert(`弃牌堆: ${discardPile.map(c => c.name).join(', ')}`)
              }
            }}>
              <div className="pile-icon">♻️</div>
              <div className="pile-count">{discardPile.length}</div>
              <div className="pile-label">弃牌堆</div>
            </div>
            {exhaustPile.length > 0 && (
              <div className="pile-card exhaust-pile">
                <div className="pile-icon">❌</div>
                <div className="pile-count">{exhaustPile.length}</div>
                <div className="pile-label">消耗堆</div>
              </div>
            )}
          </div>
        </div>

        {/* 中间 - 项目进度 */}
        <div className="battlefield">
          <div className="project-area">
            <h2>🎯 项目目标</h2>
            <div className="progress-container">
              <div className="progress-bar">
                <div 
                  className="progress-fill"
                  style={{ width: `${progressPercent}%` }}
                >
                  <span className="progress-text">
                    {gameState.projectProgress} / {gameState.projectGoal}
                  </span>
                </div>
              </div>
            </div>

            {gameState.projectProgress >= gameState.projectGoal && (
              <div className="victory-banner">
                <h1>🎉 项目完成！</h1>
                <p>恭喜你完成了这个项目！</p>
                <button className="victory-btn" onClick={startNewGame}>
                  开始新项目
                </button>
              </div>
            )}
          </div>
        </div>

        {/* 右侧 - 帮助信息 */}
        <div className="help-area">
          <div className="help-panel">
            <h3>📘 游戏说明</h3>
            <div className="help-content">
              <p><strong>目标:</strong> 推进项目到 100 点</p>
              <p><strong>能量:</strong> 打牌需要消耗能量</p>
              <p><strong>回合:</strong> 每回合抽 5 张牌</p>
              <p><strong>卡牌类型:</strong></p>
              <ul>
                <li>🔴 攻击 - 推进项目</li>
                <li>🟢 技能 - 防御/抽牌</li>
                <li>🟣 能力 - 持续效果</li>
                <li>🟡 资源 - 获得能量</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      {/* 底部 - 手牌区 */}
      <div className="hand-area">
        <div className="hand-container">
          {hand.length === 0 && (
            <div className="empty-hand">
              <p>手牌已空</p>
              <button className="end-turn-btn-alt" onClick={endTurn}>
                结束回合
              </button>
            </div>
          )}
          {hand.map((card) => (
            <GameCard
              key={card.instanceId}
              card={card}
              onClick={() => handlePlayCard(card)}
              disabled={gameState.energy < card.cost}
              inHand={true}
            />
          ))}
        </div>
        <button 
          className="end-turn-btn"
          onClick={endTurn}
        >
          结束回合 ⏭️
        </button>
      </div>
    </div>
  )
}

export default App
