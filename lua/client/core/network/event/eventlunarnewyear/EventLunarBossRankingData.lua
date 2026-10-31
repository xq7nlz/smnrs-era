--- @class EventLunarBossRankingData
EventLunarBossRankingData = Class(EventLunarBossRankingData)

--- @param buffer UnifiedNetwork_ByteBuf
function EventLunarBossRankingData:Ctor(buffer)
    --- @type number
    self.guildId = buffer:GetInt()
    --- @type number
    self.serverId = buffer:GetShort()
    --- @type string
    self.guildName = buffer:GetString()
    --- @type number
    self.guildAvatar = buffer:GetInt()
    --- @type number
    self.guildLevel = buffer:GetShort()
    --- @type number
    self.score = buffer:GetLong()
    --- @type number
    self.createdTimeInSec = buffer:GetLong()
end