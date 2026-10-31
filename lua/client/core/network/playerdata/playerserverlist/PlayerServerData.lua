--- @class PlayerServerData
PlayerServerData = Class(PlayerServerData)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerServerData:Ctor(buffer)
    ---@type number
    self.serverId = buffer:GetShort()
    ---@type string
    self.playerName = buffer:GetString()
    ---@type number
    --self.playerAvatar = buffer:GetInt()
    ---@type AvatarData
    self.avatarData = AvatarData(buffer)
    ---@type number
    self.playerLevel = buffer:GetShort()
end