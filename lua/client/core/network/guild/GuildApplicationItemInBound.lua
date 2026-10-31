--- @class GuildApplicationItemInBound
GuildApplicationItemInBound = Class(GuildApplicationItemInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildApplicationItemInBound:Ctor(buffer)
    --- @type number
    self.playerId = buffer:GetLong()
    --- @type string
    self.playerName = buffer:GetString()
    --- @type number
    self.playerAvatar = buffer:GetInt()
    --- @type number
    self.playerLevel = buffer:GetShort()
    --- @type number
    self.createdTime = buffer:GetLong()
end