--- @class Hero10005_BattleHelper
Hero10005_BattleHelper = Class(Hero10005_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero10005_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10005_BattleHelper:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return boolean, number
--- @param target BaseHero
--- @param type DamageFormulaType
--- @param dodgeType DodgeType
function Hero10005_BattleHelper:CalculateBlock(target, type, dodgeType)
    local isBlock, blockDamageRate = BattleHelper.CalculateBlock(self, target, type, dodgeType)

    if self.skill_4 ~= nil then
        return self.skill_4:CalculateBlock(target, type, isBlock, blockDamageRate, dodgeType)
    end
    return isBlock, blockDamageRate
end