--- @class AvatarData
AvatarData = Class(AvatarData)


--- @param buffer UnifiedNetwork_ByteBuf
function AvatarData:Ctor(buffer)
    ---@type number
    self.playerAvatar = nil
    ---@type number
    self.avatarID = nil
    ---@type number
    self.borderID = nil
    ---@type number
    self.avatarExpiredTime = nil
    ---@type number
    self.frameExpiredTime = nil
    ---@type number
    self.previousAvatar = nil
    ---@type number
    self.previousFrame = nil
    if buffer then
        self:ReadBuffer(buffer)
    end
end

function AvatarData:UpdateByAvatarAndBorderID(_avatarID,_borderID)
    self.avatarID = _avatarID
    self.borderID = _borderID
    self.playerAvatar = ClientConfigUtils.GetAvatar(_avatarID,_borderID)
    self.avatarExpiredTime =  ClientConfigUtils.GetAvatarExpiredTime(_avatarID)
    self.frameExpiredTime =  ClientConfigUtils.GetFrameExpiredTime(_borderID)

end
--- @type number
function AvatarData:GetOtherPlayerAvatar()
    --- @type number
    local avatarID = self:GetOtherAvatar()
    --- @type number
    local borderID = self:GetOtherFrame()
    return ClientConfigUtils.GetAvatar(avatarID,borderID)
end

--- @type number
--- @param number
function AvatarData.GetDuration(frameID)
    ---@type AvatarItemConfig
    local frameItemConfig = ResourceMgr.GetAvatarConfig().frameItemDict[frameID]
    return frameItemConfig.timeDuration * TimeUtils.SecondADay
end

--- @type number
--- @param number
function AvatarData.GetDuration(avatarID)
    ---@type AvatarItemConfig
    local avatarItemConfig = ResourceMgr.GetAvatarConfig().avatarItemDict[avatarID]
     return avatarItemConfig.timeDuration * TimeUtils.SecondADay
end
--- @param number
function AvatarData:GetOtherAvatar()
    if (ClientConfigUtils.AvatarFrameIsExpired(self.avatarExpiredTime)) then
        return self.previousAvatar
    else
        return self.avatarID
    end
end
function AvatarData:GetOtherFrame()
    if (ClientConfigUtils.AvatarFrameIsExpired( self.frameExpiredTime)) then
        return self.previousFrame
    else
        return self.borderID
    end
end

--- @param number
function AvatarData:GetAvatar()
    --- @type boolean
    local isExpired =  ClientConfigUtils.AvatarIsExpired(self.avatarID)
    if (isExpired) then
        return self.previousAvatar
    else
        return self.avatarID
    end
end

--- @param number
function AvatarData:GetFrame()
--[[    local expiredTime = ClientConfigUtils.GetFrameExpiredTime(self.borderID)
    XDebug.Log("id " .. tostring(self.borderID) .. " EXPIRED TIME " .. tostring(expiredTime))]]

    if (ClientConfigUtils.FrameIsExpired(self.borderID)) then
        return self.previousFrame
    else
        return self.borderID
    end
end
--- @type number
function AvatarData:GetMyPlayerAvatar()
    local avatar = self:GetAvatar()
    local border = self:GetFrame()
    return ClientConfigUtils.GetAvatar(avatar,border)
end
--- @param buffer UnifiedNetwork_ByteBuf
function AvatarData:ReadBuffer(buffer)

    self.playerAvatar = buffer:GetInt()
    self.avatarID, self.borderID = ClientConfigUtils.GetAvatarId(self.playerAvatar)
    self.avatarExpiredTime = buffer:GetLong()
    self.frameExpiredTime = buffer:GetLong()
    self.previousAvatar = buffer:GetInt()
    self.previousFrame = buffer:GetInt()
end

