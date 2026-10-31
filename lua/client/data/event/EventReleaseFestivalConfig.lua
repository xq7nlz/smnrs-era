--- @class EventReleaseFestivalConfig
EventReleaseFestivalConfig = Class(EventReleaseFestivalConfig)

function EventReleaseFestivalConfig:Ctor(pathFormat, dataId)
    --- @type List
    self.listDataConfig = nil
    self:_ReadCsv(pathFormat, dataId)
end

--- @return Dictionary
--- @param pathFormat string
--- @param dataId number
function EventReleaseFestivalConfig:_ReadCsv(pathFormat, dataId)
    local path = string.format(pathFormat, dataId)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s, %s", pathFormat, dataId))
        return
    end
    self.listDataConfig = List()
    for i = 1, #parsedData do
        --- @type {numberPlayer : number, rewardInBound : RewardInBound}
        local itemConfig = {}
        itemConfig.numberPlayer = tonumber(parsedData[i].number_player)
        itemConfig.rewardInBound = RewardInBound.CreateByParams(parsedData[i])
        self.listDataConfig:Add(itemConfig)
    end
    return self
end

--- @return Dictionary
function EventReleaseFestivalConfig:GetConfig()
    return self.listDataConfig
end

--- @return {numberPlayer : number, rewardInBound : RewardInBound}
--- @param dataIndex number
function EventReleaseFestivalConfig:GetItemConfigByIndex(dataIndex)
    return self.listDataConfig:Get(dataIndex)
end