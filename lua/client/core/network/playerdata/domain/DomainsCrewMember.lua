--- @class DomainsCrewMember
DomainsCrewMember  = Class(DomainsCrewMember )

function DomainsCrewMember:Ctor(buffer)
    --- @type number
    self.playerId = nil
    --- @type string
    self.playerName = nil
    --- @type number
    self.playerAvatar = nil
    --- @type number
    self.playerLevel = nil
    --- @type List
    self.listHero = List()
    --- @type boolean
    self.isReady = nil
    ---@type AvatarData
    self.avatarData = nil
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DomainsCrewMember:ReadBuffer(buffer)
    self.playerId = buffer:GetLong()
    self.playerName = buffer:GetString()
    self.playerAvatar = buffer:GetInt()
    self.playerLevel = buffer:GetShort()
    self.avatarData = AvatarData(buffer)
    self.listHero = NetworkUtils.GetListDataInBound(buffer, HeroResource.CreateInstanceByBuffer)
    self.isReady = buffer:GetBool()
    self.lastOnlineTime = buffer:GetLong()
end