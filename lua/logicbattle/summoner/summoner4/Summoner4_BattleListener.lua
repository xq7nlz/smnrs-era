--- @class Summoner4_BattleListener : BattleListener
Summoner4_BattleListener = Class(Summoner4_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Summoner4_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill3_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Summoner4_BattleListener:BindingWithSkill3_2(skill)
    self.skill3_2 = skill
end

--- @return void
--- @param round BattleRound
function Summoner4_BattleListener:OnStartBattleRound(round)
    if self.skill3_2 ~= nil then
        self.skill3_2:OnStartBattleRound(round)
    end
end