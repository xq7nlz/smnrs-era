--- @class KazetsuTowerRewardConfig : CampaignRewardConfig
KazetsuTowerRewardConfig = Class(KazetsuTowerRewardConfig, TowerRewardConfig)

--- @return List<ItemIconData>
--- @param levelId number
function KazetsuTowerRewardConfig:GetReward(levelId)
    if self.rewardConfig == nil then
        local rewardContent = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.KAZETSU_TOWER_REWARD_PATH)
        require "lua.client.data.Tower.TowerRewardConfig"
        self.rewardConfig = TowerRewardConfig()
        self.rewardConfig:ParseCsv(rewardContent)
    end
    return self.rewardConfig:GetTowerRewardById(levelId)
end