--- @class GuildMemberInBound
GuildMemberInBound = Class(GuildMemberInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildMemberInBound:Ctor(buffer)
    --- @type number
    self.playerId = buffer:GetLong()
    --- @type string
    self.playerName = buffer:GetString()
    --- @type number
    self.playerAvatar = buffer:GetInt()
    --- @type number
    self.playerLevel = buffer:GetShort()
    --- @type number
    self.lastLoginTimeInSec = buffer:GetLong()
    --- @type number
    self.lastCheckInTimeInSec = buffer:GetLong()
    --- @type AvatarData
    self.avatarData = AvatarData(buffer)
end

--- @param key string
function GuildMemberInBound:UpdateInfoByKey(key, newValue)
    if key == "name" then
        self.playerName = newValue
    elseif key == "avatar" then
        self.playerAvatar = newValue
    elseif key == "level" then
        self.playerLevel = newValue
    else
        XDebug.Error("SingleArenaRanking:UpdateInfoByKey Not Fount Key " .. key)
    end
end