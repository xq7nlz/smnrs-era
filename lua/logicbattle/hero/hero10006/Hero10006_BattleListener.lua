--- @class Hero10006_BattleListener
Hero10006_BattleListener = Class(Hero10006_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero10006_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10006_BattleListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param round BattleRound
function Hero10006_BattleListener:OnStartBattleRound(round)
    if self.skill_2 ~= nil then
        self.skill_2:OnStartBattleRound(round)
    end
end