--- @class Hero30026_BattleListener : BattleListener
Hero30026_BattleListener = Class(Hero30026_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero30026_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_1 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30026_BattleListener:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero30026_BattleListener:OnEndBattleTurn(turn)
    if self.skill_1 ~= nil then
        self.skill_1:OnEndBattleTurn(turn)
    end
end