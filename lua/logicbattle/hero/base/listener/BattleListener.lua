--- @class BattleListener
BattleListener = Class(BattleListener)

--- @return void
--- @param hero BaseHero
function BattleListener:Ctor(hero)
    --- @type BaseHero
    self.myHero = hero
end

---------------------------------------- Battle Round ----------------------------------------
--- @return void
--- @param round BattleRound
function BattleListener:OnStartBattleRound(round)
    --assert(round ~= nil)
end

--- @return void
--- @param round BattleRound
function BattleListener:OnEndBattleRound(round)
    --assert(round ~= nil)
end

---------------------------------------- Battle Turn ----------------------------------------
--- @return void
--- @param turn BattleTurn
function BattleListener:OnStartBattleTurn(turn)
    --assert(turn ~= nil)
end

--- @return void
--- @param turn BattleTurn
function BattleListener:OnEndBattleTurn(turn)
    --assert(turn ~= nil)
end