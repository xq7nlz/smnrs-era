--- @class Summoner1_BattleListener : BattleListener
Summoner1_BattleListener = Class(Summoner1_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Summoner1_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Summoner1_BattleListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param skill BaseSkill
function Summoner1_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param round BattleRound
function Summoner1_BattleListener:OnStartBattleRound(round)
    if self.skill_3 ~= nil then
        self.skill_3:OnStartBattleRound(round)
    end

    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round)
    end
end