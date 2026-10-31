--- @class CrewMemberBasicInfo
CrewMemberBasicInfo = Class(CrewMemberBasicInfo)

function CrewMemberBasicInfo:Ctor(buffer)
    --- @type number
    self.playerId = nil
    --- @type string
    self.name = nil
    --- @type number
    self.avatar = nil
    --- @type number
    self.level = nil

    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function CrewMemberBasicInfo:ReadBuffer(buffer)
    self.playerId = buffer:GetLong()
    self.name = buffer:GetString()
    self.avatar = buffer:GetInt()
    self.level = buffer:GetShort()
    self.avatarData = AvatarData(buffer)
end