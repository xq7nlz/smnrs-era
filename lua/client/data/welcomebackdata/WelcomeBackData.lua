require "lua.client.data.WelcomeBackData.WelcomeBackLoginConfig"
require "lua.client.data.WelcomeBackData.WelcomeBackQuestConfig"

local DURATION_PATH = "csv/comeback/duration_config.csv"

--- @class WelcomeBackData
WelcomeBackData = Class(WelcomeBackData)

function WelcomeBackData:Ctor()
    --- @type number
    self.duration = nil
    --- @type Dictionary
    self.loginDataDict = Dictionary()
    --- @type Dictionary
    self.questDataDict = Dictionary()

    self:GetDuration()
end

function WelcomeBackData:GetDuration()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(DURATION_PATH)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", DURATION_PATH))
        return
    end
    self.duration = tonumber(parsedData[1].comeback_duration) * TimeUtils.SecondADay
end

--- @return WelcomeBackLoginConfig
function WelcomeBackData:GetLoginData(dataId)
    local welcomeBackLoginConfig = self.loginDataDict:Get(dataId)
    if welcomeBackLoginConfig == nil then
        welcomeBackLoginConfig = WelcomeBackLoginConfig(dataId)
        self.loginDataDict:Add(dataId, welcomeBackLoginConfig)
    end
    return welcomeBackLoginConfig
end

--- @return WelcomeBackQuestConfig
function WelcomeBackData:GetQuestData(dataId)
    local welcomeBackQuestConfig = self.questDataDict:Get(dataId)
    if welcomeBackQuestConfig == nil then
        welcomeBackQuestConfig = WelcomeBackQuestConfig(dataId)
        self.questDataDict:Add(dataId, welcomeBackQuestConfig)
    end
    return welcomeBackQuestConfig
end

return WelcomeBackData