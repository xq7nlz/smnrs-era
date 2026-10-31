--- @class RankingItemInBound
RankingItemInBound = Class(RankingItemInBound)

--- @return void
function RankingItemInBound:Ctor()
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
end

--- @return RankingItemInBound
--- @param buffer UnifiedNetwork_ByteBuf
function RankingItemInBound.CreateByBuffer(buffer)
    local data = RankingItemInBound()
    data.id = buffer:GetLong()
    data.serverId = buffer:GetShort()
    data.name = buffer:GetString()
    data.avatar = buffer:GetInt()
    data.level = buffer:GetShort()
    data.score = buffer:GetLong()
    data.createdTime = buffer:GetLong()
    ---@type AvatarData
    data.avatarData = AvatarData(buffer)
    return data
end

--- @return string
function RankingItemInBound:GetName()
    if self.id == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).name
    else
        return self.name
    end
end

--- @return number
function RankingItemInBound:GetAvatar()
    if self.id == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).avatarData:GetMyPlayerAvatar()
    else
        return self.avatarData:GetOtherPlayerAvatar()
    end
end

--- @return number
function RankingItemInBound:GetLevel()
    if self.id == PlayerSettingData.playerId then
        return zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
    else
        return self.level
    end
end

--- @return string
function RankingItemInBound:ToString()
    return LogUtils.ToDetail(self)
end

--- @param key string
function RankingItemInBound:UpdateInfoByKey(key, newValue)
    if key == "name" then
        self.name = newValue
    elseif key == "avatar" then
        self.avatar = newValue
    elseif key == "level" then
        self.level = newValue
    else
        XDebug.Error("RankingItemInBound:UpdateInfoByKey Not Fount Key " .. key)
    end
end
