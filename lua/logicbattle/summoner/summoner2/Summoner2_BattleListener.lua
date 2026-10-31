--- @class Summoner2_BattleListener : BattleListener
Summoner2_BattleListener = Class(Summoner2_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Summoner2_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Summoner2_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param round BattleRound
function Summoner2_BattleListener:OnStartBattleRound(round)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round)
    end
end