--- @class GuildWarEloPositionConfig
GuildWarEloPositionConfig = Class(GuildWarEloPositionConfig)

function GuildWarEloPositionConfig:Ctor()
    --- @type Dictionary
    self._eloDict = nil
    self:_InitConfig()
end

function GuildWarEloPositionConfig:_InitConfig()
    if self._eloDict == nil then
        self._eloDict = Dictionary()
        local parsedCsv = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_WAR_ELO_POSITION_CONFIG)
        for i = 1, #parsedCsv do
            local position = tonumber(parsedCsv[i].position)
            local elo = tonumber(parsedCsv[i].elo)
            self._eloDict:Add(position, elo)
        end
    end
end

--- @return Dictionary
function GuildWarEloPositionConfig:GetEloConfigDict()
    return self._eloDict
end

--- @return number
--- @param position number
function GuildWarEloPositionConfig:GetEloByPosition(position)
    return self._eloDict:Get(position)
end

--- @return number
--- @param position number
function GuildWarEloPositionConfig:GetBasePointByMedal(position, medal)
    local baseElo = self:GetEloByPosition(position)
    return baseElo * medal
end

--- @return number
function GuildWarEloPositionConfig:GetTotalElo()
    local total = 0
    local slotMedal = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarConfig().numberMedal
    for k, v in pairs(self._eloDict:GetItems()) do
        total = total + v * slotMedal
    end
    return total
end
