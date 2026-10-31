require("lua.client.data.Arena.ArenaRewardRankingConfig")

local ARENA_REWARD_PATH = "csv/arena/arena_reward.csv"
local ARENA_TEAM_REWARD_PATH = "csv/arena_team/arena_reward.csv"
local CHEST_REWARD_RATE = "csv/arena/chest_reward.csv"


--- @class ArenaRewardConfig
ArenaRewardConfig = Class(ArenaRewardConfig)

--- @return void
function ArenaRewardConfig:Ctor()
    ---@type List --<ArenaRewardRankingConfig>
    self.listArenaReward, self.totalArenaRankType = self:ReadData(ARENA_REWARD_PATH)
    self.listArenaReward:SortWithMethod(ArenaRewardConfig.SortArenaRewardRanking)

    ---@type List --<ArenaRewardRankingConfig>
    self.listArenaTeamReward, self.totalArenaTeamRankType = self:ReadData(ARENA_TEAM_REWARD_PATH)
    self.listArenaTeamReward:SortWithMethod(ArenaRewardConfig.SortArenaRewardRanking)

    ---@type Dictionary
    self.listArenaChestRewardConfig = Dictionary()
    self:ReadArenaChestRewardConfig()
end

--- @return List
function ArenaRewardConfig:ReadData(path)
    local listReward = List()
    local totalArenaRankType = 0
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type number
    local rankType
    ---@type number
    local eloMin
    ---@type number
    local eloMax
    --- @type ClientHero
    local data
    for i = 1, #parsedData do
        if parsedData[i]["rank_type"] ~= nil then
            data = ArenaRewardRankingConfig()
            data:ParseCsv(parsedData[i])
            rankType = data.rankType
            eloMin = data.eloMin
            eloMax = data.eloMax
            data:AddReward(parsedData[i])
            listReward:Add(data)
            totalArenaRankType = totalArenaRankType + 1
        else
            if parsedData[i]["reward_top"] ~= nil then
                data = ArenaRewardRankingConfig()
                data:ParseCsv(parsedData[i])
                data.rankType = rankType
                data.eloMin = eloMin
                data.eloMax = eloMax
                data:AddReward(parsedData[i])

                if listReward:Count() > 0 then
                    --- @type ArenaRewardRankingConfig
                    local dataUp = listReward:Get(listReward:Count())
                    dataUp.topMax = data.topMin - 1
                else
                    XDebug.Error(path)
                end
                listReward:Add(data)
            else
                data = listReward:Get(listReward:Count())
                data.rankType = rankType
                data.eloMin = eloMin
                data.eloMax = eloMax
                data:AddReward(parsedData[i])
            end
        end
    end
    return listReward, totalArenaRankType
end

--- @return ArenaRewardRankingConfig
--- @param top number
--- @param featureType FeatureType
function ArenaRewardConfig:GetArenaTopRanking(top, featureType)
    featureType = featureType or FeatureType.ARENA
    if featureType == FeatureType.ARENA then
        return self.listArenaReward:Get(top)
    else
        return self.listArenaTeamReward:Get(top)
    end
end

function ArenaRewardConfig:ReadArenaChestRewardConfig()
    ---@type List
    self.listArenaChestRewardConfig = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CHEST_REWARD_RATE)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", CHEST_REWARD_RATE))
        return
    end
    local lastChestId= nil
    for i = 1, #parsedData do
        if parsedData[i]["chest_id"] ~= nil then
            lastChestId = tonumber(parsedData[i]["chest_id"])
            self.listArenaChestRewardConfig:Add(lastChestId,List())
            self.listArenaChestRewardConfig:Get(lastChestId):Add(
                    RewardInBound.CreateByParamsArenaChest(parsedData[i]):GetSelectionIconData())
        else
            self.listArenaChestRewardConfig:Get(lastChestId):Add(
                    RewardInBound.CreateByParamsArenaChest(parsedData[i]):GetSelectionIconData())
        end
    end
end

function ArenaRewardConfig:GetArenaChestRewardConfig(arenaChestId)
    return self.listArenaChestRewardConfig:Get(arenaChestId)
end


--- @return List
--- @param elo Number
function ArenaRewardConfig:GetRankingTypeByElo(elo, featureType)
    local listArenaReward
    if featureType == FeatureType.ARENA then
        listArenaReward = self.listArenaReward
    else
        listArenaReward = self.listArenaTeamReward
    end
    if elo ~= nil then
        ---@param v ArenaRewardRankingConfig
        for _, v in ipairs(listArenaReward:GetItems()) do
            if (v.eloMin <= elo or v.eloMin < 0) and (v.eloMax >= elo or v.eloMax < 0) then
                return v.rankType
            end
        end
    end
    return listArenaReward:Get(listArenaReward:Count()).rankType
end

--- @return ArenaRewardRankingConfig
---@param rankType number
---@param top number
function ArenaRewardConfig:GetArenaRewardRankingConfigByRankType(rankType, top, featureType)
    featureType = featureType or FeatureType.ARENA
    local listArenaReward
    if featureType == FeatureType.ARENA then
        listArenaReward = self.listArenaReward
    else
        listArenaReward = self.listArenaTeamReward
    end
    local rewardRanking
    ---@param v ArenaRewardRankingConfig
    for i, v in ipairs(listArenaReward:GetItems()) do
        if (rankType == v.rankType and
                (v.topMax == nil or v.topMax >= top)) then
            rewardRanking = v
            break
        end
    end
    return rewardRanking
end

--- @return ArenaRewardRankingConfig
---@param x ArenaRewardRankingConfig
---@param y ArenaRewardRankingConfig
function ArenaRewardConfig.SortArenaRewardRanking(x, y)
    if (x.rankType > y.rankType) then
        return -1
    elseif (x.rankType < y.rankType) then
        return 1
    else
        if (x.topMin < y.topMin) then
            return -1
        else
            return 1
        end
    end
end

return ArenaRewardConfig