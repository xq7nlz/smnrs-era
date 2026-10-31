--- @class Hero50012_Skill4 Alvar
Hero50012_Skill4 = Class(Hero50012_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50012_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusDamage = 0
    --- @type number
    self.healChance = 0
    --- @type number
    self.healPercentOfDamage = 0
    --- @type boolean
    self.targetIsHigherHP = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50012_Skill4:CreateInstance(id, hero)
    return Hero50012_Skill4(id, hero)
end

--- @return void
function Hero50012_Skill4:Init()
    self.bonusDamage = self.data.bonusDamage
    self.healChance = self.data.healChance
    self.healPercentOfDamage = self.data.healPercentOfDamage

    self.myHero.battleHelper:BindingWithSkill_4(self)
    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param originMultiDamage number
function Hero50012_Skill4:GetDamageBonusBasicAttack(target, originMultiDamage)
    if target.hp:GetValue() > self.myHero.hp:GetValue() then
        self.targetIsHigherHP = true
        return originMultiDamage * (1 + self.bonusDamage)
    else
        self.targetIsHigherHP = false
    end
    return originMultiDamage
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50012_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    if dodgeType ~= DodgeType.MISS and self.targetIsHigherHP == true and self.myHero.randomHelper:RandomRate(self.healChance) then
        local healAmount = totalDamage * self.healPercentOfDamage
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero50012_Skill4