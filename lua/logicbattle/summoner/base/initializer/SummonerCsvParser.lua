--- @class SummonerCsvParser
SummonerCsvParser = Class(SummonerCsvParser)

--- @return void
--- @param hero BaseSummoner
function SummonerCsvParser:Ctor(hero)
    --- @type BaseSummoner
    self.myHero = hero
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param data string Csv line to parse
function SummonerCsvParser:ParseCsv(data)
    self.myHero.id = tonumber(data.hero_id)
    self.myHero.teamId = tonumber(data.team_id)
    local isFrontLine = false
    local position = 1
    self.myHero.positionInfo:SetPosition(isFrontLine, position)

    self.myHero.star = tonumber(data.star)
    self.myHero.level = tonumber(data.level)

    --- parse skill level
    for i = 1, SkillConstants.NUMBER_SKILL do
        assert(data[SkillConstants.SUMMONER_SKILL_TAG .. i] ~= nil)
        local level = tonumber(data[SkillConstants.SUMMONER_SKILL_TAG .. i])

        if self.myHero.id == HeroConstants.SUMMONER_NOVICE_ID then
            assert(level == self.myHero.star)
        end

        self.myHero.skillLevels:Add(tonumber(level))
    end

    self.myHero.equipmentController:ParseCsv(data)
    self.myHero.isSummoner = true
end