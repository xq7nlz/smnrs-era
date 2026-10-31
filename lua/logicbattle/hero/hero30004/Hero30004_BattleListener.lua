--- @class Hero30004_BattleListener
Hero30004_BattleListener = Class(Hero30004_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero30004_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30004_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param round BattleRound
function Hero30004_BattleListener:OnStartBattleRound(round)

    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round)
    end
end