--- @class Hero10011_BattleListener
Hero10011_BattleListener = Class(Hero10011_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero10011_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10011_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end


---------------------------------------- Battle Round ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero10011_BattleListener:OnStartBattleRound(round)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round)
    end
end

---------------------------------------- Battle Turn ----------------------------------------
--- @return void
--- @param turn BattleTurn
function Hero10011_BattleListener:OnStartBattleTurn(turn)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleTurn(turn)
    end
end