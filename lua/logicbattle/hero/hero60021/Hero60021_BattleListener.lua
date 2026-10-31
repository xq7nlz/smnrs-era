--- @class Hero60021_BattleListener
Hero60021_BattleListener = Class(Hero60021_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero60021_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60021_BattleListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param round BattleRound
function Hero60021_BattleListener:OnStartBattleRound(round)
    if self.skill_2 ~= nil then
        self.skill_2:OnStartBattleRound(round)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero60021_BattleListener:OnStartBattleTurn(turn)
    if self.skill_2 ~= nil then
        self.skill_2:OnStartBattleTurn(turn)
    end
end