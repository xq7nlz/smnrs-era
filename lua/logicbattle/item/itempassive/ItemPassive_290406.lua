--- @class ItemPassive_290406:BaseItemPassiveSkill  --Talent passive First round benefit
ItemPassive_290406 = Class(ItemPassive_290406, BaseItemPassiveSkill)

--- @return void
--- @param id number id of talent level 10, 11, 12
--- @param hero BaseHero
function ItemPassive_290406:Ctor(id, hero)
    BaseItemPassiveSkill.Ctor(self, id, hero)

    --- @type List<BaseHero>
    self.bleedTargets = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function ItemPassive_290406:CreateInstance(id, hero)
    return ItemPassive_290406(id, hero)
end

--- @return void
function ItemPassive_290406:Init()
    self.healPercent = tonumber(self.data.fields.heal_percent)

    local listener = EventListener(self.myHero, self, self.TriggerHeal)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_BASIC_ATTACK_DAMAGE, listener)
    self.myHero.battle.eventManager:AddListener(EventType.DEAL_SKILL_DAMAGE, listener)

    local newRoundListener = EventListener(self.myHero, self, self.OnNewRound)
    self.myHero.battle.eventManager:AddListener(EventType.START_ROUND, newRoundListener)

    self.myHero.battleHelper:AddDamageItemPassive(self)
end

---------------------------------------- Calculate ----------------------------------------
function ItemPassive_290406:CalculateDamage(totalDamage, type, reason, target)
    if type == DamageFormulaType.BASIC_ATTACK
            or type == DamageFormulaType.ACTIVE_SKILL then
        if target.effectController:IsContainEffectType(EffectType.BLEED) then
            self.bleedTargets:Add(target)
        end
    end

    return totalDamage
end

--- @return void
--- @param eventData table
function ItemPassive_290406:TriggerHeal(eventData)
    local initiator = eventData.initiator
    if initiator ~= self.myHero then
        return
    end

    local target = eventData.target
    if self.myHero:IsAlly(target) then
        return
    end

    if self.bleedTargets:IsContainValue(target) then
        local healAmount = self.myHero.hp:GetMax() * self.healPercent
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_ITEM_EFFECT)
    end
end
--- @return void
--- @param eventData table
function ItemPassive_290406:OnNewRound(eventData)
    local initiator = eventData.initiator
    if initiator ~= self.myHero then
        return
    end

    self.bleedTargets:Clear()
end

return ItemPassive_290406