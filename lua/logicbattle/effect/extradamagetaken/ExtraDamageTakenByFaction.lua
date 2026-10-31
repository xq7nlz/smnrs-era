--- @class ExtraDamageTakenByFaction : ExtraDamageTaken
ExtraDamageTakenByFaction = Class(ExtraDamageTakenByFaction, ExtraDamageTaken)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ExtraDamageTakenByFaction:Ctor(initiator, target)
    BaseEffect.Ctor(self, initiator, target, EffectType.EXTRA_DAMAGE_TAKEN_BY_FACTION, false)

    --- @type HeroFactionType
    self.factionType = nil

    --- @type number
    self.damageReceive = 0
end

--- @return void
--- @param target BaseHero
--- call right before add effect to hero
function ExtraDamageTakenByFaction:OnEffectAdd(target)
    target.effectController.effectListener:Register(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return void
--- @param target BaseHero
--- call right before remove effect from hero
function ExtraDamageTakenByFaction:OnEffectRemove(target)
    target.effectController.effectListener:Unregister(EffectListenerType.TAKE_DAMAGE, self)
end

--- @return void
--- @param factionType HeroFactionType
--- @param damageReceive number
function ExtraDamageTakenByFaction:SetInfo(factionType, damageReceive)
    self.factionType = factionType
    self.damageReceive = damageReceive
end

--- @return number delta of damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function ExtraDamageTakenByFaction:OnTakeDamage(initiator, reason, damage)
    if initiator.originInfo.faction == self.factionType then
        return damage * self.damageReceive
    end
    return 0
end

--- @return string
function ExtraDamageTakenByFaction:ToDetailString()
    return string.format("%s, damageReceive = %s, faction = %s",
            self:ToString(), self.damageReceive, self.factionType)
end