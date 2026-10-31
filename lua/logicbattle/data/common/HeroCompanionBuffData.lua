--- @class HeroCompanionBuffData
HeroCompanionBuffData = Class(HeroCompanionBuffData)

--- @return void
function HeroCompanionBuffData:Ctor(id)
    --- @type number
    self.id = id

    --- @type string
    self.name = nil

    --- @type List<table>
    self.bonuses = List()

    --- @type number
    self.totalSameFactionConditionNumber = 0

    --- @type List<HeroCompanionBuffCondition>
    self.sameFactionConditions = List()
end

--- @return void
--- @param data table
function HeroCompanionBuffData:ParseCsv(data)
    self.name = data.name

    local i = 1
    while true do
        local keyStat = EffectConstants.STAT_TYPE_TAG .. i
        if TableUtils.IsContainKey(data, keyStat) then
            local bonus = {}
            bonus.statType = tonumber(data[keyStat])
            if bonus.statType ~= nil then

                local keyBonus = EffectConstants.STAT_BONUS_TAG .. i
                bonus.amount = tonumber(data[keyBonus])

                local keyCalculationType = EffectConstants.STAT_CALCULATION_TYPE_TAG .. i
                if TableUtils.IsContainKey(data, keyCalculationType) then
                    bonus.calculationType = tonumber(data[keyCalculationType])
                else
                    bonus.calculationType = StatChangerCalculationType.PERCENT_ADD
                end

                self.bonuses:Add(bonus)
            else
                break
            end
        else
            break
        end
        i = i + 1
    end
end

--- @return void
--- @param data table
function HeroCompanionBuffData:AddCondition(data)
    local condition = HeroCompanionBuffCondition()
    condition:ParseCsv(data)

    if condition.conditionType == HeroCompanionBuffConditionType.SAME_FACTION then
        self.sameFactionConditions:Add(condition)
        self.sameFactionConditions:Sort(self, self.CompareCondition)

        self.totalSameFactionConditionNumber = self.totalSameFactionConditionNumber + condition.conditionNumber
    end
end

--- @return number delta between heroList and companionBuff
--- @param heroPerFactions Dictionary<number, number> key: HeroFactionType, value: number
function HeroCompanionBuffData:IsMatch(heroPerFactions)
    local heroCount = self:GetHeroCount(heroPerFactions)
    if heroCount < BattleConstants.NUMBER_SLOT then
        return false
    end

    local heroSets = self:GetAllHeroSets(heroPerFactions)
    if self.sameFactionConditions:Count() ~= heroSets:Count() then
        return false
    end

    local delta = self.totalSameFactionConditionNumber
    for i = 1, heroSets:Count() do
        local numberHeroes = heroSets:Get(i)
        local condition = self.sameFactionConditions:Get(i)

        if numberHeroes == condition.conditionNumber then
            delta = delta - numberHeroes
        end
    end

    return delta == 0
end

--- @return List<number>
--- @param heroPerFactions Dictionary<number, number> key: HeroFactionType, value: number
function HeroCompanionBuffData:GetAllHeroSets(heroPerFactions)
    local result = List()

    for _, numberHeroes in pairs(heroPerFactions:GetItems()) do
        if numberHeroes > 1 then
            result:Add(numberHeroes)
        end
    end

    result:Sort(self, self.CompareHeroSet)
    return result
end

--- @return number
--- @param heroPerFactions Dictionary<number, number> key: HeroFactionType, value: number
function HeroCompanionBuffData:GetHeroCount(heroPerFactions)
    local result = 0
    for _, numberHeroes in pairs(heroPerFactions:GetItems()) do
        result = result + numberHeroes
    end

    return result
end

--- @return number
--- Positive: item1 > item2, 0: item1 == item2, Negative: item1 < item2
function HeroCompanionBuffData:CompareCondition(first, second)
    return first.conditionNumber - second.conditionNumber
end

--- @return number
--- Positive: item1 > item2, 0: item1 == item2, Negative: item1 < item2
function HeroCompanionBuffData:CompareHeroSet(first, second)
    return first - second
end

--- @return string
function HeroCompanionBuffData:ToString()
    return string.format("%s (id = %s)\n", self.name, self.id)
end