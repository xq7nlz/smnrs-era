--- @class GuildDungeonStatisticsInBound
GuildDungeonStatisticsInBound = Class(GuildDungeonStatisticsInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildDungeonStatisticsInBound:Ctor(buffer)
    --- @type number
    self.playerId = buffer:GetLong()
    --- @type number
    self.playerName = buffer:GetString()
    --- @type number
    self.playerAvatar = buffer:GetInt()
    --- @type number
    self.playerLevel = buffer:GetShort()
    --- @type number
    self.playerScore = buffer:GetLong()
    --- @type number
    self.numberAttack = buffer:GetShort()
end

--- @param key string
function GuildDungeonStatisticsInBound:UpdateInfoByKey(key, newValue)
    if key == "name" then
        self.playerName = newValue
    elseif key == "avatar" then
        self.playerAvatar = newValue
    elseif key == "level" then
        self.playerLevel = newValue
    else
        XDebug.Error("RankingItemInBound:UpdateInfoByKey Not Fount Key " .. key)
    end
end