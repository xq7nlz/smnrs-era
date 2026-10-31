--- @class Hero40010_AttackStat
Hero40010_AttackStat = Class(Hero40010_AttackStat, AttackStat)

--- @return void
--- @param hero BaseHero
function Hero40010_AttackStat:Ctor(hero)
    AttackStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero40010_AttackStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param target BaseHero
--- @param baseMulti number
function Hero40010_AttackStat:GetMultiAddByTarget(target, baseMulti)
    if self.skill_3 ~= nil then
        return self.skill_3:GetMultiAddByTarget(target, baseMulti)
    end

    return baseMulti
end