--- @class Hero20006_BattleListener
Hero20006_BattleListener = Class(Hero20006_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero20006_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20006_BattleListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param round BattleRound
function Hero20006_BattleListener:OnStartBattleRound(round)
    if self.skill_3 ~= nil then
        self.skill_3:OnStartBattleRound(round)
    end
end