--- @class EventArenaRankingConfig
EventArenaRankingConfig = Class(EventArenaRankingConfig)

function EventArenaRankingConfig:Ctor(pathFormat, dataId)
    --- @type Dictionary
    self.arenaRankingRewardDict = nil
    self:InitData(pathFormat, dataId)
end

--- @param pathFormat string
--- @param dataId number
function EventArenaRankingConfig:InitData(pathFormat, dataId)
    local path = string.format(pathFormat, dataId)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s, %s", pathFormat, dataId))
        return
    end
    self.arenaRankingRewardDict = Dictionary()
    local rankType
    for i = 1, #parsedData do
        local number = tonumber(parsedData[i].rank_type)
        local listReward
        if MathUtils.IsNumber(number) then
            rankType = number
            listReward = List()
            self.arenaRankingRewardDict:Add(rankType, listReward)
        else
            listReward = self.arenaRankingRewardDict:Get(rankType)
        end
        listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
    end
end

--- @return Dictionary
function EventArenaRankingConfig:GetConfig()
    return self.arenaRankingRewardDict
end

function EventArenaRankingConfig:GetListRewardIconData(rankType)
    local listRewardIconData = List()
    local listRewardInBound = self.arenaRankingRewardDict:Get(rankType)
    for i = 1, listRewardInBound:Count() do
        --- @type RewardInBound
        local rewardInBound = listRewardInBound:Get(i)
        listRewardIconData:Insert(rewardInBound:GetIconData(), 1)
    end
    return listRewardIconData
end