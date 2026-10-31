--- @class Hero50004_BattleHelper
Hero50004_BattleHelper = Class(Hero50004_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero50004_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type Hero50004_Skill3
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50004_BattleHelper:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number, boolean, number damage, isCrit, accuracy
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param multiplier number
function Hero50004_BattleHelper:CalculateDamage(target, type, multiplier)
    local damage, isCrit, accuracy
    if type == DamageFormulaType.BASIC_ATTACK then
        multiplier = self:GetBasicAttackMultiplier(target, multiplier)

        local attack = self.myHero.attack:GetValue()
        if self.skill_3 ~= nil then
            attack = self.skill_3:CalculateAttack(target, attack)
        end

        damage = attack * self.myHero.attack:GetMultiAddByTarget(target, multiplier)

        accuracy = self.myHero.originInfo:CalculateAccuracyFactionBonus(target)
        isCrit, damage = self:CalculateCrit(target, damage, type)

    else
        damage, isCrit, accuracy = BattleHelper.CalculateDamage(self, target, type, multiplier)
    end

    return damage, isCrit, accuracy
end