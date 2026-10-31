--- @class Hero60001_BattleListener
Hero60001_BattleListener = Class(Hero60001_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero60001_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60001_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param round BattleRound
function Hero60001_BattleListener:OnStartBattleRound(round)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero60001_BattleListener:OnStartBattleTurn(turn)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleTurn(turn)
    end
end