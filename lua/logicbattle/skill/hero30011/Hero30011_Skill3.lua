--- @class Hero30011_Skill3 Skaven
Hero30011_Skill3 = Class(Hero30011_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.numberBonusAttack = nil

    --- @type number
    self.bonusAttackDamageMultiplier = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill3:CreateInstance(id, hero)
    return Hero30011_Skill3(id, hero)
end

--- @return void
function Hero30011_Skill3:Init()
    self.numberBonusAttack = self.data.numberBonusAttack
    self.bonusAttackDamageMultiplier = self.data.bonusAttackDamageMultiplier

    self.myHero.attackController:BindingWithSkill(self)
end

--- @return void
function Hero30011_Skill3:GetNumberAttack()
    return self.numberBonusAttack
end

--- @return void
--- @param attackNumber number
function Hero30011_Skill3:GetAttackDamageMultiplier(attackNumber)
    if attackNumber > 1 then
        return self.bonusAttackDamageMultiplier
    end

    return 1
end

return Hero30011_Skill3