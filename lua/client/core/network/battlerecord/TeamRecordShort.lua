--- @class TeamRecordShort
TeamRecordShort = Class(TeamRecordShort)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function TeamRecordShort:Ctor(buffer)
    if buffer ~= nil then
        ---@type number
        self.playerId = buffer:GetLong()
        ---@type string
        self.playerName = buffer:GetString()
        ---@type number
        self.playerAvatar = buffer:GetInt()
        ---@type number
        self.playerLevel = buffer:GetShort()
        --- @type AvatarData
        self.avatarData = AvatarData(buffer)
    end
end