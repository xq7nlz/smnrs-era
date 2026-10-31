--- @class Hero50005_BattleListener
Hero50005_BattleListener = Class(Hero50005_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero50005_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50005_BattleListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero50005_BattleListener:OnStartBattleTurn(turn)
    if self.skill_3 ~= nil then
        self.skill_3:OnStartBattleTurn(turn)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero50005_BattleListener:OnEndBattleTurn(turn)
    if self.skill_3 ~= nil then
        self.skill_3:OnEndBattleTurn(turn)
    end
end