--- @class Hero60021_BattleHelper
Hero60021_BattleHelper = Class(Hero60021_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero60021_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60021_BattleHelper:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero60021_BattleHelper:CalculateAttackResult(target)
    local multi = self.basicAttackMultiplier
    if self.skill_2 ~= nil then
        multi = self.skill_2:CalculateAttackResult(multi)
    end
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multi)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param multiplier number
function Hero60021_BattleHelper:CalculateActiveSkillResult(target, multiplier)
    local numberExtraTurnThisRound = 0

    if self.skill_2 ~= nil then
        multiplier, numberExtraTurnThisRound = self.skill_2:CalculateAttackResult(multiplier)
    end

    local totalDamage, isCrit, dodgeType, isBlock = self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
    totalDamage = self.myHero.effectController:GetBonusDamageExtraTurn(target, numberExtraTurnThisRound, totalDamage)

    return math.floor(totalDamage), isCrit, dodgeType, isBlock
end
