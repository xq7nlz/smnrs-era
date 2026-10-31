--- @class Hero40006_BattleListener
Hero40006_BattleListener = Class(Hero40006_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero40006_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40006_BattleListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero40006_BattleListener:OnStartBattleTurn(turn)
    if self.skill_2 ~= nil then
        self.skill_2:OnStartBattleTurn(turn)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero40006_BattleListener:OnEndBattleTurn(turn)
    if self.skill_2 ~= nil then
        self.skill_2:OnEndBattleTurn(turn)
    end
end