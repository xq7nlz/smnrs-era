--- @class ItemPassive_2000201 Talent passive Explosion
ItemPassive_2000201 = Class(ItemPassive_2000201, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000201:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.bonusChance = nil

    --- @type number
    self.damageBonusPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000201:CreateInstance(id, hero)
    return ItemPassive_2000201(id, hero)
end

--- @return void
function ItemPassive_2000201:Init()
    self.bonusChance = tonumber(self.data.fields.bonus_chance)
    self.damageBonusPercent = tonumber(self.data.fields.damage_bonus_percent)

    self.myHero.battleHelper:AddDamageItemPassive(self)

    local damageEffect = TalentExtraDamageEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(damageEffect)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number totalDamage
--- @param totalDamage number
--- @param reason TakeDamageReason
function ItemPassive_2000201:CalculateDamage(totalDamage, type, reason)
    if type ~= DamageFormulaType.BASIC_ATTACK then
        return totalDamage
    end

    local isBonus = self.myHero.randomHelper:RandomRate(self.bonusChance)
    if isBonus == true then
        return totalDamage * (1 + self.damageBonusPercent)
    else
        return totalDamage
    end
end

return ItemPassive_2000201