--- @class Hero40009_Skill3 Sylph
Hero40009_Skill3 = Class(Hero40009_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40009_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.numberBonusAttack = nil

    --- @type number
    self.bonusAttackMultiplierList = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40009_Skill3:CreateInstance(id, hero)
    return Hero40009_Skill3(id, hero)
end

--- @return void
function Hero40009_Skill3:Init()
    self.numberBonusAttack = self.data.numberBonusAttack
    self.bonusAttackMultiplierList = self.data.bonusAttackMultiplierList

    self.myHero.attackController:BindingWithSkill(self)
end

--- @return void
function Hero40009_Skill3:GetNumberAttack()
    return self.numberBonusAttack
end

--- @return void
--- @param attackNumber number
function Hero40009_Skill3:GetAttackDamageMultiplier(attackNumber)
    if attackNumber <= self.bonusAttackMultiplierList:Count() then
        return self.bonusAttackMultiplierList:Get(attackNumber)
    end

    return 1
end

return Hero40009_Skill3