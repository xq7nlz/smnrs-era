--- @class Summoner2_Bond : BaseBond
Summoner2_Bond = Class(Summoner2_Bond, BaseBond)

--- @return void
--- @param initiator BaseHero
function Summoner2_Bond:Ctor(initiator)
    BaseBond.Ctor(self, initiator, BondType.SUMMONER_2)

    --- @type BaseHero
    self.tanker = nil

    --- @type number
    self.shareDamagePercent = nil
end

--- @return void
--- @param tanker BaseHero
--- @param damagePercent number
function Summoner2_Bond:SetInfo(tanker, damagePercent)
    self.tanker = tanker
    self.shareDamagePercent = damagePercent
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Summoner2_Bond:OnTakeDamage(damageInitiator, target, reason, damage)
    --- Only share damage if target is not the one that created bond
    if target ~= self.tanker then
        if self.tanker:IsDead() == false then
            local result = BondShareDamageResult(target, self.tanker, self.type)
            ActionLogUtils.AddLog(target.battle, result)

            local bondDamage = damage * self.shareDamagePercent
            bondDamage = self.tanker.hp:TakeDamage(damageInitiator, self:GetTakeDamageReason(reason), bondDamage)

            result:SetDamage(bondDamage)
            result:RefreshHeroStatus()

            return damage * (1 - self.shareDamagePercent)
        end
    end

    return damage
end