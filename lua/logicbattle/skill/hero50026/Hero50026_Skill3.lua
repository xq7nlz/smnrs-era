--- @class Hero50026_Skill3 Fioneth
Hero50026_Skill3 = Class(Hero50026_Skill3, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50026_Skill3:CreateInstance(id, hero)
    return Hero50026_Skill3(id, hero)
end

--- @return void
function Hero50026_Skill3:Init()
    self.bonusAttack = self.data.bonusAttack
    self.affectedFaction = self.data.affectedFaction

    self.myHero.battleHelper:BindingWithSkill_3(self)
end

--- @return number
--- @param target BaseHero
--- @param multiplier number
function Hero50026_Skill3:GetDamageBonus(target, multiplier)
    if target.originInfo.faction == self.affectedFaction then
        return multiplier * (1 + self.bonusAttack)
    end
    return multiplier
end

return Hero50026_Skill3