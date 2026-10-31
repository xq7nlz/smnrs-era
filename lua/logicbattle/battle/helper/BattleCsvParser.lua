--- @class BattleCsvParser
BattleCsvParser = Class(BattleCsvParser)

--- @return void
--- @param battle Battle
function BattleCsvParser:Ctor(battle)
    --- @type Battle
    self.battle = battle
end

---------------------------------------- Parse Csv ----------------------------------------
--- @return void
--- @param battleCsv string
--- @param masteryCsv string
function BattleCsvParser:ParseCsv(battleCsv, masteryCsv)
    local masteries = self:ParseMastery(masteryCsv)

    --print("Hero data: \n" .. battleCsv)
    local parsedData = CsvReader.ReadContent(battleCsv)

    local seed = tonumber(parsedData[1].seed)
    if MathUtils.IsInteger(seed) then
        if seed < 0 then
            seed = math.random(1, 999999999)
            --print("Seed: " .. seed)
            --seed = 123456
        end

        self.battle._randomHelper:SetSeed(seed)
        self.battle.battleResult:SetSeed(seed)
    end

    for i = 1, #parsedData do
        local data = parsedData[i]

        local heroId = tonumber(data.hero_id)
        assert(MathUtils.IsInteger(heroId) and heroId >= 0)

        self:ParseHero(heroId, data, masteries)
    end

    local team = self.battle:GetTeamById(BattleConstants.ATTACKER_TEAM_ID)
    team:CreateHeroList()

    team = self.battle:GetTeamById(BattleConstants.DEFENDER_TEAM_ID)
    team:CreateHeroList()
end

--- @return BaseHero
--- @param heroId number
--- @param data table
--- @param masteries Dictionary<number, List<number>>
function BattleCsvParser:ParseHero(heroId, data, masteries)
    local hero
    if heroId >= HeroConstants.FACTION_HERO_ID_DELTA then
        hero = self:CreateHero(heroId, data, masteries)

        local team = self.battle:GetTeamById(hero.teamId)
        team:AddHero(hero)
    else
        hero = self:CreateSummoner(heroId, data)

        local team = self.battle:GetTeamById(hero.teamId)
        team:SetSummoner(hero)
    end

    local formationId = tonumber(data.formation_id)
    if MathUtils.IsInteger(formationId) then
        local team = self.battle:GetTeamById(hero.teamId)
        team:SetFormationId(formationId)
    end
end

--- @return BaseHero
--- @param heroId number
--- @param data table
--- @param masteries Dictionary<number, List<number>>
function BattleCsvParser:CreateHero(heroId, data, masteries)
    local heroLuaFile = require(string.format(LuaPathConstants.HERO_PATH, heroId, heroId))
    local hero = heroLuaFile:CreateInstance()

    local heroCsvParser = HeroCsvParser(hero)
    heroCsvParser:ParseCsv(data)
    heroCsvParser:SetMasteryDataList(masteries)

    return hero
end

--- @return BaseHero
--- @param summonerClass number
--- @param data table
function BattleCsvParser:CreateSummoner(summonerClass, data)
    local isDummySummoner = false
    if data.is_dummy ~= nil then
        isDummySummoner = MathUtils.ToBoolean(data.is_dummy)
    end

    local summonerLuaFile
    if summonerClass ~= HeroConstants.SUMMONER_NOVICE_ID then
        summonerLuaFile = require(string.format(LuaPathConstants.SUMMONER_PATH, summonerClass, summonerClass))
        if isDummySummoner == true then
            assert(false)
        end
    else
        summonerLuaFile = require(LuaPathConstants.SUMMONER_NOVICE_PATH)
    end

    local summoner = summonerLuaFile:CreateInstance()
    if isDummySummoner then
        summoner.isDummy = isDummySummoner
    end

    local summonerCsvParser = SummonerCsvParser(summoner)
    summonerCsvParser:ParseCsv(data)

    return summoner
end

--- @return Dictionary<number, List<number>> key: heroClass
--- @param masteriesCsv string
function BattleCsvParser:ParseMastery(masteriesCsv)
    --print("Mastery data: \n" .. masteriesCsv)
    local parsedData = CsvReader.ReadContent(masteriesCsv)

    local masteries = Dictionary()
    for i = 1, #parsedData do
        local data = parsedData[i]

        local masteryLevels = List()
        for j = 1, SkillConstants.SUMMONER_NUMBER_MASTERY do
            assert(data[SkillConstants.SUMMONER_MASTERY_TAG .. j] ~= nil)
            local level = tonumber(data[SkillConstants.SUMMONER_MASTERY_TAG .. j])

            masteryLevels:Add(tonumber(level))
        end

        masteries:Add(i, masteryLevels)
    end

    return masteries
end