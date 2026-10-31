--- @class HeroDataService
HeroDataService = Class(HeroDataService)

--- @return void
function HeroDataService:Ctor()
    --- key: heroId, value: HeroDataEntry
    --- @type Dictionary<number, HeroDataEntry>
    self.heroDataEntries = Dictionary()

    --- key: summonerId, value: SummonerDataEntry
    --- @type Dictionary<number, SummonerDataEntry>
    self.summonerDataEntries = Dictionary()

    --- key: star, value: level cap
    --- @type Dictionary<number, number>
    self.heroLevelCapEntries = Dictionary()

    --- key: actionId, value: HeroSkillLevelData
    --- @type Dictionary<number, HeroSkillLevelData>
    self.heroSkillLevelDataEntries = Dictionary()

    --- key: formationId, value: FormationData
    --- @type Dictionary<number, FormationData>
    self.formationDataEntries = Dictionary()

    --- key: formationId, value: FormationBuffData
    --- @type Dictionary<number, FormationBuffData>
    self.formationFrontLineBuffDataEntries = Dictionary()

    --- key: formationId, value: FormationBuffData
    --- @type Dictionary<number, FormationBuffData>
    self.formationBackLineBuffDataEntries = Dictionary()

    --- key: actionId, value: amount of power gained per action
    --- @type Dictionary<number, number>
    self.powerGainEntries = Dictionary()

    --- key: companion buff id, value: HeroCompanionBuffData
    --- @type Dictionary<number, HeroCompanionBuffData>
    self.heroCompanionBuffEntries = Dictionary()

end

---------------------------------------- Getters ----------------------------------------
--- @return HeroDataEntry
--- @param id number
function HeroDataService:GetHeroDataEntry(id)
    local heroData = self.heroDataEntries:Get(id)
    if heroData == nil and IS_CLIENT_RUNNING then
        heroData = ResourceMgr.GetHeroesConfig():GetHeroCsv():GetHeroDataEntry(id)
        self:AddHeroDataEntry(heroData)
    end
    return heroData
end

--- @return SummonerDataEntry
--- @param class HeroClassType
function HeroDataService:GetSummonerDataEntry(class)
    local summonerData = self.summonerDataEntries:Get(class)
    if summonerData == nil and IS_CLIENT_RUNNING then
        summonerData = ResourceMgr.GetHeroesConfig():GetSummonerCsv():GetDataEntry(class)
        self:AddSummonerDataEntry(summonerData)
    end
    return summonerData
end

--- @return number level
--- @param star number
function HeroDataService:GetHeroLevelCap(star)
    return self.heroLevelCapEntries:Get(star)
end

--- @return HeroSkillLevelData
--- @param star number
function HeroDataService:GetHeroSkillLevelData(star)
    return self.heroSkillLevelDataEntries:Get(star)
end

--- @return FormationData
--- @param formationId number
function HeroDataService:GetFormationData(formationId)
    return self.formationDataEntries:Get(formationId)
end

--- @return FormationBuffData
--- @param formationId number
--- @param isFront boolean
function HeroDataService:GetFormationBuffData(formationId, isFront)
    if isFront == true then
        return self.formationFrontLineBuffDataEntries:Get(formationId)
    else
        return self.formationBackLineBuffDataEntries:Get(formationId)
    end
end

--- @return number number of power gain per action
--- @param actionId number
function HeroDataService:GetPowerGainData(actionId)
    return self.powerGainEntries:Get(actionId)
end

--- @return HeroCompanionBuffData
--- @param heroPerFactions Dictionary<HeroFactionType, number>
function HeroDataService:GetBestMatchCompanionBuff(heroPerFactions)
    for _, buff in pairs(self.heroCompanionBuffEntries:GetItems()) do
        if buff:IsMatch(heroPerFactions) then
            --- closest match to this companion buff
            return buff
        end
    end

    return nil
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param entry HeroDataEntry
function HeroDataService:AddHeroDataEntry(entry)
    self.heroDataEntries:Add(entry.id, entry)
end

--- @return void
--- @param entry SummonerDataEntry
function HeroDataService:AddSummonerDataEntry(entry)
    self.summonerDataEntries:Add(entry.class, entry)
end

--- @return void
--- @param csv string
function HeroDataService:AddHeroLevelCap(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local star = tonumber(parsedData[i].star)
        local levelCap = tonumber(parsedData[i].level_cap)

        self.heroLevelCapEntries:Add(star, levelCap)
    end
end

--- @return void
--- @param csv string
function HeroDataService:AddHeroSkillLevelData(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local heroSkillLevelData = HeroSkillLevelData()
        heroSkillLevelData:ParseCsv(parsedData[i])
        self.heroSkillLevelDataEntries:Add(heroSkillLevelData.star, heroSkillLevelData)
    end
end

--- @return void
--- @param csv string
function HeroDataService:AddFormationData(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local formationData = FormationData()
        formationData:ParseCsv(parsedData[i])
        self.formationDataEntries:Add(formationData.id, formationData)
    end
end

--- @return void
--- @param csv string
function HeroDataService:AddFormationBuffData(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local formationBuffData = FormationBuffData()
        formationBuffData:ParseCsv(parsedData[i])

        if formationBuffData.isFront == true then
            self.formationFrontLineBuffDataEntries:Add(formationBuffData.id, formationBuffData)
        else
            self.formationBackLineBuffDataEntries:Add(formationBuffData.id, formationBuffData)
        end
    end
end

--- @return void
--- @param csv string
function HeroDataService:AddPowerGainData(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local actionId = tonumber(parsedData[i].id)
        local power = tonumber(parsedData[i].power)

        assert(MathUtils.IsInteger(actionId) and actionId >= 1)
        assert(MathUtils.IsInteger(power) and actionId >= 1)

        self.powerGainEntries:Add(actionId, power)
    end
end

--- @return void
--- @param csv string
function HeroDataService:AddHeroCompanionBuffData(csv)
    local parsedData = CsvReader.ReadContent(csv)
    ---@type HeroCompanionBuffData
    local companionBuff
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id ~= nil then
            local id = tonumber(parsedData[i].id)

            companionBuff = HeroCompanionBuffData(id)
            companionBuff:ParseCsv(parsedData[i])

            self.heroCompanionBuffEntries:Add(id, companionBuff)
        end

        if companionBuff ~= nil then
            companionBuff:AddCondition(data)
        else
            assert(false)
        end
    end
end

---------------------------------------- Validate ----------------------------------------
--- @return void
function HeroDataService:Validate()
    assert(self.heroSkillLevelDataEntries ~= nil and self.heroSkillLevelDataEntries:Count() == HeroConstants.MAX_STAR)

    assert(self.formationDataEntries ~= nil and self.formationDataEntries:Count() == FormationConstants.NUMBER_FORMATION)

    assert(self.powerGainEntries ~= nil and self.powerGainEntries:Count() == HeroConstants.NUMBER_ACTION_GAIN_POWER)
end