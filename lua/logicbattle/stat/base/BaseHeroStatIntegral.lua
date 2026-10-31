--- @class BaseHeroStatIntegral : BaseHeroStat
BaseHeroStatIntegral = Class(BaseHeroStatIntegral, BaseHeroStat)

--- @return void
function BaseHeroStatIntegral:Calculate()
    self._maxValue = BattleConstants.MAX_NUMBER_VALUE

    local rawBase, rawInGame, percentAdd, percentMultiply = self:GetTotalBonus(self._statChangerList)

    if self.statValueType == StatValueType.RAW then
        self._totalValue = math.floor(rawBase * percentAdd * percentMultiply + rawInGame)
    else
        self._totalValue = math.floor(rawBase + percentAdd + percentMultiply + rawInGame)
    end

    self:_LimitStat()
    self._maxValue = self._totalValue
end

--- @return void
--- @param percent number
function BaseHeroStatIntegral:SetStatPercent(percent)
    percent = MathUtils.Clamp(percent, 0, 1)
    self._totalValue = math.floor(self:GetMax() * percent)
end