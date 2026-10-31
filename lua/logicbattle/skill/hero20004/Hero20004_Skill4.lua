--- @class Hero20004_Skill4 Defronowe
Hero20004_Skill4 = Class(Hero20004_Skill4, BaseSkill)

--- @return void
--- @param id number
--- @param hero BaseHero
function Hero20004_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type CounterAttackSkillHelper
    self.counterAttackHelper = nil
end

--- @return BaseSkill
--- @param id number
--- @param hero BaseHero
function Hero20004_Skill4:CreateInstance(id, hero)
    return Hero20004_Skill4(id, hero)
end

--- @return void
function Hero20004_Skill4:Init()
    self.counterAttackHelper = CounterAttackSkillHelper(self)
    self.counterAttackHelper:SetInfo(self.data.counterAttackDamage, self.data.counterAttackChance)

    self.myHero.skillController:SetCanBeCounterAttack(false)

    self.myHero.battleHelper:BindingWithSkill_4(self)
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return boolean, number
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param isBlock boolean
--- @param blockDamageRate number
--- @param dodgeType DodgeType
function Hero20004_Skill4:CalculateBlock(target, type, isBlock, blockDamageRate, dodgeType)
    if dodgeType ~= DodgeType.MISS then
        if type == DamageFormulaType.BASIC_ATTACK or type == DamageFormulaType.ACTIVE_SKILL then
            return false, 1
        end
    end

    return isBlock, blockDamageRate
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero20004_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    local targetList = List()
    targetList:Add(enemyAttacker)

    self.counterAttackHelper:UseCounterAttack(targetList)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero20004_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    local targetList = List()
    targetList:Add(enemy)

    self.counterAttackHelper:UseCounterAttack(targetList)
end

return Hero20004_Skill4