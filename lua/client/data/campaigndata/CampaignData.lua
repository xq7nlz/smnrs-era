require "lua.client.data.CampaignData.ProductionCampaign"
require "lua.client.core.network.campaign.IdleDurationCampaign"

--- @class CampaignData
CampaignData = Class(CampaignData)

--- @return void
function CampaignData:Ctor()
    --- @type CampaignDifficultLevel
    self.currentDifficultLevel = CampaignDifficultLevel.Normal
    --- @type number
    self.currentMapId = 1

    ---- @type number
    self.stageCurrent = nil
    ---- @type number
    self.stageNext = nil
    ---- @type number
    self.stageIdle = nil

    ---@type IdleDurationCampaign
    self.idleResources = nil
    ---@type IdleDurationCampaign
    self.idleItems = nil
    ---@type IdleDurationCampaign
    self.idleTraining = nil
    ---@type List
    self.trainingSlotExp = List()

    ---@type List --<ProductionCampaign>
    self.listProductionCampaign = List()

    ---@type number
    self.timeReachHighestStage = nil

    ---@type number
    self.quickBattleBuyTurn = nil

    ---@type Dictionary
    self.quickBattleTicketDict = nil

    --- @type number
    self.lastStage = nil
end

--- @return void
--- @param jsonDatabase table
function CampaignData:InitDatabase(jsonDatabase)
    if jsonDatabase == nil then
        return
    end
    self.stageCurrent = tonumber(jsonDatabase['0'])
    self.stageIdle = tonumber(jsonDatabase['1'])

    local nextStage = ResourceMgr.GetCampaignDataConfig():GetNextStage(self.stageCurrent)
    if nextStage ~= nil then
        self:SetNextStage(nextStage)
    end
    --self.stageNext = ResourceMgr.GetCampaignDataConfig().campaignStageConfig:GetNextStage(self.stageCurrent)
    --self.currentDifficultLevel, self.currentMapId = ClientConfigUtils.GetIdFromStageId(self.stageNext)

    self.idleResources = IdleDurationCampaign()
    self.idleResources:InitDatabase(jsonDatabase['2'])

    self.idleItems = IdleDurationCampaign()
    self.idleItems:InitDatabase(jsonDatabase['3'])

    self.idleTraining = IdleDurationCampaign()
    self.idleTraining:InitDatabase(jsonDatabase['4'])

    self.trainingSlotExp:Clear()
    for _, v in pairs(jsonDatabase['7']) do
        local heroInventoryId = tonumber(v)
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(heroInventoryId)
        if heroResource ~= nil then
            self.trainingSlotExp:Add(heroInventoryId)
        end
    end

    self.timeReachHighestStage = tonumber(jsonDatabase['8'])

    self.quickBattleBuyTurn = tonumber(jsonDatabase['9'])
    self.quickBattleTicketDict = Dictionary()
    for ticket, number in pairs(jsonDatabase['10']) do
        if tonumber(number) > 0 then
            self.quickBattleTicketDict:Add(tonumber(ticket), tonumber(number))
        end
    end
    InventoryUtils.Get(ResourceType.CampaignQuickBattleTicket):InitDatabase(self.quickBattleTicketDict:GetItems())
    FeatureConfigInBound.VISUAL_UPDATED = false
end

--- @return boolean
function CampaignData:CanIdle()
    return self.stageIdle > 0
end

--- @param timeIdle number
--- @param type string
function CampaignData:InitTimeIdle(type, timeIdle)
    for stageId, time in pairs(self[type].totalTime:GetItems()) do
        if stageId ~= self.stageIdle then
            timeIdle = timeIdle - time
        end
    end
    self[type].totalTime:Add(self.stageIdle, timeIdle)
end

--- @param timeIdle number
function CampaignData:InitTimeIdleMoney(timeIdle)
    self:InitTimeIdle("idleResources", timeIdle)
end

--- @param timeIdle number
function CampaignData:InitTimeIdleItem(timeIdle)
    self:InitTimeIdle("idleItems", timeIdle)
end

--- @return number
--- @param timeCurrentStage number
function CampaignData:GetTimeCurrentStage(timeCurrentStage)
    for stageId, time in pairs(self.idleResources.totalTime:GetItems()) do
        if stageId ~= self.stageIdle then
            timeCurrentStage = timeCurrentStage - time
        end
    end
    return timeCurrentStage
end

--- @return number, boolean
function CampaignData:GetTimeToLootItem()
    local timeRewardItem = ResourceMgr.GetCampaignDataConfig():GetTimeRewardMoney()
    local timeToLoot = timeRewardItem
    if self.stageIdle > 0 then
        for _, time in pairs(self.idleItems.totalTime:GetItems()) do
            if time >= timeRewardItem then
                timeToLoot = 0
                break
            end
        end
    end
    if timeToLoot > 0 then
        timeToLoot = timeRewardItem - (zg.timeMgr:GetServerTime() - self.idleItems.lastTimeIdle)
        if self.idleItems.totalTime:IsContainKey(self.stageIdle) then
            timeToLoot = timeToLoot - self.idleItems.totalTime:Get(self.stageIdle)
        end
    end

    return timeToLoot
end

--- @return number
function CampaignData:GetTotalTimeIdle()
    local totalTimeIdle = 0
    if self.stageIdle > 0 then
        totalTimeIdle = zg.timeMgr:GetServerTime() - self.idleResources.lastTimeIdle
        for _, v in pairs(self.idleResources.totalTime:GetItems()) do
            totalTimeIdle = totalTimeIdle + v
        end
    end
    return totalTimeIdle
end

function CampaignData:SetDataTrainHero()
    if self.trainingSlotExp:Count() > 0 and self.stageIdle > 0 then
        local serverTime = zg.timeMgr:GetServerTime()
        local timeTrainCurrentStage = serverTime - self.idleTraining.lastTimeIdle
        self.idleTraining.lastTimeIdle = serverTime
        for stageId, time in pairs(self.idleTraining.totalTime:GetItems()) do
            if stageId == self.stageIdle then
                timeTrainCurrentStage = timeTrainCurrentStage + time
                break
            end
        end
        self.idleTraining.totalTime:Add(self.stageIdle, timeTrainCurrentStage)
    end
end

function CampaignData:SetStageIdle(stageIdle)
    self.stageIdle = stageIdle
end

---@return boolean
function CampaignData:ValidateStageIdle()
    return self.stageIdle ~= nil and self.stageIdle > 0
end

--- @return number
function CampaignData:GetMaxQuickBattleTurn()
    ---@type VipData
    local vipConfig = ResourceMgr.GetVipConfig():GetCurrentBenefits()
    return ResourceMgr.GetCampaignQuickBattleConfig().maxBuyTurn + vipConfig.campaignBonusQuickBattleBuyTurn
end

--- @return number
function CampaignData:CanUseQuickBattle()
    return self:ValidateStageIdle() and self.quickBattleBuyTurn <= self:GetMaxQuickBattleTurn()
end

--- @return number
function CampaignData:CanUseQuickBattleFree()
    ---@type ItemIconData
    local iconData = ResourceMgr.GetCampaignQuickBattleConfig().buyTurnDictionary:Get(self.quickBattleBuyTurn)
    return self:ValidateStageIdle() and iconData ~= nil and iconData.quantity <= 0
end

--- @return number
function CampaignData:GetTimeToMaxIdle()
    return ResourceMgr.GetCampaignDataConfig():GetMaxTimeIdle() - (zg.timeMgr:GetServerTime() - self.idleItems.lastTimeIdle)
end

--- @return void
---@param heroResource HeroResource
function CampaignData.GetExpTrainingByHeroResource(heroResource)
    local exp = 0
    ---@type HeroLevelCapConfig
    local levelCap = ResourceMgr.GetHeroMenuConfig():GetHeroLevelCapDictionary(heroResource.heroStar)
    if heroResource.heroLevel < levelCap.levelCap then
        for j = heroResource.heroLevel + 1, levelCap.levelCap do
            ---@type HeroLevelDataConfig
            local levelData = ResourceMgr.GetHeroMenuConfig():GetHeroLevelDataDictionary(j)
            exp = exp + levelData.exp
        end
    end
    return exp
end

--- @return void
function CampaignData:GetExpFullSlot()
    local exp = 0
    ---@param v UISlotTrainingTeamView
    for _, v in ipairs(self.trainingSlotExp:GetItems()) do
        exp = exp + CampaignData.GetExpTrainingByHeroResource(InventoryUtils.GetHeroResourceByInventoryId(v))
    end
    return exp
end

--- @return void
function CampaignData:GetExpTraining()
    ---@type number
    local totalExp = 0

    for stageId, time in pairs(self.idleTraining.totalTime:GetItems()) do
        if stageId ~= self.stageIdle then
            totalExp = totalExp + ResourceMgr.GetIdleRewardConfig():GetExpTrain(stageId) * math.floor(time)
        end
    end

    local timeCurrentStage = zg.timeMgr:GetServerTime() - self.idleTraining.lastTimeIdle
    local expTrainCurrentStageConfig = ResourceMgr.GetIdleRewardConfig():GetExpTrain(self.stageIdle)
    if self.idleTraining.totalTime:IsContainKey(self.stageIdle) then
        timeCurrentStage = timeCurrentStage + self.idleTraining.totalTime:Get(self.stageIdle)
    end
    totalExp = totalExp + expTrainCurrentStageConfig * math.floor(timeCurrentStage)
    return totalExp
end

--- @return void
function CampaignData:GetTimeFinishTraining()
    return math.ceil((self:GetExpFullSlot() - self:GetExpTraining())
            / ResourceMgr.GetIdleRewardConfig():GetExpTrain(self.stageIdle)) + 1
end

function CampaignData:SetNextStage(nextStage)
    self.stageNext = nextStage
    self.currentDifficultLevel, self.currentMapId = ClientConfigUtils.GetIdFromStageId(self.stageNext)
end

return CampaignData