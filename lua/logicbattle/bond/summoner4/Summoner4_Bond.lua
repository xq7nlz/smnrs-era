--- @class Summoner4_Bond : BaseBond
Summoner4_Bond = Class(Summoner4_Bond, BaseBond)

--- @return void
--- @param initiator BaseHero
function Summoner4_Bond:Ctor(initiator)
    BaseBond.Ctor(self, initiator, BondType.SUMMONER_4)

    --- @type number
    self.shareDamagePercent = nil
end

--- @return void
--- @param damagePercent number
function Summoner4_Bond:SetShareDamagePercent(damagePercent)
    self.shareDamagePercent = damagePercent
end

--- @return number
--- @param damageInitiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Summoner4_Bond:OnTakeDamage(damageInitiator, target, reason, damage)
    if target == self.initiator and self.bondedHeroList:Count() > 1 then
        local sharedDamage = damage * self.shareDamagePercent / (self.bondedHeroList:Count() - 1)

        for _, bondedHero in pairs(self.bondedHeroList:GetItems()) do
            if bondedHero:IsDead() == false and bondedHero ~= self.initiator then
                local result = BondShareDamageResult(target, bondedHero, self.type)
                ActionLogUtils.AddLog(target.battle, result)

                local bondDamage = sharedDamage
                bondDamage = bondedHero.hp:TakeDamage(damageInitiator, self:GetTakeDamageReason(reason), bondDamage)

                result:SetDamage(bondDamage)
                result:RefreshHeroStatus()
            end
        end

        return damage * (1 - self.shareDamagePercent)
    end

    return damage
end