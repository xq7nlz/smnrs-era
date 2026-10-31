--- @class Hero50012_BattleListener
Hero50012_BattleListener = Class(Hero50012_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero50012_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_1 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50012_BattleListener:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero50012_BattleListener:OnEndBattleTurn(turn)
    if self.skill_1 ~= nil then
        self.skill_1:OnEndBattleTurn()
    end
end
