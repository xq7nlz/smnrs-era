--- @class BattleTeamInfo
BattleTeamInfo = Class(BattleTeamInfo)

--- @return void
function BattleTeamInfo:Ctor()
    --- @type number
    self.teamId = -1

    --- @type number
    self.formation = -1

    ---@type List --<HeroBattleInfo>
    self.listHeroInfo = List()

    ---@type SummonerBattleInfo
    self.summonerBattleInfo = nil

    ---@type Dictionary Dictionary<number, List<number>> key: class
    self.masteries = Dictionary()

    ---@type Dictionary Dictionary<number, number> key = id buff, value = number buff
    self.dungeonBuff = Dictionary()

    ---@type Dictionary Dictionary<number, number> key = linking group, value = bonus tier level
    self.linkingGroups = Dictionary()
end

--- @return void
--- @param formation number
function BattleTeamInfo:SetFormationId(formation)
    self.formation = formation
end

--- @return void
--- @param heroBattleInfo HeroBattleInfo
function BattleTeamInfo:AddHero(heroBattleInfo)
    if self.teamId == -1 then
        self.teamId = heroBattleInfo.teamId
    else
        if self.teamId ~= heroBattleInfo.teamId then
            assert(false)
        end
    end
    self.listHeroInfo:Add(heroBattleInfo)
end

--- @return void
--- @param summonerBattleInfo SummonerBattleInfo
function BattleTeamInfo:SetSummonerBattleInfo(summonerBattleInfo)
    self.summonerBattleInfo = summonerBattleInfo
end

--- @return void
--- @param class number
--- @param mastery1 number
--- @param mastery2 number
--- @param mastery3 number
--- @param mastery4 number
--- @param mastery5 number
--- @param mastery6 number
function BattleTeamInfo:AddMasteriesClass(class, mastery1, mastery2, mastery3, mastery4, mastery5, mastery6)
    --- @type List
    local list = List()
    list:Add(mastery1)
    list:Add(mastery2)
    list:Add(mastery3)
    list:Add(mastery4)
    list:Add(mastery5)
    list:Add(mastery6)
    self.masteries:Add(class, list)
end

---@return void
---@param team BattleTeam
function BattleTeamInfo:InitTeam(team)
    if self.formation <= 0 then
        assert(false)
    end

    --if self.listHeroInfo:Count() <= 0 then
    --    assert(false)
    --end

    team:SetFormationId(self.formation)
    for i = 1, self.listHeroInfo:Count() do
        ---@type HeroBattleInfo
        local infoHero = self.listHeroInfo:Get(i)
        infoHero:SetMasteries(self.masteries)
        ---@type BaseHero
        local hero = infoHero:CreateHero()
        if hero ~= nil then
            team:AddHero(hero)
        end
    end

    team:CreateHeroList()

    if self.summonerBattleInfo ~= nil then
        ---@type BaseHero
        local summoner = self.summonerBattleInfo:CreateSummoner()
        team:SetSummoner(summoner)
    end

    team:SetDungeonBuff(self.dungeonBuff)
    team:SetLinkingGroups(self.linkingGroups)
end

--- @return void
--- @param idBuff number
--- @param numberBuff number
function BattleTeamInfo:AddDungeonBuff(idBuff, numberBuff)
    self.dungeonBuff:Add(idBuff, numberBuff)
end

--- @param group number
--- @param tierLevel number
function BattleTeamInfo:AddLinkingGroup(group, tierLevel)
    self.linkingGroups:Add(group, tierLevel)
end
-----------------------------------PARSE CSV --------------------------------------
--- @return void
--- @param masteriesCsv string
function BattleTeamInfo:ParseCsvMasteries(masteriesCsv)
    local parsedData = CsvReader.ReadContent(masteriesCsv)

    self.masteries = Dictionary()
    for i = 1, #parsedData do
        local data = parsedData[i]

        local masteryLevels = List()
        for j = 1, SkillConstants.SUMMONER_NUMBER_MASTERY do
            if data[SkillConstants.SUMMONER_MASTERY_TAG .. j] == nil then
                assert(false)
            end

            local level = tonumber(data[SkillConstants.SUMMONER_MASTERY_TAG .. j])

            masteryLevels:Add(tonumber(level))
        end
        self.masteries:Add(i, masteryLevels)
    end
end

--- @return void
--- @param gameMode GameMode
--- @param isFrontLine boolean
--- @param position number
--- @param hpPercent number
--- @param powerValue number
function BattleTeamInfo:SetState(gameMode, isFrontLine, position, hpPercent, powerValue)
    local i = 1
    while i <= self.listHeroInfo:Count() do
        --- @type HeroBattleInfo
        local heroBattleInfo = self.listHeroInfo:Get(i)
        if heroBattleInfo.isFrontLine == isFrontLine and heroBattleInfo.position == position then
            if gameMode == GameMode.DUNGEON
                    or gameMode == GameMode.DEFENSE_MODE
                    or gameMode == GameMode.DEFENSE_MODE_RECORD
                    or gameMode == GameMode.EVENT_BOSS_CHALLENGE
                    or gameMode == GameMode.EVENT_KAZETSU_TRIAL then
                heroBattleInfo:SetState(hpPercent, powerValue)
            else
                heroBattleInfo:SetState(hpPercent, HeroConstants.DEFAULT_HERO_POWER)
            end
        end
        i = i + 1
    end
end

--- @return void
function BattleTeamInfo:RemoveUninitializedHeroes()
    local needRemovedHeroes = List()
    for i = 1, self.listHeroInfo:Count() do
        ---@type HeroBattleInfo
        local heroBattleInfo = self.listHeroInfo:Get(i)
        if heroBattleInfo.isInitialize == false then
            needRemovedHeroes:Add(heroBattleInfo)
        end
    end

    for i = 1, needRemovedHeroes:Count() do
        ---@type HeroBattleInfo
        local selectedHero = needRemovedHeroes:Get(i)
        self.listHeroInfo:RemoveOneByReference(selectedHero)
    end
end

--- @return List<HeroBattleInfo>
function BattleTeamInfo:GetListHero()
    return self.listHeroInfo
end
--- @param isFrontLine boolean
--- @return number
function BattleTeamInfo:GetLineLenght(isFrontLine)
    local lenght = 0
    for i = 1, self.listHeroInfo:Count() do
        if self.listHeroInfo:Get(i).isFrontLine == isFrontLine then
            lenght = lenght + 1
        end
    end
    return lenght
end