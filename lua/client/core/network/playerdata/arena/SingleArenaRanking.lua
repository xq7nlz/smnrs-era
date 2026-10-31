--- @class SingleArenaRanking
SingleArenaRanking = Class(SingleArenaRanking)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SingleArenaRanking:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end


--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function SingleArenaRanking:ReadBuffer(buffer)
    self:ReadBufferWithoutPower(buffer)
    --- @type number
    self.power = buffer:GetLong()
end

function SingleArenaRanking:ReadBufferWithoutPower(buffer)
    --- @type number
    self.playerId = buffer:GetLong()
    --- @type number
    self.serverId = buffer:GetShort()
    --- @type number
    self.playerName = buffer:GetString()
    --- @type number
    self.playerAvatar = buffer:GetInt()
    --- @type number
    self.playerLevel = buffer:GetShort()
    --- @type number
    self.score = buffer:GetLong()
    --- @type number
    self.createdTIme = buffer:GetLong()
    --- @type AvatarData
    self.avatarData = AvatarData(buffer)
end

--- @param key string
function SingleArenaRanking:UpdateInfoByKey(key, newValue)
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