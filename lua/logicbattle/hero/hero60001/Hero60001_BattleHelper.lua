--- @class Hero60001_BattleHelper
Hero60001_BattleHelper = Class(Hero60001_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero60001_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero60001_BattleHelper:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
function Hero60001_BattleHelper:CalculateAttackResult(target)
    local multi = self.basicAttackMultiplier
    if self.skill_4 ~= nil then
        multi = self.skill_4:CalculateAttackResult(multi)
    end
    return self:_CalculateResult(target, DamageFormulaType.BASIC_ATTACK, multi)
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param multiplier number
function Hero60001_BattleHelper:CalculateActiveSkillResult(target, multiplier)
    local numberExtraTurnThisRound = 0

    if self.skill_4 ~= nil then
        multiplier, numberExtraTurnThisRound = self.skill_4:CalculateAttackResult(multiplier)
    end

    local totalDamage, isCrit, dodgeType, isBlock = self:_CalculateResult(target, DamageFormulaType.ACTIVE_SKILL, multiplier)
    totalDamage = self.myHero.effectController:GetBonusDamageExtraTurn(target, numberExtraTurnThisRound, totalDamage)

    return math.floor(totalDamage), isCrit, dodgeType, isBlock
end
