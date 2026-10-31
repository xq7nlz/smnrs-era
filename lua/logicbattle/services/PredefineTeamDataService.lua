--- @class PredefineTeamDataService
PredefineTeamDataService = Class(PredefineTeamDataService)

--- @return void
function PredefineTeamDataService:Ctor()
    --- @type HeroDataService
    self.heroDataService = nil

    ---@type TeamSummonerPredefine
    self.defaultTeamSummonerId = nil

    ---@type TeamLevelPredefine
    self.defaultTeamLevelId = nil

    ---@type TeamStarPredefine
    self.defaultTeamStarId = nil

    ---@type BossStatPredefine
    self.defaultBossStat = nil

    --- key: idTeamSummoner
    --- @type Dictionary<number, TeamSummonerPredefine>
    self.summonerDict = StrictDictionary()

    --- key: idTeamFormation
    --- @type Dictionary<number, FormationData>
    self.formationDict = StrictDictionary()

    --- key: teamLevelId
    --- @type Dictionary<number, TeamLevelPredefine>
    self.levelDict = StrictDictionary()

    --- key: teamStarId
    --- @type Dictionary<number, TeamStarPredefine>
    self.starDict = StrictDictionary()

    --- key: teamItemId
    --- @type Dictionary<number, TeamItemPredefine>
    self.itemDict = StrictDictionary()

    --- key: idTeamMastery
    --- @type Dictionary<number, TeamMasteryPredefine>
    self.masteryDict = StrictDictionary()

    --- key: idTeamHero
    --- @type Dictionary<number, TeamHeroPredefine>
    self.heroDict = StrictDictionary()

    --- key: idBossStat
    --- @type Dictionary<number, BossStatPredefine>
    self.bossStatDict = StrictDictionary()

    --- key: idBossSlot
    --- @type Dictionary<number, BossSlotPredefine>
    self.bossSlotDict = StrictDictionary()
end

---------------------------------------- Getters ----------------------------------------
--- @return BattleTeamInfo
--- @param predefineTeamData PredefineTeamData
function PredefineTeamDataService:GetBattleTeamInfo(predefineTeamData, _teamId)
    local teamBattleInfo = BattleTeamInfo()
    local teamId = _teamId or predefineTeamData.teamId

    --- @type TeamSummonerPredefine
    local teamSummoner = self.summonerDict:GetOrDefault(predefineTeamData.teamSummonerId, self.defaultSummoner)

    --- @type TeamLevelPredefine
    local teamLevel = self.levelDict:GetOrDefault(predefineTeamData.teamLevelId, self.defaultLevel)
    if IS_CLIENT_RUNNING == true and teamLevel == self.defaultLevel then
        teamLevel = TeamLevelPredefine()
        teamLevel:ParseTeamId(predefineTeamData.teamLevelId)
    end

    --- @type TeamStarPredefine
    local teamStar = self.starDict:GetOrDefault(predefineTeamData.teamStarId, self.defaultStar)

    --- @type TeamItemPredefine
    local teamItem = self.itemDict:Get(predefineTeamData.teamItemId)

    --- @type TeamMasteryPredefine
    local teamMastery = self.masteryDict:Get(predefineTeamData.teamMasteryId)
    if teamMastery ~= nil then
        teamBattleInfo.masteries = teamMastery.masteryLevels
    end

    ---@type FormationData
    local formation = self.heroDataService:GetFormationData(predefineTeamData.formationId)
    teamBattleInfo:SetFormationId(predefineTeamData.formationId)

    local summonerBattleInfo = SummonerBattleInfo()
    if teamSummoner ~= nil then
        summonerBattleInfo:SetInfo(teamId, teamSummoner.summonerId, teamStar.summonerStar, teamLevel.summonerLevel)
        summonerBattleInfo:SetDummy(teamSummoner.isDummy)
        summonerBattleInfo:SetSkillList(teamSummoner.skills)
    else
        summonerBattleInfo:SetTeamId(teamId)
    end
    teamBattleInfo:SetSummonerBattleInfo(summonerBattleInfo)

    ---@type BossSlotPredefine
    local bossSlot = self.bossSlotDict:Get(predefineTeamData.bossSlotId)
    for i = 1, BattleConstants.NUMBER_SLOT do
        local heroId = predefineTeamData.heroList:Get(i)

        if heroId ~= nil and heroId > 0 then
            local heroBattleInfo = HeroBattleInfo()

            heroBattleInfo:SetInfo(teamId, heroId, teamStar.heroStar:Get(i), teamLevel.heroLevel:Get(i))
            heroBattleInfo:SetPosition(formation:GetIsFrontLine(i), formation:GetPosition(i))

            if teamItem ~= nil then
                local itemDict = teamItem:GetItem(i)
                heroBattleInfo:SetItemsDict(itemDict)
            end

            if bossSlot ~= nil then
                local bossStat = bossSlot.bossStatList:Get(i)
                if bossStat < 0 then
                    heroBattleInfo:SetBoss(false, nil)
                else
                    heroBattleInfo:SetBoss(true, self.bossStatDict:GetOrDefault(bossStat, self.defaultBossStat))
                end
            end

            teamBattleInfo:AddHero(heroBattleInfo)
        end
    end

    return teamBattleInfo
end

--- @return BattleTeamInfo
--- @param dataStage DefenderTeamData
function PredefineTeamDataService:GetBattleTeamInfoByDefenderTeamData(dataStage)
    return self:GetBattleTeamInfo(dataStage:GetPredefineTeamData())
end

--- @return BossStatPredefine
--- @param bossId number
function PredefineTeamDataService:GetBossStatById(bossId)
    return self.bossStatDict:Get(bossId)
end

--- @return void
--- @param predefineTeamData PredefineTeamData
function PredefineTeamDataService:Validate(predefineTeamData)
    local teamSummoner = self.summonerDict:Get(predefineTeamData.teamSummonerId)
    if predefineTeamData.teamSummonerId > 0 then
        assert(teamSummoner ~= nil, "teamSummonerId = " .. predefineTeamData.teamSummonerId)
    end

    assert(1 <= predefineTeamData.formationId and predefineTeamData.formationId <= FormationConstants.NUMBER_FORMATION,
            "formationId = " .. predefineTeamData.formationId)

    local teamLevel = self.levelDict:Get(predefineTeamData.teamLevelId)
    assert(teamLevel ~= nil, "teamLevelId = " .. predefineTeamData.teamLevelId)

    local teamStar = self.starDict:Get(predefineTeamData.teamStarId)
    assert(teamStar ~= nil, "teamStarId = " .. predefineTeamData.teamStarId)

    local bossSlot = self.bossSlotDict:Get(predefineTeamData.bossSlotId)
    if predefineTeamData.bossSlotId ~= PredefineConstants.NON_BOSS_SLOT then
        assert(bossSlot ~= nil, "bossSlotId = " .. predefineTeamData.bossSlotId)
    end

    local isHaveHero = false
    for _, heroId in pairs(predefineTeamData.heroList:GetItems()) do
        if heroId > 0 then
            assert(self.heroDataService:GetHeroDataEntry(heroId) ~= nil, "heroId = " .. heroId)
            isHaveHero = true
        end
    end

    assert(isHaveHero)
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param heroDataService HeroDataService
function PredefineTeamDataService:SetDependencies(heroDataService)
    self.heroDataService = heroDataService
end

--- @return void
--- @param csvSummoner string
function PredefineTeamDataService:SetSummonerPredefine(csvSummoner)
    local parsedData = CsvReader.ReadContent(csvSummoner)
    for i = 1, #parsedData do
        local summonerPredefine = TeamSummonerPredefine()
        summonerPredefine:ParseCsv(parsedData[i])
        self.summonerDict:Add(summonerPredefine.summonerPredefineId, summonerPredefine)

        if self.defaultSummoner == nil then
            self.defaultSummoner = summonerPredefine
        end
    end
end

--- @return void
--- @param csvStar string
function PredefineTeamDataService:SetTeamStarData(csvStar)
    local parsedData = CsvReader.ReadContent(csvStar)
    for i = 1, #parsedData do
        local starPredefine = TeamStarPredefine()
        starPredefine:ParseCsv(parsedData[i])
        self.starDict:Add(starPredefine.teamStarId, starPredefine)

        if self.defaultStar == nil then
            self.defaultStar = starPredefine
        end
    end
end

--- @return void
--- @param csvPower string
function PredefineTeamDataService:SetTeamLevelData(csvPower)
    local parsedData = CsvReader.ReadContent(csvPower)
    for i = 1, #parsedData do
        local levelPredefine = TeamLevelPredefine()
        levelPredefine:ParseCsv(parsedData[i])
        self.levelDict:Add(levelPredefine.teamLevelId, levelPredefine)

        if self.defaultLevel == nil then
            self.defaultLevel = levelPredefine
        end
    end
end

--- @return void
--- @param csvItem string
function PredefineTeamDataService:SetTeamItemData(csvItem)
    local parsedData = CsvReader.ReadContent(csvItem)
    ---@type TeamItemPredefine
    local itemPredefine
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id_team_item ~= nil then
            local id = tonumber(data.id_team_item)
            itemPredefine = TeamItemPredefine(id)
            self.itemDict:Add(id, itemPredefine)
        end

        itemPredefine:ParseCsv(data)
    end
end

--- @return void
--- @param csvMastery string
function PredefineTeamDataService:SetTeamMasteryData(csvMastery)
    local parsedData = CsvReader.ReadContent(csvMastery)
    ---@type TeamMasteryPredefine
    local masteryPredefine
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.id_team_mastery ~= nil then
            local id = tonumber(data.id_team_mastery)
            masteryPredefine = TeamMasteryPredefine(id)
            self.masteryDict:Add(id, masteryPredefine)
        end

        masteryPredefine:ParseCsv(data)
    end
end

--- @return void
--- @param csvBossSlot string
function PredefineTeamDataService:SetBossSlot(csvBossSlot)
    local parsedData = CsvReader.ReadContent(csvBossSlot)
    for i = 1, #parsedData do
        local bossSlotPredefine = BossSlotPredefine()
        bossSlotPredefine:ParseCsv(parsedData[i])
        self.bossSlotDict:Add(bossSlotPredefine.id, bossSlotPredefine)
    end
end

--- @return void
--- @param csvTeam string
function PredefineTeamDataService:SetBossStatMultiplierList(csvTeam)
    local parsedData = CsvReader.ReadContent(csvTeam)
    ---@type BossStatPredefine
    local bossStatPredefine
    for i = 1, #parsedData do
        local data = parsedData[i]

        local bossId = tonumber(data.boss_id)
        if MathUtils.IsInteger(bossId) then
            bossStatPredefine = BossStatPredefine()
            self.bossStatDict:Add(bossId, bossStatPredefine)

            if self.defaultBossStat == nil then
                self.defaultBossStat = bossStatPredefine
            end
        end

        local type = tonumber(data.type)
        if type == OriginStatChangerType.BASE_STAT then
            bossStatPredefine:ParseBaseStatMultiplier(data)
        elseif type == OriginStatChangerType.LEVEL_UP_STAT then
            bossStatPredefine:ParseGrowStatMultiplier(data)
        elseif type == OriginStatChangerType.BASE_STAT_ADDER then
            bossStatPredefine:ParseBaseStatAdder(data)
        end
    end
end