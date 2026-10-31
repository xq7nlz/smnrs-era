--- @class UIConfirmClaimRewardBattlePassView : UIBaseView
UIConfirmClaimRewardBattlePassView = Class(UIConfirmClaimRewardBattlePassView, UIBaseView)

--- @param model UIConfirmClaimRewardBattlePassModel
function UIConfirmClaimRewardBattlePassView:Ctor(model)
    --- @type UIConfirmClaimRewardBattlePassConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollFreeReward = nil
    --- @type UILoopScroll
    self.scrollPremiumReward = nil
    UIBaseView.Ctor(self, model)
    --- @type UIConfirmClaimRewardBattlePassModel
    self.model = model

    self.claimRewardCallBack = nil
end

function UIConfirmClaimRewardBattlePassView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    self:InitScrollFree()

    self:InitScrollPremium()
end

function UIConfirmClaimRewardBattlePassView:InitScrollFree()
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        obj:SetIconData(self.listFreeReward:Get(index))
        obj:RegisterShowInfo()
        obj:SetSize()
    end
    self.scrollFreeReward = UILoopScroll(self.config.freeRewardScroll, UIPoolType.RootIconView, onCreateItem)
end

function UIConfirmClaimRewardBattlePassView:InitScrollPremium()
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        obj:SetIconData(self.listPremiumReward:Get(index))
        obj:RegisterShowInfo()
        obj:SetSize()
    end
    self.scrollPremiumReward = UILoopScroll(self.config.premiumRewardScroll, UIPoolType.RootIconView, onCreateItem)
end

function UIConfirmClaimRewardBattlePassView:InitButtons()
    self.config.bgClose.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
    end)
    self.config.buttonUnlock.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickUnlock()
    end)
    self.config.buttonClaim.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaim()
    end)
end

function UIConfirmClaimRewardBattlePassView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("confirm_battle_pass_reward")
    self.config.textFreePass.text = LanguageUtils.LocalizeCommon("confirm_free_reward_battle_pass")
    self.config.textPremiumPass.text = LanguageUtils.LocalizeCommon("confirm_premium_reward_battle_pass")
    self.config.textUnlock.text = LanguageUtils.LocalizeCommon("unlock_premium")
    self.config.textClaim.text =  LanguageUtils.LocalizeCommon("claim_confirmed_battle_pass")
end

--- @param data {callbackClose : function}
function UIConfirmClaimRewardBattlePassView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.data = data
    self.onClickUnlockPremium  = data.onClickUnlockPremium
    self.callbackClose  = data.callbackClose
    self.claimRewardCallBack = data.claimRewardCallBack
    self:UpdateReward()

end

function UIConfirmClaimRewardBattlePassView:UpdateReward()
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self:ShowRewards()
end



function UIConfirmClaimRewardBattlePassView:OnClickUnlock()
    self.data.callBackBuyPremium = function()
        PopupMgr.HidePopup(self.model.uiName)
    end
    self:OnClickBackOrClose()
    PopupMgr.ShowPopup(UIPopupName.UIUnlockBattlePass, self.data)
    self.onClickUnlockPremium()
    -- PopupMgr.ShowAndHidePopup(UIPopupName.UIUnlockBattlePass, self.data, self.model.uiName)
end

function UIConfirmClaimRewardBattlePassView:OnClickClaim()
    self.claimRewardCallBack()
    self:Hide()
end

function UIConfirmClaimRewardBattlePassView:ShowRewards()
    self.listFreeReward = List()
    self.listPremiumReward = List()
    local listFreeRewardGet = self.eventBattlePassModel:GetListRewardExpectClaim(false)
    local listPremiumRewardGet = self.eventBattlePassModel:GetListRewardExpectClaim(true)
    --- @param v LineRewardConfig
    for _, v in pairs(listFreeRewardGet:GetItems()) do
        ClientConfigUtils.AddIconDataToList(self.listFreeReward, v.reward:GetIconData())
    end
    for _, v in pairs(listPremiumRewardGet:GetItems()) do
        ClientConfigUtils.AddIconDataToList(self.listPremiumReward, v.reward:GetIconData())
    end
    self.scrollFreeReward:Resize(self.listFreeReward:Count())
    self.scrollPremiumReward:Resize(self.listPremiumReward:Count())
end

function UIConfirmClaimRewardBattlePassView:Hide()
    UIBaseView.Hide(self)
    self.scrollFreeReward:Hide()
    self.scrollPremiumReward:Hide()
end


--- @return void
function UIConfirmClaimRewardBattlePassView:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
    end
    PopupMgr.HidePopup(self.model.uiName)
end