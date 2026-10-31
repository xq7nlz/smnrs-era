--- @class Hero60011_Skill3 Vera
Hero60011_Skill3 = Class(Hero60011_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60011_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusDamage = 0
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60011_Skill3:CreateInstance(id, hero)
    return Hero60011_Skill3(id, hero)
end

--- @return void
function Hero60011_Skill3:Init()
    self.bonusDamage = self.data.bonusDamage

    local targetSelector = TargetSelectorBuilder.Create(self.myHero, self.data.targetPosition,
            TargetTeamType.ENEMY, self.data.targetNumber)

    self.myHero.attackController:SetSelector(targetSelector)
    self.myHero.battleHelper:BindingWithSkill_3(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return number
--- @param target BaseHero
--- @param originMultiplier number
function Hero60011_Skill3:CalculateAttackResult(target, originMultiplier)
    if target.defense:GetValue() > self.myHero.defense:GetValue() then
        originMultiplier = originMultiplier * (1 + self.bonusDamage)
    end
    return originMultiplier
end

return Hero60011_Skill3