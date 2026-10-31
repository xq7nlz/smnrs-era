require "lua.client.core.network.iap.LimitedPackStatisticsInBound"
require "lua.client.core.network.iap.ProductCheckOutBound"
require "lua.client.core.network.iap.CustomizeBundleItemSelectOutBound"
require "lua.client.core.network.iap.ConditionalPackCollection"
require "lua.client.core.network.common.PurchasedPackInBound"

--- @class IapDataInBound
IapDataInBound = Class(IapDataInBound)

function IapDataInBound:Ctor()

    self.isShowPopup = nil
    --- @type List
    self.listPurchasedSubscriptionPacks = nil
    --- @type List
    self.listPurchasedStarterPacks = nil
    ---@type number
    self.firstPurchaseItemSelection = nil
    ---@type Dictionary
    self.dicFirstPurchasePack = nil
end

function IapDataInBound:SetShowPopup(_value)
    self.isShowPopup = _value
end

function IapDataInBound:SetFirstPurchaseItemIndex(_index)
    self.firstPurchaseItemSelection = _index
end

---@return number
function IapDataInBound:HasClaimedAllFirstTopUPReward()
    --print("dic first purchase count ",self.dicFirstPurchasePack:Count(),"count reward claim", self:GetCountRewardClaimed())
    return self.dicFirstPurchasePack:Count() == self:GetCountRewardClaimed()
end

function IapDataInBound:OnClaimFirstPurchaseItemIndex(_index)
    self.dicFirstPurchasePack:Add(_index, RewardState.CLAIMED)
end

---@return number
function IapDataInBound:HasRewardNotChoosen()
    for _, v in pairs(self.dicFirstPurchasePack:GetItems()) do
        if (v == RewardState.AVAILABLE_TO_CLAIM) then
            return true
        end
    end
    return false
end

---@return boolean
function IapDataInBound:AllFirstPurchasePackageAvailable()
    ---@param  v RewardState
    for _, v in pairs(self.dicFirstPurchasePack:GetItems()) do
        if (v ~= RewardState.NOT_AVAILABLE_TO_CLAIM) then
            return false
        end
    end
    return false
end

---@return List
function IapDataInBound:GetListFirstTopUpIndexAvailable()
    local result = List()
    local dicCount = self.dicFirstPurchasePack:Count()
    for i = 1, dicCount do
        ---@type RewardState -- only AVAILABLE_TO_CLAIM and CLAIMED
        local rewardState = self.dicFirstPurchasePack:Get(i)
        if (rewardState == RewardState.AVAILABLE_TO_CLAIM) then
            result:Add(i)
        end
    end
    return result
end
---@return number
function IapDataInBound:GetCountRewardClaimed()
    local countRewardClaimed = 0
    for _, v in pairs(self.dicFirstPurchasePack:GetItems()) do
        if (v == RewardState.CLAIMED) then
            countRewardClaimed = countRewardClaimed + 1
        end
    end
    return countRewardClaimed
end

function IapDataInBound.GetChosenFirstPurchaseItemIndex()
    --- @type IapDataInBound
    local iap = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return iap.firstPurchaseItemSelection
end

--- @return List | GroupProductConfig
function IapDataInBound.GetListFlashSaleGroup()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return iapDataInBound.progressPackData:GetActiveGroupListFlashSale()
end

--- @return List | GroupProductConfig
function IapDataInBound.GetListNewFlashSaleGroup()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return iapDataInBound.progressPackData:GetActiveGroupListNewFlashSale()
end

--- @return List | GroupProductConfig
function IapDataInBound.GetBoostFirstPurchaseGroup()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return iapDataInBound.boostFirstPurchaseCollection:GetActiveGroupBoostFirstPurchase()
end

--- @return FlashSaleEvolveCollection
function IapDataInBound.GetFlashSaleEvolveActiveGroup()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return iapDataInBound.flashSaleEvolveCollection
end

--- @return void
function IapDataInBound:ResetFlashSaleEvolveActiveGroup()
    self.flashSaleEvolveCollection:ClearListIdHeroActive()
end

function IapDataInBound.AlreadyChoosePack()
    --- @type IapDataInBound
    local iap = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    return (iap.firstPurchaseItemSelection ~= nil and iap.firstPurchaseItemSelection > 0)
end
--- @param buffer UnifiedNetwork_ByteBuf
function IapDataInBound:ReadBuffer(buffer)
    --- @type boolean
    self.allowSkipVideo = false
    self:ReadRawPack(buffer)

    self:ReadSubscriptionPack(buffer)

    require "lua.client.core.network.iap.ProgressPackCollection"
    self.progressPackData = ProgressPackCollection()
    self.progressPackData:ReadBuffer(buffer)

    require "lua.client.core.network.iap.BoostFirstPurchaseCollection"
    self.boostFirstPurchaseCollection = BoostFirstPurchaseCollection()
    self.boostFirstPurchaseCollection:ReadBuffer(buffer)

    require "lua.client.core.network.iap.GrowthPack.GrowthPackCollection"
    self.growthPackData = GrowthPackCollection()
    self.growthPackData:ReadBuffer(buffer)

    self.listOfLimitedPackStatistics = NetworkUtils.GetListDataInBound(buffer, LimitedPackStatisticsInBound.CreateByBuffer)
    self:GetPurchasedSubscriptionPacks()
    self:ReadCustomizePack(buffer)
    self:ReadFirstPurchasePack(buffer)

    require "lua.client.core.network.iap.FlashSaleEvolveCollection"
    self.flashSaleEvolveCollection = FlashSaleEvolveCollection()
    self.flashSaleEvolveCollection:ReadBuffer(buffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function IapDataInBound:ReadFirstPurchasePack(buffer)
    self.dicFirstPurchasePack = Dictionary()
    local packSize = buffer:GetByte()
    for _ = 1, packSize do
        local packId = buffer:GetInt()
        local rewardState = buffer:GetInt()
        self.dicFirstPurchasePack:Add(packId, rewardState)
    end
    self:InitDefaultDictFirstTopUpReward()
end

function IapDataInBound:InitDefaultDictFirstTopUpReward()
    if (self.dicFirstPurchasePack:Count() == 0) then
        local purchaseConfig = ResourceMgr.GetPurchaseConfig()
        purchaseConfig:InitDictFirstTopUpReward()
        for k, _ in pairs(purchaseConfig.dicFirstTimeReward:GetItems()) do
            self.dicFirstPurchasePack:Add(k, RewardState.NOT_AVAILABLE_TO_CLAIM)
        end
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function IapDataInBound:ReadRawPack(buffer)
    --- @type number
    local rawPackSize = buffer:GetShort()
    --- @type Dictionary
    self.rawPackDict = Dictionary()
    for _ = 1, rawPackSize do
        local packId = buffer:GetInt()
        local numberOfBought = buffer:GetInt()
        self.rawPackDict:Add(packId, numberOfBought)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function IapDataInBound:ReadCustomizePack(buffer)
    require "lua.client.core.network.iap.CustomizePackStatisticsInBound"
    --- @type List
    self.listCustomizePack = NetworkUtils.GetListDataInBound(buffer, CustomizePackStatisticsInBound.CreateByBuffer)
end

--- @param buffer UnifiedNetwork_ByteBuf
function IapDataInBound:ReadSubscriptionPack(buffer)
    --- @param durationDict Dictionary
    local readDuration = function(buffer, durationDict)
        --- @type number
        local durationSize = buffer:GetShort()
        for _ = 1, durationSize do
            local packId = buffer:GetInt()
            local packDurationInDays = buffer:GetInt()

            durationDict:Add(packId, packDurationInDays)

            if self.allowSkipVideo == false and packDurationInDays > 0 then
                self.allowSkipVideo = ResourceMgr.GetPurchaseConfig():GetCashShop():GetSubscription(packId).allowSkipVideo
            end
        end
    end

    self.subscriptionDurationDict = Dictionary()
    readDuration(buffer, self.subscriptionDurationDict)

    self.subscriptionTrialDurationDict = Dictionary()
    readDuration(buffer, self.subscriptionTrialDurationDict)

    local subscriptionTrialAvailableSize = buffer:GetShort()
    self.subscriptionTrialAvailabilityDict = Dictionary()
    for _ = 1, subscriptionTrialAvailableSize do
        local packId = buffer:GetInt()
        local isAvailableToTrial = buffer:GetBool()
        self.subscriptionTrialAvailabilityDict:Add(packId, isAvailableToTrial)
    end
end

--- @param rawPackId number
function IapDataInBound:GetNumberOfBoughtRawPack(rawPackId)
    local result = 0
    if self.rawPackDict:IsContainKey(rawPackId) == true then
        result = self.rawPackDict:Get(rawPackId)
    end
    return result
end

--- @param packId number
function IapDataInBound:IncreaseNumberOfBoughtRawPack(packId)
    local numberOfBought = self:GetNumberOfBoughtRawPack(packId)
    numberOfBought = numberOfBought + 1
    self.rawPackDict:Add(packId, numberOfBought)
end

--- @return CustomizePackStatisticsInBound
--- @param customizePackId number
function IapDataInBound:GetCustomizePack(customizePackId)
    --- @param v CustomizePackStatisticsInBound
    for _, v in pairs(self.listCustomizePack:GetItems()) do
        if v.packId == customizePackId then
            return v
        end
    end
    --- @type CustomizePackStatisticsInBound
    local pack = CustomizePackStatisticsInBound(customizePackId)
    self.listCustomizePack:Add(pack)
    return pack
end

--- @param customizePackId number
function IapDataInBound:GetNumberOfBoughtCustomizePack(customizePackId)
    --- @param v CustomizePackStatisticsInBound
    for _, v in pairs(self.listCustomizePack:GetItems()) do
        if v.packId == customizePackId then
            return v.numberOfBought
        end
    end
    return 0
end

--- @param packId number
function IapDataInBound:IncreaseNumberOfBoughtCustomizePack(packId)
    self:GetCustomizePack(packId):IncreaseNumberOfBought()
end

--- @param listSelect List
--- @param packId number
function IapDataInBound:SetSelectedItemsCustomizePack(packId, listSelect)
    self:GetCustomizePack(packId).listOfSelectedItem = listSelect
end

--- @param packId number
function IapDataInBound:IncreaseNumberOfBoughtLimitedPack(packId)
    local pack = self:GetLimitedPackStatisticsInBound(packId)
    if pack ~= nil then
        pack:IncreaseNumberOfBought()
    else
        XDebug.Error(string.format("Limited Pack %d isn't exist", packId))
    end
end

--- @return LimitedPackStatisticsInBound
--- @param packId number
function IapDataInBound:GetLimitedPackStatisticsInBound(packId)
    for i = 1, self.listOfLimitedPackStatistics:Count() do
        --- @type LimitedPackStatisticsInBound
        local itemData = self.listOfLimitedPackStatistics:Get(i)
        if itemData.packId == packId then
            return itemData
        end
    end
    local default = LimitedPackStatisticsInBound()
    default.packId = packId
    self.listOfLimitedPackStatistics:Add(default)
    return default
end

--- @return number
--- @param packId number
function IapDataInBound:GetDurationInSubscriptionPack(packId)
    return self.subscriptionDurationDict:Get(packId)
end

--- @return number
--- @param packId number
--- @param days number
function IapDataInBound:AddDurationInSubscriptionPack(packId, days)
    local currentDay = self.subscriptionDurationDict:GetOrDefault(packId, 0)
    local trialDuration = self:GetTrialDurationSubscription(packId) or 0
    if currentDay == 0 and trialDuration <= 0 then
        days = days - 1
    end
    self.subscriptionDurationDict:Add(packId, self.subscriptionDurationDict:GetOrDefault(packId, 0) + days)
end

function IapDataInBound.Validate(callbackSuccess, callbackFailed, forceUpdate)
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    if forceUpdate == true or iapDataInBound == nil then
        local onSuccess = function()
            if callbackSuccess ~= nil then
                callbackSuccess()
            end
        end
        local onFailed = function(logicCode)
            TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.MAIN_FEATURES, "watch_video", -1)
            SmartPoolUtils.LogicCodeNotification(logicCode)
            if callbackFailed ~= nil then
                callbackFailed(logicCode)
            end
        end
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, onSuccess, onFailed)
    else
        if callbackSuccess ~= nil then
            callbackSuccess()
        end
    end
end

--- @param packId number
function IapDataInBound:IsSubscriptionTrialPackAvailable(packId)
    if self.subscriptionTrialAvailabilityDict:IsContainKey(packId) then
        return self.subscriptionTrialAvailabilityDict:Get(packId)
    end
    return true
end

function IapDataInBound:HasTrialPackAvailable()
    return self.subscriptionTrialAvailabilityDict:Count() > 0
end

--- @param packId number
function IapDataInBound:GetTrialDurationSubscription(packId)
    return self.subscriptionTrialDurationDict:Get(packId)
end

--- @return boolean
function IapDataInBound:CanShowButtonTrialMonthly()
    if self.listPurchasedSubscriptionPacks and self.listPurchasedSubscriptionPacks:Count() > 0 then
        return false
    elseif self.subscriptionDurationDict and self.subscriptionDurationDict:Count() > 0 then
        return false
    else
        local stageCurrent = zg.playerData:GetCampaignData().stageCurrent
        ----- @type ProductConfig
        local listStageOpenMonthly = ResourceMgr.GetPurchaseConfig():GetListCampaignStageOpenTrialMonthly()
        local milestone = listStageOpenMonthly:Get(1)
        return stageCurrent >= milestone
    end
    return true
end

--- @return boolean
function IapDataInBound:CheckAutoShowTrialMonthly()
    if self:CanShowButtonTrialMonthly() == false then
        return false
    else
        return self:OnLoadedShowedTrialOnStage()
    end
    return true
end

--- @return boolean
function IapDataInBound:OnLoadedShowedTrialOnStage()
    local stageCurrent = zg.playerData:GetCampaignData().stageCurrent
    --- @type ProductConfig
    local listStageOpenMonthly = ResourceMgr.GetPurchaseConfig():GetListCampaignStageOpenTrialMonthly()
    for i = 1, listStageOpenMonthly:Count() do
        local milestone = listStageOpenMonthly:Get(i)
        if (zg.playerData.remoteConfig.showedTrialMonthlyByStage == nil or zg.playerData.remoteConfig.showedTrialMonthlyByStage < milestone)
                and stageCurrent >= milestone then
            return true
        end
    end
    return false
end

--- @return number
--- @param callback function
function IapDataInBound:GetAutoShowedTrialMonthlyByCampaignStage(callback)
    local onSuccess = function(value)
        self.showedTrialMonthlyByStage = value
        if callback ~= nil then
            callback()
        end
    end
    local showedTrialMonthlyByStage = zg.playerData.remoteConfig.showedTrialMonthlyByStage
    if showedTrialMonthlyByStage == nil then
        showedTrialMonthlyByStage = -1
    end
    onSuccess(showedTrialMonthlyByStage)
end

--- @param stage number
--- @param callback function
--- @param onFailed function
function IapDataInBound.SetAutoShowedTrialMonthlyByCampaignStage(stage, callback, _)
    if stage == nil then
        local campaignData = zg.playerData:GetCampaignData()
        stage = campaignData.stageCurrent
    end
    local onSuccess = function()
        --- @type IapDataInBound
        local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
        iapDataInBound.showedTrialMonthlyByStage = stage
        if callback ~= nil then
            callback()
        end
    end
    zg.playerData.remoteConfig.showedTrialMonthlyByStage = stage
    zg.playerData:SaveRemoteConfig()
    onSuccess()
end

function IapDataInBound:GetPurchasedSubscriptionPacks()
    self.listPurchasedSubscriptionPacks = List()

    local pack2 = ResourceMgr.GetPurchaseConfig():GetCashShop():GetSubscription(2)
    local pack3 = ResourceMgr.GetPurchaseConfig():GetCashShop():GetSubscription(3)

    local listProductId = List()
    listProductId:Add(pack2:GetPackageNameByDeviceOs())
    listProductId:Add(pack3:GetPackageNameByDeviceOs())

    --- @param productCheckInBound ProductCheckInBound
    local onCheckedProduct = function(productCheckInBound)
        for i = 1, productCheckInBound.listCheckItemInBound:Count() do
            --- @type ProductCheckItemInBound
            local productCheckInBound = productCheckInBound.listCheckItemInBound:Get(i)
            if productCheckInBound.isPurchased == true then
                if productCheckInBound.productId == pack2:GetPackageNameByDeviceOs() then
                    self.listPurchasedSubscriptionPacks:Add(2)
                elseif productCheckInBound.productId == pack3:GetPackageNameByDeviceOs() then
                    self.listPurchasedSubscriptionPacks:Add(3)
                end
            end
        end
        RxMgr.notificationPurchasePacks:Next()
    end
    ProductCheckOutBound.CheckPurchaseProduct(listProductId, onCheckedProduct, nil)
end

--- @param listPurchased List
--- @param productId number
function IapDataInBound.CheckPurchaseStatusInListPurchased(listPurchased, productId)
    local deviceOs = ClientConfigUtils.GetDeviceOS()
    for i = 1, listPurchased:Count() do
        --- @type ProductCheckItemInBound
        local purchasedItem = self.listPurchased:Get(i)
        if purchasedItem.productId == productId and purchasedItem.deviceOs == deviceOs then
            return true
        end
    end
    return false
end

--- @param packId number
function IapDataInBound:IsEverPurchaseSubscriptionByPackId(packId)
    if self.listPurchasedSubscriptionPacks ~= nil then
        return self.listPurchasedSubscriptionPacks:IsContainValue(packId)
    end
    return false
end