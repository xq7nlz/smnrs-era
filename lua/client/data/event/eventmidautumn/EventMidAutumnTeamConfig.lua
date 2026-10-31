require "lua.client.data.DefenderTeamData"
--- @class EventMidAutumnTeamConfig
EventMidAutumnTeamConfig = Class(EventMidAutumnTeamConfig)

function EventMidAutumnTeamConfig:Ctor()
    --- @type Dictionary --<number, DefenderTeamData>
    self._dataDictionary = Dictionary()
    self.eventModel = nil
end

--- @data string
function EventMidAutumnTeamConfig:ParseCsv(parsedData)
    for k, v in ipairs(parsedData) do
        local stageId = tonumber(v['stage'])
        if MathUtils.IsInteger(stageId) then
            local data = DefenderTeamData(v)
            self._dataDictionary:Add(data.stage, data)
        end
    end
end

--- @return DefenderTeamData
function EventMidAutumnTeamConfig:GetTeamConfigByDay(levelId)
    if self._dataDictionary:IsContainKey(levelId) == true then
        return self._dataDictionary:Get(levelId)
    end
    XDebug.Error(string.format("No tower level config: %d", levelId))
    return 0
end

--- @return List
function EventMidAutumnTeamConfig:GetListHeroResourceByDay(levelId)
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    --- @type BattleTeamInfo
    self.attackerBattleInfo = self.eventModel:GetConfig():GetListLineupAttackerRecommendation(levelId)
    self.teamStarId = self.attackerBattleInfo.summonerBattleInfo.star
    --- @type DefenderTeamData
    local attackerTeam = self:GetTeamConfigByDay(levelId)
    --- @type PredefineTeamData
    self.predefineTeamData = attackerTeam.predefineTeamData
    --- @type Dictionary
    self.heroList = self.predefineTeamData.heroList
    self.teamLevel = TeamLevelPredefine()
    self.teamLevel:ParseTeamId(self.predefineTeamData.teamLevelId)
    self.listHeroResource = List()
    for i = 1, BattleConstants.NUMBER_SLOT do
        local teamLevel = TeamLevelPredefine()
        teamLevel:ParseTeamId(self.predefineTeamData.teamLevelId)

        local heroResource = HeroResource.CreateInstance(self.heroList:Get(i), self.heroList:Get(i), self.teamStarId , self.teamLevel.heroLevel:Get(i))
        self.listHeroResource:Add(heroResource)
    end

    return self.listHeroResource
end