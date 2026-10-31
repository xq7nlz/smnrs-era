--- @class Hero30013_BattleListener
Hero30013_BattleListener = Class(Hero30013_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero30013_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30013_BattleListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero30013_BattleListener:OnEndBattleTurn(turn)
    if self.skill_2 ~= nil then
        self.skill_2:OnEndBattleTurn(turn)
    end
end