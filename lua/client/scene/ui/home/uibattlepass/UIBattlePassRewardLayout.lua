require "lua.client.core.network.playerData.unknown.ListNumberOutBound"
require "lua.client.scene.ui.home.uiBattlePass.UIBattlePassLayout"

--- @class UIBattlePassRewardLayout : UIBattlePassLayout
UIBattlePassRewardLayout = Class(UIBattlePassRewardLayout, UIBattlePassLayout)

--- @param view UIBattlePassView
function UIBattlePassRewardLayout:Ctor(view, anchor)
    ---@type UIBattlePassView
    self.view = view
    ---@type UIBattlePassConfig
    self.config = view.config
    ---@type UIBattlePassRewardLayoutConfig
    self.layoutConfig = UIBaseConfig(self.config.rewardLayout)
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    self:InitScrolls()
    ---@type List
    self.listLineReward = List()
    UIBattlePassLayout.Ctor(self, view, anchor)
end

function UIBattlePassRewardLayout:GetDataAndUpdateView()
    ---@type EventBattlePassConfig
    local eventConfig = self.view.eventBattlePassModel:GetConfig()
    ---@type List
    self.listLineReward = eventConfig:GetLineRewardConfig()
    local count = self.listLineReward:Count()
    self.uiScroll:Resize(count)
    local canClaimAll = self.view.eventBattlePassModel:CanClaimAllReward()
    self.layoutConfig.claimDisable.gameObject:SetActive(not canClaimAll)
    self:ScrollToNearestRewardIndexCanClaim()
end

function UIBattlePassRewardLayout:ScrollToNearestRewardIndexCanClaim()
    local index = tonumber(self.view.eventBattlePassModel:GetNearestRewardIndexCanClaim())
    if (index > 0) then
        self.uiScroll:ScrollToCell(index - 1, 4500)
    end
end

function UIBattlePassRewardLayout:InitScrolls()
    --- @param obj UIBattlePassRewardItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        ---@type LineRewardConfig
        local lineRewardConfig = self.listLineReward:Get(index + 1)
        ---@type RewardInBound
        local data = {}
        ---@type LineRewardConfig
        data.lineRewardConfig = lineRewardConfig
        data.rewardIndex = index + 1
        data.currentLevel = self.view.curLevelOnEXP.level
        data.userUnlockedPremium = self.view.eventBattlePassModel.isPurchasedPremium
        --XDebug.Log("PURCHASE PREMIUM " .. tostring(self.view.eventBattlePassModel.isPurchasedPremium))
        data.numberOfItems = self.listLineReward:Count()
        data.claimed = self.view.eventBattlePassModel:RewardClaimed(lineRewardConfig.level)
        obj:SetData(data)

    end
    --- @param obj UIBattlePassRewardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        onUpdateItem(obj, index)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.loopScrollReward, UIPoolType.UIBattlePassRewardItemView, onCreateItem, onUpdateItem)
end

function UIBattlePassRewardLayout:InitButtons()
    self.layoutConfig.buttonClaimAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClaimRewardBtnClick()
    end)
    self.layoutConfig.buttonRewardPreview.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRewardPreviewBtn()
    end)
end

function UIBattlePassRewardLayout:ClaimReward(listAllLevelNeedClaim)
    ---@type ListNumberOutBound
    local listNumberOutBound = ListNumberOutBound.CreateInstance(listAllLevelNeedClaim)
    local onBufferReading = function(buffer)
        local rewardList = NetworkUtils.GetRewardInBoundList(buffer)
        PopupUtils.ClaimAndShowRewardList(rewardList)
        self.view.eventBattlePassModel:UpdateLevelRewardClaimed(listAllLevelNeedClaim)

        self:GetDataAndUpdateView()

        self.view:CheckNotification()
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_BATTLE_PASS_LEVEL_REWARD, listNumberOutBound, nil, nil, onBufferReading)
end

function UIBattlePassRewardLayout:OnClaimRewardBtnClick()
    local listAllLevelNeedClaim = self.view.eventBattlePassModel:GetListRewardCanClaim()
    if (listAllLevelNeedClaim:Count() == 0) then
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
        return
    end

    local onPremiumUnlockSuccess = function()
        self.view:OnPurchasePremiumSuccess()
    end

    local confirmCallback = function()
        self:ClaimReward(listAllLevelNeedClaim)
    end

    local onClickUnlockPremium = function()
        if self.view.worldSpaceHeroView ~= nil then
            self.view.worldSpaceHeroView.config.gameObject:SetActive(false)
        end
    end
    local callbackClose = function()
        if self.view.worldSpaceHeroView ~= nil then
            self.view.worldSpaceHeroView.config.gameObject:SetActive(true)
        end
    end

    if (self.view.eventBattlePassModel.isPurchasedPremium) then
        self:ClaimReward(listAllLevelNeedClaim)
    else
        PopupMgr.ShowPopup(UIPopupName.UIConfirmClaimRewardBattlePass,
                { ["claimRewardCallBack"] = confirmCallback,
                  ["onPremiumUnlockSuccess"] = onPremiumUnlockSuccess,
                  ["onClickUnlockPremium"] = onClickUnlockPremium,
                  ["callbackClose"] = callbackClose,
                  ["haveSkin"] = self.view.haveSkin,
                  ["skinId"] = self.view.skinId
                })
    end
end

function UIBattlePassRewardLayout:OnClickRewardPreviewBtn()
    local data = {}
    data.onUnlockSuccess = function()
        self.view.eventBattlePassModel:OnUpdatePurchasePremiumSuccess()
        self.view:OnUpdatePurchase()
    end
    data.onClickUnlockPremium = function()
        if self.worldSpaceHeroView ~= nil then
            self.worldSpaceHeroView.config.gameObject:SetActive(false)
        end
    end
    data.callbackClose = function()
        if self.worldSpaceHeroView ~= nil then
            self.worldSpaceHeroView.config.gameObject:SetActive(true)
        end
    end
    data.haveSkin = self.view.haveSkin
    data.skinId = self.view.skinId
    PopupMgr.ShowPopup(UIPopupName.UIPreviewRewardBattlePass, data)
end

function UIBattlePassRewardLayout:_InitConfig()

end

function UIBattlePassRewardLayout:OnShow()
    self.anchor.gameObject:SetActive(true)
    self.layoutConfig.buttonClaimAll.gameObject:SetActive(true)
    self.layoutConfig.buttonRewardPreview.gameObject:SetActive(true)
    self:GetDataAndUpdateView()
end

function UIBattlePassRewardLayout:OnHide()
    if (self.uiScroll ~= nil) then
        self.uiScroll:Hide()
    end
    self.layoutConfig.buttonClaimAll.gameObject:SetActive(false)
    self.layoutConfig.buttonRewardPreview.gameObject:SetActive(false)
    self.anchor.gameObject:SetActive(false)
end

function UIBattlePassRewardLayout:InitLocalization()
    self.layoutConfig.textClaimAll.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.textRewardPreview.text = LanguageUtils.LocalizeCommon("button_battle_pass_reward_preview")
end


