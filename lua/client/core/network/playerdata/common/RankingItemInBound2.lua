--- @class RankingItemInBound2
RankingItemInBound2 = Class(RankingItemInBound2)

--- @return void
function RankingItemInBound2:Ctor()
    --- @type number
    self.id = nil
    --- @type number
    self.serverId = nil
    --- @type string
    self.name = nil
    --- @type number
    self.avatar = nil
    --- @type number
    self.level = nil
    --- @type number
    self.score = nil
    --- @type number
    self.createdTime = nil
    --- @type number
    self.power = nil
end

--- @return RankingItemInBound2
--- @param buffer UnifiedNetwork_ByteBuf
function RankingItemInBound2.CreateByBuffer(buffer)
    local data = RankingItemInBound2()
    data.id = buffer:GetLong()
    data.serverId = buffer:GetShort()
    data.name = buffer:GetString()
    data.avatar = buffer:GetInt()
    data.level = buffer:GetShort()
    data.score = buffer:GetLong()
    data.createdTime = buffer:GetLong()
    data.avatarData = AvatarData(buffer)
    data.power = buffer:GetLong()
    return data
end

--- @return string
function RankingItemInBound2:GetName()
    if self.id == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
    else
        return self.name
    end
end

--- @return number
function RankingItemInBound2:GetAvatar()
    if self.id == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).avatar
    else
        return self.avatar
    end
end

--- @return number
function RankingItemInBound2:GetLevel()
    if self.id == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    else
        return self.level
    end
end

--- @return string
function RankingItemInBound2:ToString()
    return LogUtils.ToDetail(self)
end

--- @param key string
function RankingItemInBound2:UpdateInfoByKey(key, newValue)
    if key == "name" then
        self.name = newValue
    elseif key == "avatar" then
        self.avatar = newValue
    elseif key == "level" then
        self.level = newValue
    else
        XDebug.Error("RankingItemInBound2:UpdateInfoByKey Not Fount Key " .. key)
    end
end
