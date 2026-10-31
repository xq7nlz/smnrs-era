--- @class GuildBossDefenderTeamConfig
GuildBossDefenderTeamConfig = Class(GuildBossDefenderTeamConfig)

function GuildBossDefenderTeamConfig:Ctor()
    --- @type Dictionary -- {bossId, List -- DefenderTeamData}
    self._defenderTeamDataDict = nil

    self:_Init()
end

function GuildBossDefenderTeamConfig:_Init()
    self._defenderTeamDataDict = Dictionary()

    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_BOSS_DEFENDER_TEAM_CONFIG_PATH)
    local listDefenderTeamData
    for _, v in ipairs(parsedData) do
        local bossId = tonumber(v['boss_id'])
        if MathUtils.IsInteger(bossId) then
            local newListDefenderTeamData = List()
            self._defenderTeamDataDict:Add(bossId, newListDefenderTeamData)
            listDefenderTeamData = self._defenderTeamDataDict:Get(bossId)
        end
        local data = DefenderTeamData(v)
        listDefenderTeamData:Add(data)
    end
end

--- @return List
--- @param bossId number
function GuildBossDefenderTeamConfig:GetListDefenderTeam(bossId)
    return self._defenderTeamDataDict:Get(bossId)
end



