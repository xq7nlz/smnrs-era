--- @class TeamStarPredefine
TeamStarPredefine = Class(TeamStarPredefine)

--- @return void
function TeamStarPredefine:Ctor()
    --- @type number
    self.teamStarId = -1

    --- @type number
    self.summonerStar = -1

    --- @type List<number>
    self.heroStar = List()
end

--- @return void
--- @param data string
function TeamStarPredefine:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.teamStarId = tonumber(data.id_team_star)
    self.summonerStar = tonumber(data.summoner_star)

    for i = 1, FormationConstants.NUMBER_SLOT do
        local star = tonumber(data[PredefineConstants.HERO_SLOT .. i])
        assert(MathUtils.IsInteger(star))

        self.heroStar:Add(star)
    end

    self:ValidateAfterParseCsv()
end

--- @return void
function TeamStarPredefine:ValidateBeforeParseCsv(data)
    if data.id_team_star == nil then
        assert(false)
    end

    if data.summoner_star == nil then
        assert(false)
    end
end

--- @return void
function TeamStarPredefine:ValidateAfterParseCsv()
    if MathUtils.IsNumber(self.teamStarId) == false or self.teamStarId < 0 then
        assert(false)
    end

    if self.heroStar:Count() ~= 5 then
        assert(false)
    end
end