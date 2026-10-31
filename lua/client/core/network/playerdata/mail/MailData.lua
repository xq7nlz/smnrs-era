--- @class MailData
MailData = Class(MailData)

--- @return void
function MailData:Ctor()
    --- @type number
    self.mailId = nil
    --- @type SenderType
    self.senderType = nil
    --- @type string
    self.subject = nil
    --- @type string
    self.content = nil
    --- @type string
    self.subjectLocalizeKey = nil
    --- @type string
    self.contentLocalizeKey = nil
    --- @type List
    self.listReward = nil
    --- @type string
    self.senderName = nil
    --- @type number
    self.senderPlayerId = nil
    --- @type MailState
    self.mailState = nil
    --- @type number
    self.createTime = nil
    --- @type List
    self.listMetaDataSubject = nil
    --- @type List
    self.listMetaDataContent = nil
    --- @type number
    self.claimTime = nil
end

--- @return MailData
--- @param buffer UnifiedNetwork_ByteBuf
function MailData.CreateByBuffer(buffer)
    local data = MailData()
    data.mailId = buffer:GetString()
    data.senderType = buffer:GetByte()
    if data.senderType ~= SenderType.SYSTEM then
        data.subject = buffer:GetString(false)
        data.content = buffer:GetString(false)
    else
        data.subjectLocalizeKey = buffer:GetString()
        data.contentLocalizeKey = buffer:GetString()
    end
    data.listReward = NetworkUtils.GetRewardInBoundList(buffer)
    data.senderName = buffer:GetString()
    data.senderPlayerId = buffer:GetLong()
    data.mailState = buffer:GetByte()
    data.createTime = buffer:GetLong()
    if data.senderType == SenderType.SYSTEM then
        local size = buffer:GetByte()
        data.listMetaDataSubject = List()
        for i = 1, size do
            data.listMetaDataSubject:Add(buffer:GetString(false))
        end
        size = buffer:GetByte()
        data.listMetaDataContent = List()
        for i = 1, size do
            data.listMetaDataContent:Add(buffer:GetString(false))
        end
    end
    --XDebug.Log("MailData" .. data:ToString())
    return data
end

--- @return MailData
--- @param jsonDatabase table
function MailData.CreateByJson(jsonDatabase)
    local data = MailData()
    data.mailId = jsonDatabase['0']
    data.senderType = tonumber(jsonDatabase['8'])
    if data.senderType ~= SenderType.SYSTEM then
        data.subject = jsonDatabase['1']
        data.content = jsonDatabase['2']
    else
        data.subjectLocalizeKey = jsonDatabase['3']
        data.contentLocalizeKey = jsonDatabase['4']
    end
    data.listReward = NetworkUtils.GetListDataJson(jsonDatabase['5'], RewardInBound.CreateByJson)
    data.senderName = jsonDatabase['6']
    data.senderPlayerId = tonumber(jsonDatabase['7'])
    data.mailState = tonumber(jsonDatabase['9'])
    data.createTime = tonumber(jsonDatabase['10'])
    if data.senderType == SenderType.SYSTEM then
        data.listMetaDataSubject = List()
        for _, metaSubject in pairs(jsonDatabase['12']) do
            data.listMetaDataSubject:Add(metaSubject)
        end
        data.listMetaDataContent = List()
        for _, metaContent in pairs(jsonDatabase['13']) do
            data.listMetaDataContent:Add(metaContent)
        end
    end

    --XDebug.Log("MailData" .. data:ToString())
    return data
end

--- @return boolean
function MailData:IsPlayerMail()
    return self.senderType == SenderType.PLAYER
end

--- @return boolean
function MailData:CanDelete()
    return self.mailState == MailState.REWARD_RECEIVED or (self.listReward:Count() == 0)
end

--- @return string
function MailData:GetSubject()
    if self.subjectLocalizeKey ~= nil then
        return self:_GetLocalizeMail(self.subjectLocalizeKey, self.listMetaDataSubject)
    elseif self.subject ~= nil then
        return self.subject
    else
        return ""
    end
end

--- @return string
function MailData:GetContent()
    if self.contentLocalizeKey ~= nil then
        return self:_GetLocalizeMail(self.contentLocalizeKey, self.listMetaDataContent)
    elseif self.content ~= nil then
        return self.content
    else
        return ""
    end
end

--- @return boolean
--- @param key string
--- @param listMetaData List
function MailData:_GetLocalizeMail(key, listMetaData)
    if listMetaData:Count() > 0 then
        --XDebug.Log(listMetaData:Count())
        local replace = function(v)
            return tostring(listMetaData:Get(tonumber(v)))
        end
        --return string.gsub(LanguageUtils.LocalizeMail(key), "{.-}", replace,10)
        local content = LanguageUtils.LocalizeMail(key)
        for i = 1, listMetaData:Count() do
            local pattern = string.format("{%d}", i)
            local repl = listMetaData:Get(i)
            content = string.gsub(content, pattern, repl)
        end
        return content
    else
        return LanguageUtils.LocalizeMail(key)
    end
end

--- @return boolean
function MailData:CanNotification()
    return self.mailState == MailState.NEW or (self.listReward:Count() > 0 and self.mailState ~= MailState.REWARD_RECEIVED)
end

--- @return boolean
function MailData:SortValue()
    if self.mailState == MailState.NEW then
        return 1
    elseif self:CanDelete() then
        return 3
    else
        return 2
    end
end

--- @return string
function MailData:ToString()
    local str = "MailData" .. LogUtils.ToDetail(self) .. "\nList" .. self.listReward:Count()
    for _, v in ipairs(self.listReward:GetItems()) do
        str = str .. "\nDataReward" .. LogUtils.ToDetail(v)
    end
    return str
end

function MailData:GetLocalizeSender()
    if self.senderType == SenderType.PLAYER then
        return self.senderName
    elseif self.senderType == SenderType.SYSTEM then
        return LanguageUtils.LocalizeCommon("system_mail")
    elseif self.senderType == SenderType.ADMIN then
        return LanguageUtils.LocalizeCommon("admin_mail")
    elseif self.senderType == SenderType.MODERATOR then
        return LanguageUtils.LocalizeCommon("moderator_mail")
    end
end

--- @return number
--- @param x MailData
--- @param y MailData
function MailData.SortMail(x, y)
    if y:SortValue() > x:SortValue() then
        return -1
    elseif y:SortValue() < x:SortValue() then
        return 1
    else
        if y.createTime < x.createTime then
            return -1
        else
            return 1
        end
    end
end