--- @class Hero30004_HpStat
Hero30004_HpStat = Class(Hero30004_HpStat, HpStat)

--- @return void
--- @param hero BaseHero
function Hero30004_HpStat:Ctor(hero)
    HpStat.Ctor(self, hero)

    --- @type number
    self.totalDamage = 0
end

--- @return number
--- @param initiator BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function Hero30004_HpStat:TakeDamage(initiator, reason, damage)
    damage = HpStat.TakeDamage(self, initiator, reason, damage)

    self.totalDamage = self.totalDamage + damage
    return damage
end

--- @return void
--- @param round BattleRound
function Hero30004_HpStat:OnStartBattleRound(round)
    self.totalDamage = 0
end

--- @return number
function Hero30004_HpStat:GetTotalDamageInRound()
    return self.totalDamage
end