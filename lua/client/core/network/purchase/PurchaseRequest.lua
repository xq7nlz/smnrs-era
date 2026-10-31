require "lua.client.core.network.purchase.PurchaseOutBound"

--- @class PurchaseRequest
PurchaseRequest = Class(PurchaseRequest)

--- @param product ProductConfig
PurchaseRequest.ShowPopupReward = function(product)
    product:ClaimAndShowRewardList()
end

--- @return void
--- @param productConfig ProductConfig
--- @param data IAPReceipt
function PurchaseRequest.Purchasing(productConfig, data, callback)
    local outBound = PurchaseOutBound(productConfig.id, data.is_free, data.device_os, data.pack_name, data.transaction_id,
            data.transaction_time, data.receipt, data.is_test)
    local onReceived = function(result)
        local isTesterOrder = false
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            productConfig.rewardResult = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
            isTesterOrder = buffer:GetBool()
        end
        local onSuccess = function()
            if callback ~= nil then
                callback(true, isTesterOrder)
            end
            PurchaseRequest.OnPurchaseProductConfigSuccess(productConfig)
        end
        local onFailed = function(logicCode)
            if logicCode == LogicCode.PURCHASE_TRANSACTION_INVALID
                    or logicCode == LogicCode.PURCHASE_TRANSACTION_ALREADY_PROCESSED then
                --- ignore
            else
                SmartPoolUtils.LogicCodeNotification(logicCode)
            end
            XDebug.Warning(LogUtils.ToDetail(outBound))
            if callback ~= nil then
                callback(false)
            end
            RxMgr.buyCompleted:Next(false)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
    end
    NetworkUtils.Request(productConfig.opCode, outBound, onReceived)
end

--- @param productConfig ProductConfig
function PurchaseRequest.OnPurchaseProductConfigSuccess(productConfig)

    PurchaseRequest.UpdateStatistic(productConfig)
    Coroutine.start(function()
        local touchObject = TouchUtils.Spawn("Purchasing Delay show reward")
        coroutine.waitforendofframe()
        coroutine.waitforendofframe()
        PurchaseRequest.ShowPopupReward(productConfig)
        if (TrackingUtils.server ~= nil) then
            if (IapDataInBound.AlreadyChoosePack()) then
                ---@type IapDataInBound
                local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
                ---@type boolean
                iapDataInBound:SetShowPopup(false)
            end
        end
        touchObject:Enable()
        RxMgr.buyCompleted:Next(true)
    end)

    TrackingUtils.server:GetTracking(FBProperties.IAP_COUNT):Increase(1)
end

--- @param packBase ProductConfig
function PurchaseRequest.FreeRequest(packBase)
    local onReceived = function(result)
        local onSuccess = function()
            PurchaseRequest.ShowPopupReward(packBase)
            PurchaseRequest.UpdateStatistic(packBase)
            RxMgr.buyCompleted:Next(true)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(packBase.opCode, UnknownOutBound.CreateInstance(PutMethod.Int, packBase.id, PutMethod.Bool, packBase.isFree), onReceived)
end

--- @param id number
function PurchaseRequest.RequestTrialSubscription(id, callback, onFailed)
    local onReceived = function(result)
        local onSuccess = function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, callback)
        end
        NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
    end
    NetworkUtils.Request(OpCode.PURCHASE_SUBSCRIPTION_TRIAL_PACK,
            UnknownOutBound.CreateInstance(PutMethod.Int, id),
            onReceived)
end

--- @param productConfig ProductConfig
function PurchaseRequest.UpdateStatistic(productConfig)
    local opCode = productConfig.opCode
    XDebug.Log("UpdateStatistic " .. opCode)

    if opCode == OpCode.PURCHASE_LIMITED_PACK then
        zg.playerData:GetIAP():IncreaseNumberOfBoughtLimitedPack(productConfig.id)
    elseif opCode == OpCode.EVENT_HALLOWEEN_DAILY_PURCHASE then
        ---@type EventHalloweenModel
        local eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
        if eventHalloweenModel then
            eventHalloweenModel:IncreaseNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.PURCHASE_SUBSCRIPTION_PACK then
        --- @type SubscriptionProduct
        local subscriptionProduct = productConfig
        zg.playerData:GetIAP():AddDurationInSubscriptionPack(subscriptionProduct.id, subscriptionProduct.durationInDays)
    elseif opCode == OpCode.EVENT_ZODIAC_BUNDLE_PURCHASE_HANDLER then
        ---@type EventZodiacModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_ZODIAC)
        if eventModel then
            eventModel:IncreaseNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_CHRISTMAS_DAILY_PURCHASE then
        ---@type EventXmasModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
        if eventModel then
            eventModel:IncreaseNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_NEW_YEAR_BUNDLE_PURCHASE then
        ---@type EventNewYearModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR)
        if eventModel then
            --eventModel:IncreaseNumberOfBoughtBundlePack(productConfig.id)
            eventModel:AddNumberBuy(EventActionType.NEW_YEAR_BUNDLE_PURCHASE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_LUNAR_NEW_YEAR_ELITE_STORE_PURCHASE then
        ---@type EventLunarNewYearModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
        if eventModel then
            eventModel:IncreaseNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_VALENTINE_LOVE_BUNDLE_PURCHASE then
        ---@type EventValentineModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE)
        if eventModel then
            eventModel:IncreaseNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_BUNDLE_PURCHASE
            or opCode == OpCode.EVENT_HOT_DEAL_PURCHASE then
        --- @type EventProduct
        local eventProduct = productConfig
        --- @type EventPopupPurchaseModel
        local eventModel = zg.playerData:GetEvents():GetEvent(eventProduct.eventTimeType)
        if eventModel then
            local data = eventModel:GetData(productConfig.id)
            data:IncreaseNumberOfBought()
        end
    elseif opCode == OpCode.PURCHASE_RAW_PACK then
        zg.playerData:GetIAP():IncreaseNumberOfBoughtRawPack(productConfig.id)
    elseif opCode == OpCode.EVENT_SALE_OFF_PURCHASE then
        --- @type SaleOffProductConfig
        local saleOffProductConfig = productConfig
        --- @type SubscriptionProduct
        local subscriptionProduct = ResourceMgr.GetPurchaseConfig():GetCashShop():GetSubscription(saleOffProductConfig.originalPackId)
        zg.playerData:GetIAP():AddDurationInSubscriptionPack(subscriptionProduct.id, subscriptionProduct.durationInDays)

        --- @type EventSaleOffModel
        local eventSaleOffModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SALE_OFF)
        if eventSaleOffModel ~= nil then
            eventSaleOffModel:OnBuySalePackSuccess(saleOffProductConfig.id)
        end
    elseif opCode == OpCode.EVENT_NEW_HERO_BUNDLE_PURCHASE then
        --- @type EventNewHeroBundleModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_BUNDLE)
        if eventModel then
            eventModel:OnPurchaseSuccess(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_SERVER_MERGE_BUNDLE_PURCHASE then
        --- @type EventMergeServerModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MERGE_SERVER)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.SERVER_MERGE_LIMITED_BUNDLE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_EASTER_BUNDLE_PURCHASE then
        --- @type EventEasterEggModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.EASTER_BUNDLE_PURCHASE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_EASTER_CARD_PURCHASE then
        --- @type EventEasterEggModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.EASTER_BUNNY_CARD_PURCHASE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_EASTER_LIMIT_OFFER_PURCHASE then
        --- @type EventEasterEggModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_EGG)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.EASTER_EXCLUSIVE_BUNDLE_PURCHASE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_DAILY_QUEST_PASS_PURCHASE then
        --- @type EventDailyQuestPassModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_DAILY_QUEST_PASS_PURCHASE)
        if eventModel then
            eventModel:IncreaseBoughtPack(productConfig.id)
        end
    elseif opCode == OpCode.COMEBACK_BUNDLE_PURCHASE then
        --- @type WelcomeBackInBound
        local welcomeBackInBound = zg.playerData:GetMethod(PlayerDataMethod.COMEBACK)
        if welcomeBackInBound ~= nil then
            welcomeBackInBound:IncreaseBoughtPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE then
        --- @type EventBirthdayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.BIRTHDAY_EXCLUSIVE_BUNDLE_PURCHASE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_BIRTH_DAY_LEVEL_BUNDLE_PURCHASE then
        --- @type EventBirthdayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
        if eventModel and productConfig.priceType == IapPackPriceType.WATCH_ADS then
            eventModel:SubNumberWatchAdsRemain()
        end
    elseif opCode == OpCode.EVENT_BIRTHDAY_BUNDLE_PURCHASE then
        --- @type EventBirthdayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BIRTHDAY)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.BIRTHDAY_BUNDLE_PURCHASE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_NEW_HERO_SKIN_BUNDLE_PURCHASE then
        --- @type EventNewHeroSkinBundleModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SKIN_BUNDLE)
        if eventModel then
            eventModel:AddNumberBuyOpCode(opCode, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_SKIN_BUNDLE_PURCHASE then
        --- @type EventSkinBundleModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_BUNDLE)
        if eventModel then
            eventModel:AddNumberBuyOpCode(opCode, productConfig.id, 1)
        end
    elseif opCode == OpCode.ITEM_SKIN_BUNDLE_PURCHASE then

    elseif opCode == OpCode.EVENT_HERO_RELEASE_BUNDLE_PURCHASE then
        --- @type EventHeroReleaseModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HERO_RELEASE)
        if eventModel then
            eventModel:AddNumberBuyOpCode(opCode, productConfig.id, 1)
        end
    elseif opCode == OpCode.CUSTOMIZE_BUNDLE_PURCHASE then
        zg.playerData:GetIAP():IncreaseNumberOfBoughtCustomizePack(productConfig.id)
    elseif opCode == OpCode.PURCHASE_PROGRESS_PACK
            or opCode == OpCode.PURCHASE_STARTER_PACK then
        --- @type ProgressPackCollection
        local progressPackCollection = zg.playerData:GetIAP().progressPackData
        progressPackCollection:IncreaseBoughtPack(productConfig.id)
    elseif opCode == OpCode.EVENT_BATTLE_PASS_LEVEL_PURCHASE
            or opCode == OpCode.EVENT_BATTLE_PASS_PURCHASE then
        --- @type EventBattlePassModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
        if eventModel then
            eventModel:AddNumberBuyOpCode(opCode, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_NEW_SERVER_OPEN_BUNDLE_PURCHASE then
        --- @type  EventNewServerWeekModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
        if eventModel then
            eventModel:AddNumberBuy(productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_KAZETSU_LIMITED_BUNDLE_PURCHASE then
        --- @type  EventKazetsuModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
        if eventModel then
            eventModel:AddNumberBuy(productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_BLACK_FRIDAY_BUNDLE_PURCHASE then
        --- @type EventBlackFridayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.BLACK_FRIDAY_BUNDLE_PACK_BUY, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_BLACK_FRIDAY_CARD_PURCHASE then
        --- @type EventBlackFridayModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.BLACK_FRIDAY_CARD_PURCHASE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_NEW_SERVER_OPEN_2_BUNDLE_PURCHASE then
        --- @type  EventNewServerWeekModel2
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_2)
        if eventModel then
            eventModel:AddNumberBuy(productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_IDLE_EFFECT_CUSTOMIZE_BUNDLE_PURCHASE then
        --- @type  EventIdleEffectModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
        if eventModel then
            eventModel:AddNumberBuy(productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_IDLE_EFFECT_RANDOM_BUNDLE_PURCHASE then
        --- @type  EventIdleEffectModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_IDLE_EFFECT_BUNDLE)
        if eventModel then
            eventModel:AddNumberBuy(productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_NEW_SERVER_OPEN_3_BUNDLE_PURCHASE then
        --- @type  EventNewServerWeekModel3
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_3)
        if eventModel then
            eventModel:AddNumberBuy(productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE
            or opCode == OpCode.EVENT_LUNAR_2022_SPRING_BUNDLE_PURCHASE then
        --- @type EventLunarNewYearModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2022)
        if eventModel then
            eventModel:AddNumberBuyOpCode(opCode, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_SKIN_HOT_DEAL_PURCHASE then
        --- @type EventSkinHotDealModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_HOT_DEAL)
    elseif opCode == OpCode.EVENT_SKIN_CHALLENGE_BUNDLE_PURCHASE then
        --- @type EventSkinChallengeModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SKIN_CHALLENGE)
        if eventModel then
            eventModel:AddNumberBuy(EventActionType.SKIN_CHALLENGE_BUNDLE, productConfig.id, 1)
        end
    elseif opCode == OpCode.EVENT_HERO_AIRYUU_BUNDLE then
        --- @type EventAiryuuModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
        if eventModel then
            eventModel:AddNumberBuy(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_DRAGON_TOWER_BUNDLE_PURCHASE then
        --- @type EventTowerOfEitriModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_TOWER_OF_EITRI)
        if eventModel then
            eventModel:AddNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_SEASONAL_BUNDLE then
        --- @type EventSeasonalModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SEASONAL)
        if eventModel then
            eventModel:AddNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_BOSS_CHALLENGE_PURCHASE then
        --- @type EventBossChallengeModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
        if eventModel then
            eventModel:AddNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.PURCHASE_BOOST_FIRST_PACK then
        --- @type BoostFirstPurchaseCollection
        local boostFirstPurchaseCollection = zg.playerData:GetIAP().boostFirstPurchaseCollection
        boostFirstPurchaseCollection:IncreaseBoughtPack(productConfig.id)
    elseif opCode == OpCode.EVENT_PIECE_ADVENTURE_PURCHASE then
        --- @type EventPieceAdventureModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_PIECE_ADVENTURE)
        if eventModel then
            eventModel:AddNumberOfBoughtLimitedPack(productConfig.id)
        end
    elseif opCode == OpCode.EVENT_NEW_YEAR_2023_BUNDLE_PURCHASE then
    elseif opCode == OpCode.EVENT_LUNAR_NEW_YEAR_2024_BUNDLE_PURCHASE then
    elseif opCode == OpCode.EVENT_VALENTINE_2024_BUNDLE_PURCHASE then
    else
        XDebug.Error("Missing Update Statistic OpCode: " .. opCode)
    end
end