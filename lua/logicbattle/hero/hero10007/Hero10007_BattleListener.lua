--- @class Hero10007_BattleListener
Hero10007_BattleListener = Class(Hero10007_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero10007_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10007_BattleListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param turn BattleTurn
function Hero10007_BattleListener:OnStartBattleTurn(turn)
    if self.skill_2 ~= nil then
        self.skill_2:OnStartBattleTurn(turn)
    end
end

--- @return void
--- @param turn BattleTurn
function Hero10007_BattleListener:OnEndBattleTurn(turn)
    if self.skill_2 ~= nil then
        self.skill_2:OnEndBattleTurn(turn)
    end
end