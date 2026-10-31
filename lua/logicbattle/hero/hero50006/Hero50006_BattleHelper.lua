--- @class Hero50006_BattleHelper
Hero50006_BattleHelper = Class(Hero50006_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero50006_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50006_BattleHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero50006_BattleHelper:CalculateAttackResult(target)
    local multiDamage = self.basicAttackMultiplier
    local numberExtraTurnThisRound = 0

    if self.skill_3 ~= nil then
        multiDamage, numberExtraTurnThisRound = self.skill_3:GetMultiDamageExtraTurn(multiDamage)
    end

    local totalDamage, isCrit, dodgeType, isBlock = self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multiDamage)
    totalDamage = self.myHero.effectController:GetBonusDamageExtraTurn(target, numberExtraTurnThisRound, totalDamage)

    return math.floor(totalDamage), isCrit, dodgeType, isBlock
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param multiplier number
function Hero50006_BattleHelper:CalculateActiveSkillResult(target, multiplier)
    local numberExtraTurnThisRound = 0

    if self.skill_3 ~= nil then
        multiplier, numberExtraTurnThisRound = self.skill_3:GetMultiDamageExtraTurn(multiplier)
    end

    local totalDamage, isCrit, dodgeType, isBlock = self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
    totalDamage = self.myHero.effectController:GetBonusDamageExtraTurn(target, numberExtraTurnThisRound, totalDamage)

    return math.floor(totalDamage), isCrit, dodgeType, isBlock
end