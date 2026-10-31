--- @class TeamSummonerPredefine
TeamSummonerPredefine = Class(TeamSummonerPredefine)

--- @return void
function TeamSummonerPredefine:Ctor()
    --- @type number
    self.summonerPredefineId = nil
    --- @type number
    self.summonerId = nil
    ---@type List List<number>
    self.skills = List()
    --- @type boolean
    self.isDummy = nil
end

--- @return void
--- @param summonerPredefineId number
--- @param summonerId number
--- @param skills List<number>
function TeamSummonerPredefine:SetInfo(summonerPredefineId, summonerId, skills)
    self.summonerPredefineId = summonerPredefineId
    self.summonerId = summonerId
    self.skills = skills
end

--- @return void
--- @param data string
function TeamSummonerPredefine:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.summonerPredefineId = tonumber(data.id_team_summoner)
    self.summonerId = tonumber(data.summoner_id)

    for i = 1, SkillConstants.NUMBER_SKILL do
        if data[SkillConstants.SUMMONER_SKILL_TAG .. i] == nil then
            assert(false)
        end

        local level = tonumber(data[SkillConstants.SUMMONER_SKILL_TAG .. i])
        self.skills:Add(tonumber(level))
    end

    if data.is_dummy ~= nil then
        self.isDummy = MathUtils.ToBoolean(data.is_dummy)
    else
        self.isDummy = false
    end

    self:ValidateAfterParseCsv()
end

function TeamSummonerPredefine:ValidateBeforeParseCsv(data)
    if data.id_team_summoner == nil then
        assert(false)
    end

    if data.summoner_id == nil then
        assert(false)
    end
end

function TeamSummonerPredefine:ValidateAfterParseCsv()
    if MathUtils.IsNumber(self.summonerId) == false and self.summonerId < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.summonerPredefineId) == false or self.summonerPredefineId < 0 then
        assert(false)
    end
end
