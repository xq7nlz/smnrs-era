--- @class Hero60026_Skill4 Vampire
Hero60026_Skill4 = Class(Hero60026_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60026_Skill4:CreateInstance(id, hero)
    return Hero60026_Skill4(id, hero)
end

--- @return void
function Hero60026_Skill4:Init()
    self.myHero.hp:BindingWithSkill_4(self)
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero60026_Skill4:TakeDamage(initiator, reason, damage)
    if reason == TakeDamageReason.POISON then
        damage = damage * (1 - self.data.poisonDamageReduction)
    end

    return damage
end

return Hero60026_Skill4