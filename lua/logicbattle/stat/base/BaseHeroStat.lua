--- @class BaseHeroStat
BaseHeroStat = Class(BaseHeroStat)

--- @return void
--- @param hero BaseHero
--- @param statType StatType
--- @param statValueType StatValueType
function BaseHeroStat:Ctor(hero, statType, statValueType)
    --- @type BaseHero
    self.myHero = hero

    --- @type StatType
    self.statType = statType

    --- @type StatValueType
    self.statValueType = statValueType

    --- @type number
    self._totalValue = 0

    --- @type number
    self._minValue = 0
    --- @type number
    self._maxValue = BattleConstants.MAX_NUMBER_VALUE

    --- @type List<StatChanger>
    self._statChangerList = List()

    --- @param Dictionary<number, number>
    self.heroLevelCapEntries = nil
end

---------------------------------------- Init ----------------------------------------
--- @return void
--- @param baseStat HeroData
--- @param levelStats Dictionary<number, HeroData>
--- @param heroLevelCapEntries Dictionary<number, number>
function BaseHeroStat:CalculateStatByLevel(baseStat, levelStats, heroLevelCapEntries)
    self.heroLevelCapEntries = heroLevelCapEntries

    local baseStatValue = self:GetStatBase(baseStat)
    local growStatValue = self:GetStatGrowByLevel(levelStats, heroLevelCapEntries)

    local statChanger = StatChanger(true)
    statChanger:SetType(StatChangerType.ORIGIN)
    statChanger:SetInfo(self.statType, StatChangerCalculationType.RAW_ADD_BASE, baseStatValue + growStatValue)
    self._statChangerList:Add(statChanger)
end

--- @return number
--- @param baseStat HeroData
function BaseHeroStat:GetStatBase(baseStat)
    local bossAdder = self.myHero:GetStatAddForBoss(self.statType)
    local bossMultiplier = self.myHero:GetStatMultiForBossBase(self.statType)

    return (baseStat.heroStats:Get(self.statType) + bossAdder) * bossMultiplier
end

--- @return number
--- @param levelStats Dictionary<number, HeroData>
--- @param heroLevelCapEntries Dictionary<number, number>
function BaseHeroStat:GetStatGrowByLevel(levelStats, heroLevelCapEntries)
    local result = 0
    local level = self.myHero.level
    local lastLevelCap = 0
    local deltaLevel
    local i = 1

    while i <= HeroConstants.MAX_STAR do
        local levelCap = heroLevelCapEntries:GetOrDefault(i, 0)
        local heroData = levelStats:Get(i)
        local value = heroData.heroStats:Get(self.statType)

        if level > levelCap then
            deltaLevel = levelCap - lastLevelCap
            lastLevelCap = levelCap
            result = result + value * deltaLevel
        else
            deltaLevel = level - lastLevelCap
            lastLevelCap = levelCap
            result = result + value * deltaLevel
            break
        end
        i = i + 1
    end

    if i >= HeroConstants.MAX_STAR and level > lastLevelCap then
        local heroData = levelStats:Get(HeroConstants.MAX_STAR)
        local value = heroData.heroStats:Get(self.statType)
        deltaLevel = level - lastLevelCap
        result = result + value * deltaLevel
    end

    local bossMultiplier = self.myHero:GetStatMultiForBossBase(self.statType)
    return result * bossMultiplier
end

--- @return void
function BaseHeroStat:Calculate()
    self._maxValue = BattleConstants.MAX_NUMBER_VALUE

    local rawBase, rawInGame, percentAdd, percentMultiply = self:GetTotalBonus(self._statChangerList)

    if self.statValueType == StatValueType.RAW then
        self._totalValue = MathUtils.Truncate(rawBase * percentAdd * percentMultiply + rawInGame)
    else
        self._totalValue = MathUtils.Truncate(rawBase + percentAdd + percentMultiply + rawInGame)
    end

    self:_LimitStat()
    self._maxValue = self._totalValue
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- reset value to minValue
function BaseHeroStat:SetToMin()
    self._totalValue = self._minValue
end

--- @return void
--- reset value to minValue
function BaseHeroStat:SetToMax()
    self._totalValue = self._maxValue
end

--- @return void
--- @param percent number
function BaseHeroStat:SetStatPercent(percent)
    percent = MathUtils.Clamp(percent, 0, 1)
    self._totalValue = MathUtils.Truncate(self:GetMax() * percent)
end

--- @return boolean
--- @param statChanger StatChanger
function BaseHeroStat:AddChanger(statChanger)
    self._statChangerList:Add(statChanger)
end

--- @return void
--- @param statChanger StatChanger
function BaseHeroStat:RemoveStatChanger(statChanger)
    self._statChangerList:RemoveOneByReference(statChanger)
end

--- @return void
--- @param statPercent number
function BaseHeroStat:UpdateStatByPercent(statPercent)
    local i = 1
    while i <= self._statChangerList:Count() do
        local statChanger = self._statChangerList:Get(i)
        if statChanger.type == StatChangerType.ORIGIN then
            local baseStat = self.myHero.baseStat
            local levelStats = self.myHero.levelStats
            local heroLevelCapEntries = self.heroLevelCapEntries

            local baseStatValue = self:GetStatBase(baseStat)
            local growStatValue = self:GetStatGrowByLevel(levelStats, heroLevelCapEntries)

            local totalValue = (baseStatValue + growStatValue) * statPercent
            statChanger:SetAmount(totalValue)
        end
        i = i + 1
    end
end

--- @return void
--- clamp total value between minValue and maxValue
function BaseHeroStat:_LimitStat()
    self._totalValue = MathUtils.Clamp(self._totalValue, self._minValue, self._maxValue)
end

---------------------------------------- Getters ----------------------------------------
--- @return number
function BaseHeroStat:GetValue()
    return self._totalValue
end

--- @return number
function BaseHeroStat:GetMin()
    return self._minValue
end

--- @return number
function BaseHeroStat:GetMax()
    return self._maxValue
end

--- @return boolean
function BaseHeroStat:IsMin()
    return self._totalValue <= self._minValue
end

--- @return boolean
function BaseHeroStat:IsMax()
    return self._totalValue >= self._maxValue
end

--- @return number
function BaseHeroStat:GetStatPercent()
    local percent = 0
    if self._totalValue > 0 then
        percent = self._totalValue / self._maxValue
        if percent > 1 then
            percent = 1
        end
    end

    return MathUtils.Truncate(percent)
end

--- @return number, number, number, number
--- @param statChangerList List<StatChanger>
function BaseHeroStat:GetTotalBonus(statChangerList)
    local totalRawBase = 0
    local totalRawInGame = 0

    local totalPercentAdd
    if self.statValueType == StatValueType.RAW then
        totalPercentAdd = 1
    else
        totalPercentAdd = 0
    end

    local totalPercentMultiply
    if self.statValueType == StatValueType.RAW then
        totalPercentMultiply = 1
    else
        totalPercentMultiply = 0

    end

    local i = 1
    while i <= statChangerList:Count() do
        ---@type StatChanger
        local statChanger = statChangerList:Get(i)

        if statChanger.calculationType == StatChangerCalculationType.RAW_ADD_BASE then
            totalRawBase = statChanger:CalculateAmount(totalRawBase, self.statValueType)

        elseif statChanger.calculationType == StatChangerCalculationType.RAW_ADD_IN_GAME then
            totalRawInGame = statChanger:CalculateAmount(totalRawInGame, self.statValueType)

        elseif statChanger.calculationType == StatChangerCalculationType.PERCENT_ADD then
            totalPercentAdd = statChanger:CalculateAmount(totalPercentAdd, self.statValueType)

        elseif statChanger.calculationType == StatChangerCalculationType.PERCENT_MULTIPLY then
            totalPercentMultiply = statChanger:CalculateAmount(totalPercentMultiply, self.statValueType)
        end
        i = i + 1
    end

    return MathUtils.Truncate(totalRawBase), MathUtils.Truncate(totalRawInGame),
    MathUtils.Truncate(totalPercentAdd), MathUtils.Truncate(totalPercentMultiply)
end

--- @return string
function BaseHeroStat:ToString()
    assert(false, "this method should be overridden by child class")
end
