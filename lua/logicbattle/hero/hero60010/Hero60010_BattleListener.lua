--- @class Hero60010_BattleListener
Hero60010_BattleListener = Class(Hero60010_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero60010_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60010_BattleListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param round BattleRound
function Hero60010_BattleListener:OnStartBattleRound(round)
    if self.skill_2 ~= nil then
        self.skill_2:OnStartBattleRound(round.round)
    end
end