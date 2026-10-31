--- @class Hero20006_HpStat
Hero20006_HpStat = Class(Hero20006_HpStat, HpStat)

function Hero20006_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero20006_HpStat:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return number damage
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero20006_HpStat:TakeDamage(initiator, reason, damage)
    if self.isDead == false then
        if self.skill_4 ~= nil and self:IsDotDamage(reason) then
            return self.skill_4:GetDotAmount(damage)
        end

        damage = self:OnTakeDamage(initiator, reason, damage)
        self._totalValue = self._totalValue - damage
        self:_LimitStat()

        if self:IsMin() then
            self:Dead(initiator, reason)
        end
        EventUtils.TriggerEventTakeDamage(initiator, self.myHero, reason, damage)

        return damage
    end

    return 0
end

--- @return boolean
--- @param reason TakeDamageReason
function Hero20006_HpStat:IsDotDamage(reason)
    if reason == TakeDamageReason.BLEED
            or reason == TakeDamageReason.POISON
            or reason == TakeDamageReason.BURNING then
        return true
    end

    return false
end