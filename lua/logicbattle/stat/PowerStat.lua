--- @class PowerStat : BaseHeroStat
PowerStat = Class(PowerStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function PowerStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.POWER, StatValueType.RAW)

    --- @type Dictionary<number, number>
    self.powerGains = nil

    --- @type number
    self._totalValue = HeroConstants.DEFAULT_HERO_POWER

    --- @type number
    self._maxValue = HeroConstants.MAX_HERO_POWER

    --- @type PowerStat
    self.summonerPowerStat = nil

end

---------------------------------------- Init ----------------------------------------
--- @return void
--- @param powerGains Dictionary<number, number>
function PowerStat:SetPowerGainData(powerGains)
    self.powerGains = powerGains
end

--- @return void
--- @param baseStat HeroData
--- @param levelStats Dictionary<number, HeroData>
--- @param heroLevelCapEntries Dictionary<number, number>
function PowerStat:CalculateStatByLevel(baseStat, levelStats, heroLevelCapEntries)
    --- Do nothing, as power stat is not scaled by level
end

--- @return void
function PowerStat:Calculate()
    if self.myHero.battle.battlePhase == BattlePhase.PREPARE_BATTLE then
        self:SetStatPercent(self.myHero.startState:GetPowerValue() / self:GetMax())
    end

    local rawBase, rawInGame, percentAdd, percentMultiply = self:GetTotalBonus(self._statChangerList)
    self._totalValue = self._totalValue + rawBase + rawInGame

    self:_LimitStat()
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param actionId number id of action that relates to powerGainEntry
--- @param percentMultiply number
function PowerStat:Regen(actionId, percentMultiply)
    if self.myHero:IsDead() == false then
        local amount = self.powerGains:Get(actionId)

        if percentMultiply ~= nil then
            self._totalValue = self._totalValue + amount * percentMultiply
        else
            self._totalValue = self._totalValue + amount
        end

        self:_LimitStat()

        -- Add power to summoner
        if self.summonerPowerStat == nil then
            local attackerTeam, defenderTeam = self.myHero.battle:GetTeam()
            local allyTeam = TargetSelectorUtils.GetAllyTeam(attackerTeam, defenderTeam, self.myHero.teamId)

            self.summonerPowerStat = allyTeam.summoner.power
        end
        self.summonerPowerStat:GainPowerFromHero(self.myHero, amount)
    end
end

--- @return void
--- @param initiator BaseHero
--- @param amount number
function PowerStat:Gain(initiator, amount)
    if self.myHero:IsDead() == false then
        self._totalValue = self._totalValue + amount
        self:_LimitStat()

        ActionLogUtils.CreatePowerChangeResult(initiator, self.myHero)
    end
end

--- @return string
function PowerStat:ToString()
    return string.format("power = %s/%s\n", self:GetValue(), self._maxValue)
end