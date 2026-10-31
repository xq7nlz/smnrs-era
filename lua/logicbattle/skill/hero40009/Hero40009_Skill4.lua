--- @class Hero40009_Skill4 Sylph
Hero40009_Skill4 = Class(Hero40009_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40009_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusAttackWhenCrit = nil

    --- @type number
    self.canDealBonusDamage = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero40009_Skill4:CreateInstance(id, hero)
    return Hero40009_Skill4(id, hero)
end

--- @return void
function Hero40009_Skill4:Init()
    self.bonusAttackWhenCrit = self.data.bonusAttackWhenCrit

    self.myHero.attackController:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param isCrit boolean
function Hero40009_Skill4:OnDealCritDamage(isCrit)
    if isCrit == true then
        self.canDealBonusDamage = true
    else
        self.canDealBonusDamage = false
    end
end

--- @return void
function Hero40009_Skill4:GetAttackDamageMultiplier()
    if self.canDealBonusDamage == true then
        self.canDealBonusDamage = false
        return self.bonusAttackWhenCrit
    end
    return 0
end

return Hero40009_Skill4