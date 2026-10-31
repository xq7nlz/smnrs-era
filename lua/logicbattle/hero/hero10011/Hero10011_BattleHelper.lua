--- @class Hero10011_BattleHelper
Hero10011_BattleHelper = Class(Hero10011_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero10011_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10011_BattleHelper:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero10011_BattleHelper:CalculateAttackResult(target)
    local multiDamage = self.basicAttackMultiplier
    if self.skill_4 ~= nil then
        multiDamage = self.skill_4:GetMultiDamageExtraTurn(multiDamage)
    end
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiDamage)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param multiplier number
function Hero10011_BattleHelper:CalculateActiveSkillResult(target, multiplier)
    local numberExtraTurnThisRound = 0

    if self.skill_4 ~= nil then
        multiplier, numberExtraTurnThisRound = self.skill_4:GetMultiDamageExtraTurn(multiplier)
    end

    local totalDamage, isCrit, dodgeType, isBlock = self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
    totalDamage = self.myHero.effectController:GetBonusDamageExtraTurn(target, numberExtraTurnThisRound, totalDamage)

    return math.floor(totalDamage), isCrit, dodgeType, isBlock
end