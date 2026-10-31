--- @class UISubscriptionPackView
UISubscriptionPackView = Class(UISubscriptionPackView)

--- @param transform UnityEngine_Transform
--- @param packId number
function UISubscriptionPackView:Ctor(transform, packId)
    --- @type UISubscriptionPackConfig
    self.config = UIBaseConfig(transform)
    --- @type number
    self.packId = packId
    --- @type OpCode
    self.opCode = OpCode.PURCHASE_SUBSCRIPTION_PACK
    --- @type string
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId)
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil

    self:InitScroll()

    self:InitButtonListener()

    self:InitItemTableView()
end

function UISubscriptionPackView:InitLocalization()
    self.config.textUnlock.text = LanguageUtils.LocalizeCommon("unlock_super_monthly_card")
    self.config.textInstantGet.text = LanguageUtils.LocalizeCommon("instantly_get")
end

function UISubscriptionPackView:InitScroll()
    --- @param obj ItemDailySubscriptionView
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type RewardInBound
        local rewardInBound = self.listDailyReward:Get(index)
        if rewardInBound.id < 0 then
            obj:OverrideVisual(self:GetIconFreeVideo(),
                    LanguageUtils.LocalizeCommon("free"), LanguageUtils.LocalizeCommon("free_acquire_video_reward"))
            obj:AddListener(function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("free_acquire_video_reward"))
            end)
        else
            obj:SetIconData(rewardInBound)
            obj:RegisterShowInfo()
        end
    end

    self.uiScroll = UILoopScroll(self.config.scrollDailyReward, UIPoolType.ItemDailySubscriptionView, onCreateItem)
    self.uiScroll.scroll.enabled = false
end

function UISubscriptionPackView:GetIconFreeVideo()
    return ResourceLoadUtils.LoadSpriteFromAtlas(ResourceLoadUtils.iconCurrenciesEffect,
            tostring(-99), ComponentName.UnityEngine_Sprite)
end

function UISubscriptionPackView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)

    self.config.buttonTrial.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickTrial()
    end)
end

function UISubscriptionPackView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.instantResAnchor)
end

function UISubscriptionPackView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UISubscriptionPackView.InitLocalization)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)

    --- @type SubscriptionProduct
    self.data = ResourceMgr.GetPurchaseConfig():GetCashShop():GetSubscription(self.packId)

    self:GetListDailyReward()

    self:SetTittle()

    local isTrialUiAvailable = self:IsTrialUiAvailable()
    self.config.buttonBuy.gameObject:SetActive(isTrialUiAvailable == false)
    self.config.buttonTrial.gameObject:SetActive(false)
    self.config.coverInstantReward:SetActive(isTrialUiAvailable == true)
    self.config.remainingDaysTag:SetActive(false)

    if isTrialUiAvailable == true then
        self:SetTrial()
    else
        self:SetPrice()

        local trialDuration = self.iapDataInBound:GetTrialDurationSubscription(self.packId)
        local duration = self.iapDataInBound:GetDurationInSubscriptionPack(self.packId)

        if duration ~= nil or trialDuration ~= nil then
            self:SetDurationInDays(math.max(trialDuration or 0, 0) + math.max(duration or 0, 0))
        end
    end
    self:SetInstantReward()
    self:ShowTextBuy()

    if self.packId == 3 or self.packId == 4 then
        local trialDuration = self.iapDataInBound:GetTrialDurationSubscription(self.packId)
        local duration = self.iapDataInBound:GetDurationInSubscriptionPack(self.packId)
        if trialDuration == nil then
            trialDuration = 0
        end

        if duration == nil then
            duration = 0
        end
        if trialDuration + duration > 0 then
            self.config.buttonBuy.gameObject:SetActive(false)
        end
    end
end

function UISubscriptionPackView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
end

function UISubscriptionPackView:SetTrial()
    self.config.textBtnTrial.text = string.format(LanguageUtils.LocalizeCommon("start_free_trial"),
            string.format("<color=#%s>%s %s</color>", UIUtils.green_light, self.data.trialDurationInDay, LanguageUtils.LocalizeCommon("day")))
end

function UISubscriptionPackView:SetTittle()
    local key
    if self.data.id == 1 or self.data.id == 2 then
        key = "monthly"
    else
        key = "premium_monthly"
    end
    self.config.tittle.text = LanguageUtils.LocalizeCommon("subscription_packs_" .. self.data.id)

    self.config.textBonusDays.text = string.format(LanguageUtils.LocalizeCommon("bonus_login_days_s"), self.data.durationInDays)
end

function UISubscriptionPackView:SetDurationInDays(durationIndays)
    self.config.textNumberDays.text = string.format("%d\n%s", durationIndays, LanguageUtils.LocalizeCommon("day"))
    self.config.remainingDaysTag:SetActive(true)
end

function UISubscriptionPackView:SetInstantReward()
    self.itemsTable:SetData(RewardInBound.GetItemIconDataList(self.data:GetRewardList()))
    self.uiScroll:Resize(self.listDailyReward:Count())
end

function UISubscriptionPackView:Hide()
    self.itemsTable:Hide()
end

function UISubscriptionPackView:IsTrialUiAvailable()
    if self.data.trialDurationInDay > 0
            and self.iapDataInBound:IsSubscriptionTrialPackAvailable(self.packId) == true
            and self.iapDataInBound:IsEverPurchaseSubscriptionByPackId(self.packId) == false
            and self.iapDataInBound:CanShowButtonTrialMonthly() == true then
        return true
    end
    return false
end

function UISubscriptionPackView:OnClickBuy()
    BuyUtils.InitListener(function()
        self:ShowPack()
    end)
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "monthly_pack", self.packId)
    RxMgr.purchaseProduct:Next(self.packKey)
end

function UISubscriptionPackView:OnClickTrial()
    local callback = function()
        self:ShowPack()
        PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("trial_available"), nil)
        TrackingUtils.SetTrialSubscription()
    end
    PurchaseRequest.RequestTrialSubscription(self.packId, callback, SmartPoolUtils.LogicCodeNotification)
end

--- @param left number
--- @param max number
function UISubscriptionPackView:ShowTextBuy(left, max)
    if left == nil or max == nil then
        self.config.localizeBuy.text = LanguageUtils.LocalizeCommon("buy")
    else
        local color = UIUtils.green_light
        if left == 0 then
            color = UIUtils.red_light
        end
        self.config.localizeBuy.text = string.format("%s %s",
                LanguageUtils.LocalizeCommon("buy"),
                UIUtils.SetColorString(color, string.format("(%s/%s)", left, max)))
    end
end

function UISubscriptionPackView:GetListDailyReward()
    self.listDailyReward = List()

    --- @param v RewardInBound
    for _, v in pairs(self.data.listBonusReward:GetItems()) do
        self.listDailyReward:Add(RewardInBound.Clone(v))
    end
    if self.data.allowSkipVideo then
        local freeVideoReward = RewardInBound()
        freeVideoReward.type = ResourceType.Money
        freeVideoReward.id = -99
        self.listDailyReward:Add(freeVideoReward)
    end
end