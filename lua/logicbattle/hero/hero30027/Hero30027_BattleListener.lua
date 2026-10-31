--- @class Hero30027_BattleListener
Hero30027_BattleListener = Class(Hero30027_BattleListener, BattleListener)

--- @return void
--- @param hero BaseHero
function Hero30027_BattleListener:Ctor(hero)
    BattleListener.Ctor(self, hero)

    --- @type Hero30027_Skill4
    self.skill_4 = nil

    --- @type Hero30027_Skill3
    self.skill_3 = nil
end


--- @return number
--- @param skill BaseSkill
function Hero30027_BattleListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero30027_BattleListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param round BattleRound
function Hero30027_BattleListener:OnStartBattleRound(round)
    if self.skill_4 ~= nil then
        self.skill_4:OnStartBattleRound(round)
    end
end
