--- @class Hero30002_Skill3 En
Hero30002_Skill3 = Class(Hero30002_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30002_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.hpBeAttacked = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30002_Skill3:CreateInstance(id, hero)
    return Hero30002_Skill3(id, hero)
end

--- @return void
function Hero30002_Skill3:Init()
    self.hpBeAttacked = self.data.hpBeAttacked
    self.myHero.hp:BindingWithSkill_3(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero30002_Skill3:TakeDamage(initiator, reason, damage)
    if reason == TakeDamageReason.ATTACK_DAMAGE or reason == TakeDamageReason.SKILL_DAMAGE then
        return self:ClampDamage(damage)
    end
    return damage
end

--- @return number
--- @param totalDamage number
function Hero30002_Skill3:ClampDamage(totalDamage)
    local maxValue = self.myHero.hp:GetMax() * self.hpBeAttacked
    return MathUtils.Clamp(totalDamage, 0, maxValue)
end

return Hero30002_Skill3