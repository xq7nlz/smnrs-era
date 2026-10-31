--- @class ItemPassive_2000501 Talent passive Multi DOT
ItemPassive_2000501 = Class(ItemPassive_2000501, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000501:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.damageBonusPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000501:CreateInstance(id, hero)
    return ItemPassive_2000501(id, hero)
end

--- @return void
function ItemPassive_2000501:Init()
    self.damageBonusPercent = tonumber(self.data.fields.damage_bonus_percent)

    self.myHero.battleHelper:AddDamageItemPassive(self)

    local dotEffect = TalentExtraDotDamageEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(dotEffect)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number totalDamage
--- @param totalDamage number
--- @param reason TakeDamageReason
function ItemPassive_2000501:CalculateDamage(totalDamage, type, reason)
    if type ~= DamageFormulaType.DOT_EFFECT then
        return totalDamage
    end

    return totalDamage * (1 + self.damageBonusPercent)
end

return ItemPassive_2000501