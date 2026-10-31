require "lua.client.data.CampaignData.CampaignConfig"
require "lua.client.data.CampaignData.CampaignStageConfig"
require "lua.client.data.CampaignData.CampaignRewardConfig"
require "lua.client.data.CampaignData.CampaignBackgroundConfig"

--- @class CampaignDataConfig
CampaignDataConfig = Class(CampaignDataConfig)

function CampaignDataConfig:Ctor()
    --- @type CampaignConfig
    self.campaignConfig = nil
    --- @type CampaignStageConfig
    self.campaignStageConfig = nil
    --- @type CampaignRewardConfig
    self.campaignRewardConfig = nil
    --- @type Dictionary --<stage, level>
    self.levelRequiredDict = nil
    --- @type CampaignBackgroundConfig
    self.campaignBackgroundConfig = nil

    self:_InitCampaignConfig()
end

--- @return number
function CampaignDataConfig:GetCampaignStageConfigID()
    local val = zg.playerData:GetABTesting(FirebaseRemoteConfigKey.Campaign)
    if (val == nil) then
        val = -1
    end
    print(">>>> Client Used Campaign DataId ", val)
    return math.floor(val)
end

function CampaignDataConfig:InitData(id)
    if id == nil or id == -1 then
        self:_InitCampaignStageConfig()
    else
        self:_InitCampaignStageABConfig(id)
    end

    if zg ~= nil and zg.playerData ~= nil then
        local campaignData = zg.playerData:GetCampaignData()
        campaignData:SetNextStage(self.campaignStageConfig:GetNextStage(campaignData.stageCurrent))
    end
end

--- @return number
function CampaignDataConfig:GetTimeRewardMoney()
    return self.campaignConfig.timeRewardMoney
end

function CampaignDataConfig:GetMaxTimeIdle()
    return self.campaignConfig:GetMaxTimeIdle()
end

function CampaignDataConfig:_InitCampaignConfig()
    self.campaignConfig = CampaignConfig()
    local data = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_CONFIG_PATH)
    self.campaignConfig:ParseCsv(data)
end

function CampaignDataConfig:_InitCampaignStageConfig()
    local levelDesignContent = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_STAGE_PATH)
    self.campaignStageConfig = CampaignStageConfig()
    self.campaignStageConfig:ParseCsv()
end

--- @param dataId number
function CampaignDataConfig:_InitCampaignStageABConfig(dataId)
    local path = string.format(CsvPathConstants.CAMPAIGN_STAGE_PATH_AB_Test, dataId)
    local levelDesignContent = CsvReaderUtils.ReadAndParseLocalFile(path)
    self.campaignStageConfig = CampaignStageConfig()
    self.campaignStageConfig:ParseCsv(levelDesignContent, dataId)
end

--- @return DefenderTeamData
--- @param stageId number
function CampaignDataConfig:GetLevelRequired(stageId)
    if self.levelRequiredDict == nil then
        self.levelRequiredDict = Dictionary()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(CsvPathConstants.CAMPAIGN_LEVEL_REQUIRED_PATH)
        for _, v in ipairs(parsedData) do
            local stage = tonumber(v['stage'])
            local level = tonumber(v['level_required'])
            self.levelRequiredDict:Add(stage, level)
        end
    end
    return self.levelRequiredDict:Get(stageId)
end

--- @return DefenderTeamData
--- @param stageId number
function CampaignDataConfig:GetCampaignStageConfigById(stageId)
    return self.campaignStageConfig:GetCampaignStageConfigById(stageId)
end

--- @return CampaignStageConfig
function CampaignDataConfig:GetCampaignStageConfig()
    return self.campaignStageConfig
end

--- @return List<ItemIconData>
--- @param stageId number
function CampaignDataConfig:GetCampaignRewardById(stageId)
    if self.campaignRewardConfig == nil then
        self.campaignRewardConfig = CampaignRewardConfig()
        self.campaignRewardConfig:InitData()
    end
    return self.campaignRewardConfig:GetCampaignRewardById(stageId)
end

--- @return number
--- @param stageId number
--- @param fixedIndex number
function CampaignDataConfig:GetRandomBgByStage(stageId, fixedIndex)
    if self.campaignBackgroundConfig == nil then
        self.campaignBackgroundConfig = CampaignBackgroundConfig()
    end
    return self.campaignBackgroundConfig:GetRandomBgByStage(stageId, fixedIndex)
end

function CampaignDataConfig:GetNextStage(currentStage)
    if self.campaignStageConfig ~= nil then
        return self.campaignStageConfig:GetNextStage(currentStage)
    end
    return nil
end

return CampaignDataConfig