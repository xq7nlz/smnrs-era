--- @class EventLoginConfig
EventLoginConfig = Class(EventLoginConfig)

function EventLoginConfig:Ctor()
    --- @type Dictionary
    self.loginRewardDict = nil
end

--- @return Dictionary
--- @param pathFormat string
--- @param dataId number
function EventLoginConfig:GetConfig(pathFormat, dataId)
    local path = string.format(pathFormat, dataId)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s, %s", pathFormat, dataId))
        return
    end
    if self.loginRewardDict == nil then
        self.loginRewardDict = Dictionary()
        for i = 1, #parsedData do
            local day = tonumber(parsedData[i].day)
            self.loginRewardDict:Add(day, RewardInBound.CreateByParams(parsedData[i]))
        end
    end
    return self.loginRewardDict
end