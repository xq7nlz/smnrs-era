--- @class CampaignConfig
CampaignConfig = Class(CampaignConfig)

--- @return void
function CampaignConfig:Ctor()
    ---@type number
    self.maxTime = nil
    ----@type number
    self.timeRewardMoney = nil
    ----@type number
    self.timeRewardItem = nil
    ----@type number
    self.autoTrainSlot = nil
    ----@type number
    self.trainStarMax = nil
    ----@type Dictionary
    self.trainSlotIncrementLevel = Dictionary()
end

--- @return void
--- @param parsedData string
function CampaignConfig:ParseCsv(parsedData)
    local dataContent = parsedData[1]
    self.maxTime = tonumber(dataContent["max_idle_time"])
    self.timeRewardMoney = tonumber(dataContent["idle_interval_generate_money"])
    self.timeRewardItem = tonumber(dataContent["idle_interval_generate_item"])
    self.autoTrainSlot = tonumber(dataContent["auto_train_slot"])
    self.trainStarMax = tonumber(dataContent["train_star_max"])
    for k, v in ipairs(parsedData) do
        self.trainSlotIncrementLevel:Add(tonumber(v["train_slot_increment_level"]), k)
    end
end

--- @return void
function CampaignConfig:GetMaxTimeIdle()
    local vipData = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    if vipData ~= nil and vipData.campaignBonusIdleTimeMax ~= nil then
        return self.maxTime + vipData.campaignBonusIdleTimeMax
    else
        return self.maxTime
    end
end