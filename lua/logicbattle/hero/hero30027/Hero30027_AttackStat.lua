--- @class Hero30027_AttackStat :AttackStat
Hero30027_AttackStat = Class(Hero30027_AttackStat, AttackStat)

--- @return void
--- @param hero BaseHero
function Hero30027_AttackStat:Ctor(hero)
    AttackStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type Hero30027_Skill3
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30027_AttackStat:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero30027_AttackStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
function Hero30027_AttackStat:GetValue()
    local finalAttack = self._totalValue
    if self.skill_2 ~= nil then
        finalAttack = finalAttack + self.skill_2:CalculateExchangeAttack(self._totalValue)
    end

    if self.skill_3 ~= nil then
        finalAttack = finalAttack + self.skill_3:CalculateBonusAttack(self._totalValue)
    end

    return finalAttack
end