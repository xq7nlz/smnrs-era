--- @class KazetsuRanking
KazetsuRanking = Class(KazetsuRanking)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function KazetsuRanking:Ctor(buffer)
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end


--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function KazetsuRanking:ReadBuffer(buffer)
    self:ReadBufferWithoutPower(buffer)
end

function KazetsuRanking:ReadBufferWithoutPower(buffer)
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
function KazetsuRanking:UpdateInfoByKey(key, newValue)
    if key == "name" then
        self.playerName = newValue
    elseif key == "avatar" then
        self.playerAvatar = newValue
    elseif key == "level" then
        self.playerLevel = newValue
    else
        XDebug.Error("KazetsuRanking:UpdateInfoByKey Not Fount Key " .. key)
    end
end