--- @class Hero50004_BattleListener
Hero50004_BattleListener = Class(Hero50004_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero50004_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50004_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param round BattleRound
function Hero50004_BattleListener:OnStartBattleRound(round)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round.round)
    end
end