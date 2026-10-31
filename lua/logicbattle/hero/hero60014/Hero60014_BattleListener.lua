--- @class Hero60014_BattleListener
Hero60014_BattleListener = Class(Hero60014_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero60014_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_1 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60014_BattleListener:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero60014_BattleListener:OnEndBattleTurn(turn)
    if self.skill_1 ~= nil then
        self.skill_1:OnEndBattleTurn(turn)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero60014_BattleListener:OnStartBattleTurn(turn)
    if self.skill_1 ~= nil then
        self.skill_1:OnStartBattleTurn(turn)
    end
end