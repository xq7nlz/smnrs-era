--- @class Hero60011_BattleListener
Hero60011_BattleListener = Class(Hero60011_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero60011_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60011_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero60011_BattleListener:OnEndBattleTurn(turn)
    if self.skill_4 ~= nil then
        self.skill_4:OnEndBattleTurn(turn)
    end
end