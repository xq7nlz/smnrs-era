--- @class Summoner_HpStat : HpStat
Summoner_HpStat = Class(Summoner_HpStat, HpStat)

--- @return void
--- @param hero BaseSummoner
function Summoner_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)
end

---------------------------------------- Setters ----------------------------------------
--- @return number damage
--- @param initiator BaseSummoner
--- @param reason TakeDamageReason
--- @param damage number
function Summoner_HpStat:TakeDamage(initiator, reason, damage)
    return 0
end

--- @return boolean, number isHealOrNot, healAmount
--- @param initiator BaseSummoner
--- @param reason HealReason
--- @param healAmount number
function Summoner_HpStat:Heal(initiator, reason, healAmount)
    return false, 0
end

--- @return void
--- @param initiator BaseSummoner
--- @param reason TakeDamageReason
function Summoner_HpStat:Dead(initiator, reason)
end

--- @return boolean
--- @param initiator BaseSummoner
function Summoner_HpStat:Revive(initiator)
    return false
end