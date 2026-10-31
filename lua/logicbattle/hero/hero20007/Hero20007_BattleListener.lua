--- @class Hero20007_BattleListener
Hero20007_BattleListener = Class(Hero20007_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero20007_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20007_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param round BattleRound
function Hero20007_BattleListener:OnStartBattleRound(round)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round)
    end
end