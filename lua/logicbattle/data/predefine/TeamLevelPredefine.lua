--- @class TeamLevelPredefine
TeamLevelPredefine = Class(TeamLevelPredefine)

--- @return void
function TeamLevelPredefine:Ctor()
    --- @type number
    self.teamLevelId = -1

    --- @type number
    self.summonerLevel = -1

    --- @type List<number>
    self.heroLevel = List()
end

--- @return void
--- @param data string
function TeamLevelPredefine:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.teamLevelId = tonumber(data.id_team_level)
    self.summonerLevel = tonumber(data.summoner_level)

    for i = 1, FormationConstants.NUMBER_SLOT do
        local level = tonumber(data[PredefineConstants.HERO_SLOT .. i])
        assert(MathUtils.IsInteger(level))

        self.heroLevel:Add(level)
    end

    self:ValidateAfterParseCsv()
end

--- @return void
--- @param data string
function TeamLevelPredefine:ParseTeamId(data)
    self.teamLevelId = data
    self.summonerLevel = data % 100

    local heroLevel = math.floor(data / 100)
    for i = 1, FormationConstants.NUMBER_SLOT do
        self.heroLevel:Add(heroLevel)
    end
end

--- @return void
function TeamLevelPredefine:ValidateBeforeParseCsv(data)
    if data.id_team_level == nil then
        assert(false)
    end

    if data.summoner_level == nil then
        assert(false)
    end
end

--- @return void
function TeamLevelPredefine:ValidateAfterParseCsv()
    if MathUtils.IsInteger(self.teamLevelId) == false or self.teamLevelId < 0 then
        assert(false)
    end

    if self.heroLevel:Count() ~= 5 then
        assert(false)
    end
end