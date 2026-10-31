--- @class UIPreviewRewardBattlePassView : UIBaseView
UIPreviewRewardBattlePassView = Class(UIPreviewRewardBattlePassView, UIBaseView)

--- @param model UIPreviewRewardBattlePassModel
function UIPreviewRewardBattlePassView:Ctor(model)
    --- @type UIPreviewRewardBattlePassConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollFreeReward = nil
    --- @type UILoopScroll
    self.scrollPremiumReward = nil
    UIBaseView.Ctor(self, model)
    --- @type UIPreviewRewardBattlePassModel
    self.model = model
end

function UIPreviewRewardBattlePassView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    self:InitScrollFree()

    self:InitScrollPremium()
end

function UIPreviewRewardBattlePassView:InitScrollFree()
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        obj:SetIconData(self.listFreeReward:Get(index))
        obj:RegisterShowInfo()
        obj:SetSize()
    end
    self.scrollFreeReward = UILoopScroll(self.config.freeRewardScroll, UIPoolType.RootIconView, onCreateItem)
end

function UIPreviewRewardBattlePassView:InitScrollPremium()
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type EventBattlePassModel
        obj:SetIconData(self.listPremiumReward:Get(index))
        local eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS).isPurchasedPremium
        obj:ActiveUIPool(UIPoolType.Mask, not eventBattlePassModel)
        obj:RegisterShowInfo()
        obj:SetSize()
    end
    self.scrollPremiumReward = UILoopScroll(self.config.premiumRewardScroll, UIPoolType.RootIconView, onCreateItem)
end

function UIPreviewRewardBattlePassView:InitButtons()
    self.config.bgClose.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
    end)
    self.config.buttonUnlock.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBackOrClose()
        self.onClickUnlockPremium()
        self:OnClickUnlock()
    end)
end

--- @return void
--- @param result table
function UIPreviewRewardBattlePassView:Show(result)
    self:OnCreate()

    if result ~= nil and type(result) == 'table' then
        self.callbackClose = result.callbackClose
    end

    if result ~= nil and type(result) == 'table' then
        self.onClickUnlockPremium = result.onClickUnlockPremium
    end

    if self._canvas ~= nil then
        self._canvas.sortingOrder = 100 + self.uiTransform:GetSiblingIndex()
    end
    self:CheckLoadLocalize()
    self.uiTransform:SetAsLastSibling()
    self:ResetAlpha()
    self:SetActive(true)
    self:CheckBlur()
    self:OnChangeOrientation()
    self:OnReadyShow(result)
    self:CheckShowBgDark(result)
    self:CheckStartTimeRefreshNextDay()
    self:CheckCallbackAnimation()
    self:TriggerLoaded()

    if self.listenerChangeLanguage == nil then
        self.listenerChangeLanguage = RxMgr.changeLanguage:Subscribe(RxMgr.CreateFunction(self, self.CheckLoadLocalize))
    end
end

function UIPreviewRewardBattlePassView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("preview_battle_pass_reward")
    self.config.textFreePass.text = LanguageUtils.LocalizeCommon("free_reward")
    self.config.textPremiumPass.text = string.format("%s (%s)", LanguageUtils.LocalizeCommon("premium_reward"), LanguageUtils.LocalizeCommon("included_free"))
    self.config.textUnlock.text = LanguageUtils.LocalizeCommon("unlock_premium")
end

--- @param data {callbackClose : function}
function UIPreviewRewardBattlePassView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.data = data

    --- @type EventBattlePassModel
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    self.config.buttonUnlock.gameObject:SetActive(self.eventBattlePassModel.isPurchasedPremium == false)

    self:ShowRewards()
end

function UIPreviewRewardBattlePassView:OnClickUnlock()
    self.data.callBackBuyPremium = function()
        PopupMgr.HidePopup(self.model.uiName)
    end
    PopupMgr.ShowPopup(UIPopupName.UIUnlockBattlePass, self.data)
end

function UIPreviewRewardBattlePassView:ShowRewards()
    local lineRewardList = self.eventBattlePassModel:GetConfig():GetLineRewardConfig()
    self.listFreeReward = List()
    self.listPremiumReward = List()
    --XDebug.Log("count is " .. tostring(lineRewardList:Count()))
    --- @param v LineRewardConfig
    for _, v in pairs(lineRewardList:GetItems()) do
        if v.isFree then
            ClientConfigUtils.AddIconDataToList(self.listFreeReward, v.reward:GetIconData())
        end
        ClientConfigUtils.AddIconDataToList(self.listPremiumReward, v.reward:GetIconData())
    end

    self.scrollFreeReward:Resize(self.listFreeReward:Count())

    self.scrollPremiumReward:Resize(self.listPremiumReward:Count())
end

function UIPreviewRewardBattlePassView:Hide()
    UIBaseView.Hide(self)

    self.scrollFreeReward:Hide()

    self.scrollPremiumReward:Hide()
end

--- @return void
function UIPreviewRewardBattlePassView:OnReadyHide()
    if self.callbackClose ~= nil then
        self.callbackClose()
    end
    PopupMgr.HidePopup(self.model.uiName)
end