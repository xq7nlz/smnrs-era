--- @class Summoner_PowerStat : PowerStat
Summoner_PowerStat = Class(Summoner_PowerStat, PowerStat)

--- @return void
--- @param hero BaseSummoner
function Summoner_PowerStat:Ctor(hero)
    PowerStat.Ctor(self, hero)

    self._totalValue = HeroConstants.DEFAULT_SUMMONER_POWER
    self._maxValue = HeroConstants.MAX_SUMMONER_POWER
end

---------------------------------------- Init ----------------------------------------
--- @return void
function Summoner_PowerStat:Calculate()
    --- do nothing here
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param actionId number id of action that relates to powerGainEntry
function Summoner_PowerStat:Regen(actionId)
    --- do nothing here
end

--- @return void
--- @param initiator BaseHero
--- @param amount number
function Summoner_PowerStat:Gain(initiator, amount)
    --- do nothing here
end

--- @return void
--- @param initiator BaseSummoner
--- @param amount number
function Summoner_PowerStat:GainPowerFromHero(initiator, amount)
    self._totalValue = self._totalValue + amount
    self:_LimitStat()

    ActionLogUtils.CreatePowerChangeResult(initiator, self.myHero)
end
