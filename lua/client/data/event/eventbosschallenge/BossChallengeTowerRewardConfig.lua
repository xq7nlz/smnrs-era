--- @class BossChallengeTowerRewardConfig : TowerRewardConfig
BossChallengeTowerRewardConfig = Class(BossChallengeTowerRewardConfig, TowerRewardConfig)

--- @return List<ItemIconData>
--- @param levelId number
function BossChallengeTowerRewardConfig:GetReward(levelId, path)
    if self.rewardConfig == nil then
        local rewardContent = CsvReaderUtils.ReadAndParseLocalFile(path)
        require "lua.client.data.Tower.TowerRewardConfig"
        self.rewardConfig = TowerRewardConfig()
        self.rewardConfig:ParseCsv(rewardContent)
    end
    return self.rewardConfig:GetTowerRewardById(levelId)
end

--- @return List<ItemIconData>
--- @param levelId number
function BossChallengeTowerRewardConfig:GetRewardPremiumPass(levelId, path)
    self.rewardConfig = nil
    local rewardContent = CsvReaderUtils.ReadAndParseLocalFile(path)
    require "lua.client.data.Tower.TowerRewardConfig"
    self.rewardConfig = TowerRewardConfig()
    self.rewardConfig:ParseCsv(rewardContent)
    return self.rewardConfig:GetTowerRewardById(levelId)
end

--- @return List<ItemIconData>
--- @param levelId number
function BossChallengeTowerRewardConfig:GetRewardLoop(levelId, path)
    if self.rewardLoopConfig == nil then
        local rewardContent = CsvReaderUtils.ReadAndParseLocalFile(path)
        require "lua.client.data.Event.EventBossChallenge.BossChallengeTowerLoopRewardConfig"
        self.rewardLoopConfig = BossChallengeTowerLoopRewardConfig()
        self.rewardLoopConfig:ParseCsv(rewardContent)
    end
    return self.rewardLoopConfig:GetTowerRewardById(levelId)
end

--- @return List<ItemIconData>
function BossChallengeTowerRewardConfig:GetAllRewardLoop(path)
    if self.rewardLoopConfig == nil then
        local rewardContent = CsvReaderUtils.ReadAndParseLocalFile(path)
        require "lua.client.data.Event.EventBossChallenge.BossChallengeTowerLoopRewardConfig"
        self.rewardLoopConfig = BossChallengeTowerLoopRewardConfig()
        self.rewardLoopConfig:ParseCsv(rewardContent)
    end
    return self.rewardLoopConfig.rewardDictionary
end