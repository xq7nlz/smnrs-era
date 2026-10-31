--- @class CrewMemberSearchInfo
CrewMemberSearchInfo = Class(CrewMemberSearchInfo)

function CrewMemberSearchInfo:Ctor(buffer)
    --- @type boolean
    self.isInCrew = nil
    --- @type number
    self.playerId = nil
    --- @type string
    self.playerName = nil
    --- @type number
    self.playerAvatar = nil
    --- @type number
    self.playerLevel = nil
    --- @type number
    self.lastOnlineTime = nil
    --- @type boolean
    self.alreadyInvite = nil

    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function CrewMemberSearchInfo:ReadBuffer(buffer)
    self.isInCrew = buffer:GetBool()
    self.playerId = buffer:GetLong()
    self.playerName = buffer:GetString()
    self.playerAvatar = buffer:GetInt()
    self.playerLevel = buffer:GetShort()
    self.avatarData = AvatarData(buffer)
    self.lastOnlineTime = buffer:GetLong()
    self.alreadyInvite = buffer:GetBool()
end