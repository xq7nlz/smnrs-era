--- @class Hero30027_HpStat : HpStat
Hero30027_HpStat = Class(Hero30027_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero30027_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30027_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero30027_HpStat:OnTakeDamage(initiator, reason, damage)
    damage = HpStat.OnTakeDamage(self, initiator, reason, damage)

    if self.skill_4 ~= nil then
        local isTriggerNonTarget, receivedDamage = self.skill_4:OnTakeDamage(damage)
        if isTriggerNonTarget == true then
            damage = receivedDamage
        end
    end

    return damage
end

--- @return number
--- @param initiator BaseHero
--- @param reason HealReason
--- @param healAmount number
function Hero30027_HpStat:OnHeal(initiator, reason, healAmount)
    healAmount = math.floor(self.myHero.effectController.effectListener:OnHeal(initiator, reason, healAmount))

    if healAmount < 0 then
        healAmount = 0
    end

    if self.skill_4 ~= nil then
        local isTrigger, receivedHealAmount = self.skill_4:OnHeal(healAmount)
        if isTrigger == true then
            healAmount = receivedHealAmount
        end
    end

    return MathUtils.Truncate(healAmount)
end


