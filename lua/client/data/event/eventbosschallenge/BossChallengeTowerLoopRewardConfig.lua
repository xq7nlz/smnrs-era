--- @class BossChallengeTowerLoopRewardConfig
BossChallengeTowerLoopRewardConfig = Class(BossChallengeTowerLoopRewardConfig)

function BossChallengeTowerLoopRewardConfig:Ctor()
    --- @type Dictionary<number, List<ItemIconData>>
    self.rewardDictionary = Dictionary()
end

--- @data string
function BossChallengeTowerLoopRewardConfig:ParseCsv(parsedData)
    local lastLevelId = 0
    local currentLevelId = 0

    for _, v in pairs(parsedData) do
        currentLevelId = tonumber(v['team_id'])
        local itemIconData = RewardInBound.CreateByParams(v):GetIconData()
        if MathUtils.IsInteger(currentLevelId) then
            lastLevelId = currentLevelId
        end
        local listRewardLastLevel = self.rewardDictionary:Get(lastLevelId)
        if listRewardLastLevel == nil then
            listRewardLastLevel = List()
        end
        listRewardLastLevel:Add(itemIconData)
        self.rewardDictionary:Add(lastLevelId, listRewardLastLevel)
    end
end

--- @return List<ItemIconData>
--- @param levelId number
function BossChallengeTowerLoopRewardConfig:GetTowerRewardById(levelId)
    if self.rewardDictionary:IsContainKey(levelId) then
        return self.rewardDictionary:Get(levelId)
    end
    XDebug.Log("There is no reward config for tower level", levelId)
end