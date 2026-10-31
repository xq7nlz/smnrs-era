--- @class ServerLogMessage
ServerLogMessage = Class(ServerLogMessage)

---@param queuedLog QueuedLog
function ServerLogMessage:Ctor(queuedLog)
    ---@type number
    self.authProvider = nil
    ---@type string
    self.authToken = nil
    ---@type number
    self.playerId = nil
    ---@type string
    self.userName = nil
    ---@type number
    self.luaVersion = nil
    ---@type number
    self.csvVersion = nil
    ---@type number
    self.assetBundleVersion = nil
    ---@type string
    self.deviceModel = nil
    ---@type number
    self.deviceOS = nil
    ---@type number
    self.logType = queuedLog.type
    ---@type string
    self.logContent = string.format("%s:\n %s", queuedLog.message, queuedLog.stackTrace)
    self:InitBasicInfo()
end

function ServerLogMessage:InitBasicInfo()
    if PlayerSettingData then
        self.authProvider = PlayerSettingData.authProvider
        self.authToken = PlayerSettingData.authToken
        self.playerId = PlayerSettingData.playerId
        self.userName = PlayerSettingData.userName
    end
    self.assetBundleVersion = GOOGLE_SCRIPT.patch
    self.deviceModel = DEVICE_MODEL
    self.deviceOS = IS_ANDROID_PLATFORM and 20 or (IS_IOS_PLATFORM and 21 or 0)
end

---@return string
function ServerLogMessage:ToStringJson()
    local logJson = { }
    logJson['0'] = self.authProvider
    logJson['1'] = self.authToken
    logJson['2'] = self.playerId
    logJson['3'] = self.userName
    logJson['4'] = VERSION
    logJson['6'] = self.assetBundleVersion
    logJson['7'] = self.deviceModel
    logJson['8'] = self.deviceOS
    logJson['9'] = self.logType
    logJson['10'] = self.logContent
    return logJson
end

---@return string
function ServerLogMessage:ToJson()
    return json.encode(self:ToStringJson())
end

---@param list List
---@return string
function ServerLogMessage.ListToJson(list)
    ---@type List
    local resultList = List()
    ---@param v ServerLogMessage
    for _, v in ipairs(list:GetItems()) do
        resultList:Add(v:ToStringJson())
    end
    return json.encode(resultList:GetItems())
end
