--- @class GuildDungeonTeamConfig
GuildDungeonTeamConfig = Class(GuildDungeonTeamConfig)

function GuildDungeonTeamConfig:Ctor()
    --- @type Dictionary | DefenderTeamData
    self._defenderTeamDict = nil
    --- @type List | DefenderTeamData
    self._listSpecialStageData = nil
end

function GuildDungeonTeamConfig:_InitDefenderTeam()
    self._defenderTeamDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DUNGEON_DEFENDER_TEAM_PATH)
    for i = 1, #parsedData do
        local struct = parsedData[i]
        --- @type DefenderTeamData
        local defenderTeamData = DefenderTeamData(struct)
        self._defenderTeamDict:Add(defenderTeamData.stage, defenderTeamData)
    end
end

function GuildDungeonTeamConfig:_InitSpecialDefenderTeam()
    self._listSpecialStageData = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DUNGEON_DEFENDER_TEAM_SPECIAL_STAGE_PATH)
    for i = 1, #parsedData do
        local struct = parsedData[i]
        --- @type DefenderTeamData
        local defenderTeamData = DefenderTeamData(struct)
        self._listSpecialStageData:Add(defenderTeamData)
    end
end

--- @return Dictionary
function GuildDungeonTeamConfig:GetDefenderTeamConfig()
    if self._defenderTeamDict == nil then
        self:_InitDefenderTeam()
    end
    return self._defenderTeamDict
end

--- @return DefenderTeamData
function GuildDungeonTeamConfig:GetDefenderTeamDataByStage(stage)
    return self:GetDefenderTeamConfig():Get(stage)
end

--- @return List
function GuildDungeonTeamConfig:GetListSpecialStage()
    if self._listSpecialStageData == nil then
        self:_InitSpecialDefenderTeam()
    end
    return self._listSpecialStageData
end