--- @class BaseItemPassiveSkill:BaseSkill ---Talent passive
BaseItemPassiveSkill = Class(BaseItemPassiveSkill, BaseSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function BaseItemPassiveSkill:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)
end

---------------------------------------- Initialization ----------------------------------------
--- @return number totalDamage
--- @param totalDamage number
--- @param type DamageFormulaType
--- @param reason TakeDamageReason
--- @param target BaseHero
function BaseItemPassiveSkill:CalculateDamage(totalDamage, type, reason, target)
    return totalDamage
end

--- @return boolean, number
--- @param takeDamageReason TakeDamageReason
function BaseItemPassiveSkill:CalculateTriggerResist(takeDamageReason, type)
    return false
end

return BaseItemPassiveSkill