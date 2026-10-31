--- @class ItemPassive_290403:BaseItemPassiveSkill  --Talent passive First round benefit
ItemPassive_290403 = Class(ItemPassive_290403, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_290403:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type boolean
    self.canHeal = false

    --- @type number
    self.healAmount = 0
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_290403:CreateInstance(id, hero)
    return ItemPassive_290403(id, hero)
end

--- @return void
function ItemPassive_290403:Init()
    self.effectApplyType = tonumber(self.data.fields.effect_apply_type)
    self.healPercent = tonumber(self.data.fields.heal_percent)
    self.damagePercent = tonumber(self.data.fields.damage_percent)
    self.myHero.battleHelper:AddDamageItemPassive(self)

    local listener = EventListener(self.myHero, self, self.TriggerHeal)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_BASIC_ATTACK_DAMAGE, listener)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_SKILL_DAMAGE, listener)
end

---------------------------------------- Calculate ----------------------------------------
--- @return number totalDamage
--- @param totalDamage number
--- @param type DamageFormulaType
--- @param reason TakeDamageReason
--- @param target BaseHero
function ItemPassive_290403:CalculateDamage(totalDamage, type, reason, target)
    if type == DamageFormulaType.BASIC_ATTACK
            or type == DamageFormulaType.ACTIVE_SKILL then
        if target.effectController:IsContainEffectType(self.effectApplyType) then

            self.canHeal = true
            self.healAmount = self.myHero.hp:GetMax() * self.healPercent

            return totalDamage * (1 + self.damagePercent)
        end
    end

    self.canHeal = false
    self.healAmount = 0

    return totalDamage
end

--- @return void
--- @param eventData table
function ItemPassive_290403:TriggerHeal(eventData)
    local initiator = eventData.initiator
    if initiator ~= self.myHero then
        return
    end

    local target = eventData.target
    if self.myHero:IsAlly(target) then
        return
    end

    if self.canHeal then
        HealUtils.Heal(self.myHero, self.myHero, self.healAmount, HealReason.HEAL_ITEM_EFFECT)
    end
end

return ItemPassive_290403