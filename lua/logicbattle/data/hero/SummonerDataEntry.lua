--- @class SummonerDataEntry
SummonerDataEntry = Class(SummonerDataEntry, HeroDataEntry)

--- @return void
function SummonerDataEntry:Ctor()
    HeroDataEntry.Ctor(self)
    --- @type List<SummonerMastery>
    self.summonerMasteries = List()
end

--- @return HeroData
--- @param skillId number
--- @param selectedStar number
function SummonerDataEntry:GetSkillData(skillId, selectedStar)
    local skills = self.allSkillDataDict:Get(skillId)
    return skills:Get(selectedStar)
end

--- @return void
function SummonerDataEntry:GetMastery(masteryId)
    return self.summonerMasteries:Get(masteryId)
end

--- @return void
--- @param summonerMastery SummonerMastery
function SummonerDataEntry:AddMastery(summonerMastery)
    self.summonerMasteries:Add(summonerMastery)
end

--- @return void
--- @param statData string
--- @param class HeroClassType
function SummonerDataEntry:ParseCsv(statData, class)
    local parsedData = CsvReader.ReadContent(statData)

    local basicInfo = parsedData[1]
    self:ValidateBeforeParseCsv(basicInfo)

    --- make id same as class
    local id = class
    self.class = class
    local name = basicInfo.name

    ---@type Dictionary<number, HeroData>
    local tempLevelStats = Dictionary()
    local lastStar = 0
    for i = 1, #parsedData do
        local data = parsedData[i]

        local star = tonumber(data.star)
        lastStar = star
        local type = tonumber(data.type)
        if MathUtils.IsInteger(type) == false or type < 0 then
            assert(false)
        end

        local summonerData = SummonerHeroData()
        summonerData:SetId(id, name)
        summonerData:SetOriginInfo(star, class, HeroFactionType.CHAOS)
        summonerData:ParseCsv(data)
        summonerData:Validate()

        if type == OriginStatChangerType.BASE_STAT then
            self.baseStats:Add(star, summonerData)
        elseif type == OriginStatChangerType.LEVEL_UP_STAT then
            tempLevelStats:Add(star, summonerData)
        end
    end

    if lastStar < HeroConstants.MAX_STAR then
        local heroData = self.baseStats:Get(lastStar)
        for star = lastStar + 1, HeroConstants.MAX_STAR do
            self.baseStats:Add(star, heroData)
        end

        heroData = tempLevelStats:Get(lastStar)
        for star = lastStar + 1, HeroConstants.MAX_STAR do
            tempLevelStats:Add(star, heroData)
        end
    end
    ---@type  HeroData
    local beforeAwakenStats = tempLevelStats:Get(HeroConstants.AWAKENING_STAR)
    ---@type  HeroData
    local afterAwakenStats = tempLevelStats:Get(HeroConstants.MAX_STAR)

    for i = 1, HeroConstants.MAX_STAR do
        local summonerData = tempLevelStats:Get(i)
        if summonerData == nil then
            if i <= HeroConstants.AWAKENING_STAR then
                self.levelStats:Add(i, beforeAwakenStats)
            else
                self.levelStats:Add(i, afterAwakenStats)
            end
        else
            self.levelStats:Add(i, summonerData)
        end
    end
end

--- @return void
--- @param data table
function SummonerDataEntry:ValidateBeforeParseCsv(data)
    if data.name == nil then
        assert(false)
    end
end