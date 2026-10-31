--- @class Summoner5_BattleListener : BattleListener
Summoner5_BattleListener = Class(Summoner5_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Summoner5_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill3_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Summoner5_BattleListener:BindingWithSkill3_2(skill)
    self.skill3_2 = skill
end

--- @return void
--- @param round BattleRound
function Summoner5_BattleListener:OnStartBattleRound(round)
    if self.skill3_2 ~= nil then
        self.skill3_2:OnStartBattleRound(round)
    end
end