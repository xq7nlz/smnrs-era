--- @class Hero40009_BattleListener
Hero40009_BattleListener = Class(Hero40009_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero40009_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_1 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40009_BattleListener:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return void
--- @param round BattleRound
function Hero40009_BattleListener:OnStartBattleRound(round)
    if self.skill_1 ~= nil then
        self.skill_1:OnStartBattleRound(round)
    end
end