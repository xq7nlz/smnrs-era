--- @class SkillDamageStat : BaseHeroStat
SkillDamageStat = Class(SkillDamageStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function SkillDamageStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.SKILL_DAMAGE, StatValueType.PERCENT)
end

---------------------------------------- Getters ----------------------------------------
--- @return void
--- @param multiplier number damage of skill
function SkillDamageStat:CalculateSkillDamage(target, multiplier)
    return MathUtils.Truncate(multiplier * (1 + self:GetValue()))
end

--- @return string
function SkillDamageStat:ToString()
    return string.format("skillDamage = %s\n", self:GetValue())
end