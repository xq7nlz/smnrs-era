--- @class Hero40009_AttackController
Hero40009_AttackController = Class(Hero40009_AttackController, BonusAttackController)

--- @return void
function Hero40009_AttackController:Ctor(hero)
    BonusAttackController.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero40009_AttackController:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

---------------------------------------- Attack ----------------------------------------
--- @return List<AttackResult> turn of this hero should be ended or not
--- @param target BaseHero
--- @param attackNumber number
function Hero40009_AttackController:AttackBonus(target, attackNumber)
    local attackMultiplier = 1

    if self.skill_4 ~= nil then
        attackMultiplier = attackMultiplier + self.skill_4:GetAttackDamageMultiplier()
    end

    if self.skill ~= nil then
        attackMultiplier = attackMultiplier * self.skill:GetAttackDamageMultiplier(attackNumber)
    end

    self.myHero.battleHelper:SetBasicAttackMultiplier(attackMultiplier)

    local totalDamage, isCrit, dodgeType, isBlock = self.myHero.battleHelper:CalculateAttackResult(target)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealCritDamage(isCrit)
    end

    local result = self:CreateResult(target, isCrit, dodgeType, isBlock)
    ActionLogUtils.AddLog(self.myHero.battle, result)

    totalDamage = self:CalculateHeroStatus(target, totalDamage, dodgeType)
    result:SetDamage(totalDamage)

    return result
end