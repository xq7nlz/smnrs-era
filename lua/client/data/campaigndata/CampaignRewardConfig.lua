--- @class CampaignRewardConfig
CampaignRewardConfig = Class(CampaignRewardConfig)

function CampaignRewardConfig:Ctor()
    --- @type Dictionary--<number, List<ItemIconData>>
    self.rewardDictionary = Dictionary()
    --- @type Dictionary--<number, number>
    self.expTrainDictionary = Dictionary()
end

function CampaignRewardConfig:InitData(idABTest)
    if idABTest and idABTest > 0 then
        print(">>>> Client Set Campaign reward DataId: ", idABTest)
        local rewardAbTestPath = string.format(CsvPathConstants.CAMPAIGN_REWARD_AB_TEST, idABTest)
        self:ParseCsvOptimize(CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_REWARD_PATH_OPTIMIZE), CsvReaderUtils.ReadAndParseLocalFile(rewardAbTestPath))
    else
        local val = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.CampaignReward)
        print(">>>> Client Get and Set Campaign reward DataId: ", val)
        if val > 0 then
            local rewardAbTestPath = string.format(CsvPathConstants.CAMPAIGN_REWARD_AB_TEST, val)
            self:ParseCsvOptimize(CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_REWARD_PATH_OPTIMIZE), CsvReaderUtils.ReadAndParseLocalFile(rewardAbTestPath))
        else
            self:ParseCsvOptimize(CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_REWARD_PATH_OPTIMIZE))
        end
    end
end

--- @data string
function CampaignRewardConfig:ParseCsv(parsedData)
    local lastStageId = 0
    local currentStageId = 0

    for _, v in ipairs(parsedData) do
        currentStageId = tonumber(v['stage'])
        local itemIconData = RewardInBound.CreateByParams(v):GetIconData()
        if MathUtils.IsInteger(currentStageId) then
            lastStageId = currentStageId
        end
        local listRewardLastLevel = self.rewardDictionary:Get(lastStageId)
        if listRewardLastLevel == nil then
            listRewardLastLevel = List()
        end
        listRewardLastLevel:Add(itemIconData)
        self.rewardDictionary:Add(lastStageId, listRewardLastLevel)
    end
end

--- @data string
function CampaignRewardConfig:ParseCsvOptimize(parsedData, parsedDataABTest)
    local lastStageId = 0
    local currentStageId = 0
    local listRewardLastLevel = nil

    for _, v in ipairs(parsedData) do
        currentStageId = tonumber(v['stage'])
        local itemIconData = RewardInBound.CreateByParams(v):GetIconData()
        if MathUtils.IsInteger(currentStageId) then
            lastStageId = currentStageId
            listRewardLastLevel = List()
            for i = tonumber(v['stage1']), currentStageId do
                self.rewardDictionary:Add(i, listRewardLastLevel)
            end
        end
        listRewardLastLevel:Add(itemIconData)
    end
    if parsedDataABTest then
        ---@type List
        local listABTestReward
        local stageId
        for _, v in ipairs(parsedDataABTest) do
            if tonumber(v['stage']) then
                stageId = tonumber(v['stage'])
                listABTestReward = List()
                self.rewardDictionary:Add(stageId, listABTestReward)
            end
            listABTestReward:Add(RewardInBound.CreateByParams(v):GetIconData())
        end
    end
end

--- @return List<ItemIconData>
--- @param stageId number
function CampaignRewardConfig:GetCampaignRewardById(stageId)
    if self.rewardDictionary:IsContainKey(stageId) then
        return self.rewardDictionary:Get(stageId)
    end
    XDebug.Log("There is no reward config for campaign id", stageId)
end

return CampaignRewardConfig