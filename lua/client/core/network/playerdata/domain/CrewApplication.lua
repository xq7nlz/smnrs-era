--- @class CrewApplication
CrewApplication  = Class(CrewApplication )

function CrewApplication:Ctor(buffer)
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
    --- @type number
    self.lastLoginTime = nil

    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function CrewApplication:ReadBuffer(buffer)
    self.playerId = buffer:GetLong()
    self.playerName = buffer:GetString()
    self.playerAvatar = buffer:GetInt()
    self.playerLevel = buffer:GetShort()
    self.listHero = NetworkUtils.GetListDataInBound(buffer, HeroResource.CreateInstanceByBuffer)
    self.lastLoginTime = buffer:GetLong()
    self.avatarData = AvatarData(buffer)
end