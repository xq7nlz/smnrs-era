--- @class UIBossChallengePremiumPassLayout : UIEventBossChallengeLayout
UIBossChallengePremiumPassLayout = Class(UIBossChallengePremiumPassLayout, UIEventBossChallengeLayout)

--- @param view UIEventBossChallenge
--- @param eventBossChallengeTab EventBossChallengeTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIBossChallengePremiumPassLayout:Ctor(view, eventBossChallengeTab, anchor, noti)
    self.noti = noti
    --- @type UIBossChallengePremiumPassLayoutConfig
    self.layoutConfig = nil
    --- @type EventBossChallengeModel
    self.eventModel = nil
    --- @type Dictionary
    self.rewardDict = Dictionary()
    --- @type List
    self.rewardList = List()
    --- @type List
    self.itemList = List()
    UIEventBossChallengeLayout.Ctor(self, view, eventBossChallengeTab, anchor)
end

function UIBossChallengePremiumPassLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_boss_challenge_premium_pass", self.anchor)
    UIEventBossChallengeLayout.InitLayoutConfig(self, inst)
    self:InitPack()
    self:InitButtons()
    self:InitLocalization()
end

function UIBossChallengePremiumPassLayout:InitLocalization()
    self.layoutConfig.textBenefit.text = LanguageUtils.LocalizeCommon("benefit_text")
    self.layoutConfig.textBuyNow.text = LanguageUtils.LocalizeCommon("buy_now_text")
    self.layoutConfig.textTitle.text = LanguageUtils.LocalizeCommon("premium_pass_title_text")
    self.layoutConfig.textTotalReward.text = LanguageUtils.LocalizeCommon("premium_pass_total_reward_text")
    self.layoutConfig.textClaimAll.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.textBuy.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
end

function UIBossChallengePremiumPassLayout:SetUpLayout()
    UIEventBossChallengeLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
    self.rewardView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self.rewardList:Clear()
    self.rewardDict:Clear()

    for i = 1, self.eventConfig:GetTotalBossChallengeTower() do
        --- @return ItemIconData
        local itemIconData = self.eventConfig:GetTowerRewardPremiumPassById(i):Get(1)
        if self.rewardDict:IsContainKey(itemIconData.itemId) then
            local itemIconData1 = self.rewardDict:Get(itemIconData.itemId)
            itemIconData1.quantity = itemIconData1.quantity + itemIconData.quantity
        else
            self.rewardDict:Add(itemIconData.itemId, itemIconData)
        end
    end

    --- @param v ItemIconData
    for k, v in pairs(self.rewardDict:GetItems()) do
        self.rewardList:Add(v)
    end

    self.rewardView:SetData(self.rewardList)
end

function UIBossChallengePremiumPassLayout:InitButtons()
    self.layoutConfig.buyButton.onClick:AddListener(function()
        self:OnClickBuy()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.layoutConfig.buttonClaimAll.onClick:AddListener(
            function()
                self:OnClickClaimAll()
                zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            end)
end

function UIBossChallengePremiumPassLayout:OnShow()
    UIEventBossChallengeLayout.OnShow(self)
    self:InitLocalization()
    self:UpdateUI()
end

function UIBossChallengePremiumPassLayout:UpdateUI()
    self.layoutConfig.buyButton.gameObject:SetActive(self.eventModel.isBoughtPremiumPass == false)
    self.layoutConfig.lockButton.gameObject:SetActive(self.eventModel.isBoughtPremiumPass == true)
    self:UpdateButtonClaimAll()
end

function UIBossChallengePremiumPassLayout:InitPack()
    ---@type BossChallengeGroupPackOfProducts
    self.packOfProducts = ResourceMgr.GetPurchaseConfig():GetEventBossChallengeBundleStore():GetCurrentPack()
    self.pack = self.packOfProducts.groupPackDict:Get(self.packOfProducts.groupPackDict:Count())
    --- @type ProductConfig
    self.productConfig = self.pack:GetListProductConfig():Get(1)
    self.packId = self.productConfig.id
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.productConfig.opCode, self.packId, self.productConfig.dataId)
end

--- @return void
function UIBossChallengePremiumPassLayout:OnClickClaimAll()
    --- @type List
    local rewardList = nil
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end
    local onSuccess = function()
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self.eventModel.premiumPassClaimedStageList:Clear()
        for i = 1, self.eventModel.currentStage - 1 do
            self.eventModel:AddPremiumPassClaimedStageList(i)
        end

        self:UpdateButtonClaimAll()
    end

    local onFailed = function(logicCode)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
        SmartPoolUtils.ShowShortNotification(logicCode)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_BOSS_CHALLENGE_CLAIM_PREMIUM_PASS, nil, onSuccess, onFailed, onBufferReading)
end

function UIBossChallengePremiumPassLayout:UpdateButtonClaimAll()
    if self.eventModel.currentStage < self.eventConfig:GetTotalBossChallengeTower() + 1 then
        self.layoutConfig.buttonClaimAll.gameObject:SetActive(self.eventModel.isBoughtPremiumPass and self.eventModel.premiumPassClaimedStageList:Count() ~= self.eventModel.currentStage - 1)
    else
        self.layoutConfig.buttonClaimAll.gameObject:SetActive(self.eventModel.isBoughtPremiumPass and self.eventModel.premiumPassClaimedStageList:Count() < self.eventModel.currentStage - 1)
    end
end

function UIBossChallengePremiumPassLayout:OnClickBuy()
    BuyUtils.InitListener(function()
        self:OnPurchaseSuccess()
    end)
    TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.IAP_SHOP, "event_boss_challenge", self.packId)
    RxMgr.purchaseProduct:Next(self.packKey)
end

function UIBossChallengePremiumPassLayout:OnPurchaseSuccess()
    self.eventModel.isBoughtPremiumPass = true
    self:UpdateUI()
end

function UIBossChallengePremiumPassLayout:OnHide()
    self.rewardList:Clear()
    self.rewardDict:Clear()
    self.rewardView:Hide()
    UIEventBossChallengeLayout.OnHide(self)
end
