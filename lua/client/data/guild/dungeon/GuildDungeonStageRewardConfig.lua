--- @class GuildDungeonStageRewardConfig
GuildDungeonStageRewardConfig = Class(GuildDungeonStageRewardConfig)

function GuildDungeonStageRewardConfig:Ctor()
    --- @type List
    self._listRangeStageRewardConfig = nil
end

--- @return RewardByStageRangeConfig
--- @param stage number
function GuildDungeonStageRewardConfig:GetStageRewardByStage(stage)
    if self._listRangeStageRewardConfig == nil then
        self:_ReadStageRewardConfig()
    end
    for i = 1, self._listRangeStageRewardConfig:Count() do
        --- @type RewardByStageRangeConfig
        local rewardByStageRangeConfig = self._listRangeStageRewardConfig:Get(i)
        if stage >= rewardByStageRangeConfig.minStagePassed
                and (stage <= rewardByStageRangeConfig.maxStagePassed
                or rewardByStageRangeConfig.maxStagePassed == -1) then
            return rewardByStageRangeConfig
        end
    end
    return nil
end

function GuildDungeonStageRewardConfig:_ReadStageRewardConfig()
    require "lua.client.data.Guild.Dungeon.RewardByStageRangeConfig"
    self._listRangeStageRewardConfig = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.GUILD_DUNGEON_STAGE_REWARD_PATH)
    --- @type RewardByStageRangeConfig
    local currentRewardByRangeConfig
    for i = 1, #parsedData do
        local minStagePassed = parsedData[i].min_stage_passed
        local maxStagePassed = parsedData[i].max_stage_passed
        if minStagePassed ~= nil and maxStagePassed ~= nil then
            currentRewardByRangeConfig = RewardByStageRangeConfig(tonumber(minStagePassed), tonumber(maxStagePassed))
            self._listRangeStageRewardConfig:Add(currentRewardByRangeConfig)
        end
        currentRewardByRangeConfig:AddRewardByData(parsedData[i])
    end
end

--- @return List
function GuildDungeonStageRewardConfig:GetListSpecialReward()
end