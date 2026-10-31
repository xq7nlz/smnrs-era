--- @class Hero60003_BattleHelper
Hero60003_BattleHelper = Class(Hero60003_BattleHelper, BattleHelper)

--- @return void
--- @param hero BaseHero
function Hero60003_BattleHelper:Ctor(hero)
    BattleHelper.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_1 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60003_BattleHelper:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return number, boolean, DodgeType, boolean totalDamage, isCrit, dodgeType, isBlock
--- @param target BaseHero
--- @param multiplier number
function Hero60003_BattleHelper:CalculateActiveSkillResult(target, multiplier)
    local totalDamage, isCrit, dodgeType, isBlock = BattleHelper.CalculateActiveSkillResult(self, target, multiplier)
    if self.skill_1 ~= nil then
        totalDamage = totalDamage * self.skill_1:GetBonusMultiplierSkill()
    end

    return math.floor(totalDamage), isCrit, dodgeType, isBlock
end