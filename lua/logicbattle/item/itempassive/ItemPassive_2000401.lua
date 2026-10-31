--- @class ItemPassive_2000401 Talent passive Reaper go away
ItemPassive_2000401 = Class(ItemPassive_2000401, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_2000401:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type number
    self.triggerChance = nil

    --- @type number
    self.regenHpPercent = nil

    --- @type boolean
    self.isTriggerResist = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_2000401:CreateInstance(id, hero)
    return ItemPassive_2000401(id, hero)
end

--- @return void
function ItemPassive_2000401:Init()
    self.triggerChance = tonumber(self.data.fields.trigger_chance)
    self.regenHpPercent = tonumber(self.data.fields.regen_hp_percent)

    self.myHero.hp:AddDamageItemPassive(self)

    local instantKillEffect = TalentResistInstantKillEffect(self.myHero, self.myHero)
    self.myHero.effectController:AddEffect(instantKillEffect)
end

---------------------------------------- Calculate ----------------------------------------

--- @return boolean, number
--- @param takeDamageReason TakeDamageReason
function ItemPassive_2000401:CalculateTriggerResist(takeDamageReason)
    if takeDamageReason ~= TakeDamageReason.INSTANT_KILL
            or self.isTriggerResist == true then
        return false
    end

    local isTrigger = self.myHero.randomHelper:RandomRate(self.triggerChance)
    if isTrigger == true then
        self.isTriggerResist = true

        local resistEffect =  self.myHero.effectController:GetDistinctEffectWithType(EffectType.TALENT_RESIST_INSTANT_KILL)
        if resistEffect ~= nil then
            self.myHero.effectController:ForceRemove(resistEffect)
        end

        local healAmount = self.regenHpPercent * self.myHero.hp:GetMax()
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_ITEM_EFFECT)
        return true
    end

    return false
end

return ItemPassive_2000401