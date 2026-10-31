--- @class Hero20001_AttackStat
Hero20001_AttackStat = Class(Hero20001_AttackStat, AttackStat)

--- @return void
--- @param hero BaseHero
function Hero20001_AttackStat:Ctor(hero)
    AttackStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20001_AttackStat:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return number
--- @param target BaseHero
--- @param baseMulti number
function Hero20001_AttackStat:GetMultiAddByTarget(target,  baseMulti)
    if self.skill_3 ~= nil then
        return self.skill_3:GetMultiAddByTarget(target,  baseMulti)
    end

    return baseMulti
end