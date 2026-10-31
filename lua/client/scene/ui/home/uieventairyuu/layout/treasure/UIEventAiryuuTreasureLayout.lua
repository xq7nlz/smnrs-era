--- @class UIEventAiryuuTreasureLayout : UIEventAiryuuLayout
UIEventAiryuuTreasureLayout = Class(UIEventAiryuuTreasureLayout, UIEventAiryuuLayout)

local TreasureChest = {
    Spawn = 1,
    Idle = 2,
    Open = 3,
    OpenIdle = 4,
}

--- @param view UIEventAiryuuView
--- @param anchor UnityEngine_RectTransform
function UIEventAiryuuTreasureLayout:Ctor(view, tab, anchor)
    --- @type UIEventAiryuuView
    self.view = view
    --- @type MoneyBarView
    self.moneyBarView = nil
    ---@type UIEventAiryuuTreasureLayoutConfig
    self.layoutConfig = nil
    self.enableAnimation = true
    UIEventAiryuuLayout.Ctor(self, view, tab, anchor)
end

function UIEventAiryuuTreasureLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_airyuu_treasure_layout", self.anchor)
    UIEventAiryuuLayout.InitLayoutConfig(self, inst)
    self:InitButton()
    self:InitLocalization()
end

function UIEventAiryuuTreasureLayout:InitLocalization()
    UIEventAiryuuLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("airyuu_treasure")
    self.layoutConfig.textTitleDetail.text = LanguageUtils.LocalizeCommon("airyuu_treasure_infor")
    self.layoutConfig.textX1.text = LanguageUtils.LocalizeCommon("open_x1")
    self.layoutConfig.textAll.text = LanguageUtils.LocalizeCommon("open_all")
    self.layoutConfig.textEnableAnimation.text = LanguageUtils.LocalizeCommon("enable_animation")

end

function UIEventAiryuuTreasureLayout:InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
        self.moneyBarView:SetIconData(MoneyType.EVENT_AIRYUU_TREASURE_KEY)
        self.moneyBarView.config.buttonInfo.interactable = true
        self.moneyBarView.config.buttonInfo.onClick:RemoveAllListeners()
        self.moneyBarView.config.buttonInfo.onClick:AddListener(function()
            zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
            self.moneyBarView:ShowInfo()
        end)
        self.moneyBarView:AddListener(function()
            self.view:SelectTab(EventAiryuuTab.HERO_BUNDLE)
        end)
    end
end

function UIEventAiryuuTreasureLayout:ReturnPoolMoneyBar()
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
end

function UIEventAiryuuTreasureLayout:InitButton()
    self.layoutConfig.buttonX1.onClick:AddListener(function()
        self:OnClickOpenChest()
    end)
    self.layoutConfig.chestButton.onClick:AddListener(function()
        self:OnClickChest()
    end)
    self.layoutConfig.chestAnimButton.onClick:AddListener(function()
        self:OnClickChest()
    end)
    self.layoutConfig.buttonAll.onClick:AddListener(function()
        self:OnClickOpenChest(true)
    end)
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_airyuu_treasure_info"))
    end)
    self.layoutConfig.buttonReward.onClick:AddListener(function()
        self:OnClickChest()
    end)
    self.layoutConfig.checkbox.onClick:AddListener(function()
        self:OnClickCheckbox()
    end)
end

--- @return void
function UIEventAiryuuTreasureLayout:OnClickCheckbox()
    self.enableAnimation = not self.enableAnimation
    self:InitTickEnableAnimation()
    self.layoutConfig.buttonChestAnimGameObject:SetActive(self.enableAnimation)
    self:PlayChestAnimation(TreasureChest.Idle)
end

function UIEventAiryuuTreasureLayout:InitTickEnableAnimation()
    self.layoutConfig.iconTick.gameObject:SetActive(self.enableAnimation)
    self.layoutConfig.chestGameObject:SetActive(not self.enableAnimation)
end

function UIEventAiryuuTreasureLayout:PlayChestAnimation(anim, isLoop)
    local isLoop = isLoop or false
    self.layoutConfig.skeletonAnim:ClearState()
    self.layoutConfig.skeletonAnim.AnimationState:ClearTracks()
    self.layoutConfig.skeletonAnim.skeleton:SetToSetupPose()
    if not self.layoutConfig.skeletonAnim.enabled then
        self.layoutConfig.skeletonAnim.enabled = true
    end
    if anim == TreasureChest.Spawn then
        self.layoutConfig.buttonChestAnimGameObject:SetActive(false)
        self.layoutConfig.buttonChestAnimGameObject:SetActive(true)
        local trackEntry = self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, "spawn", isLoop)
        trackEntry:AddCompleteListenerFromLua(function()
            self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, "idle", true)
        end)
    elseif anim == TreasureChest.Idle then
        self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, "idle", true)
    elseif anim == TreasureChest.Open then
        local trackEntry = self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, "open", isLoop)
        trackEntry:AddCompleteListenerFromLua(function()
            self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, "idle", true)
        end)
    elseif anim == TreasureChest.OpenIdle then
        self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, "open_idle", isLoop)
    else

    end
end

function UIEventAiryuuTreasureLayout:ResetAnim()
    self.layoutConfig.skeletonAnim:ClearState()
    self.layoutConfig.skeletonAnim.AnimationState:ClearTracks()
end

--- @return void
function UIEventAiryuuTreasureLayout:OnClickChest()
    ---@type Dictionary
    local treasureRateDict = Dictionary()
    local data = {}
    data.uiPoolType = UIPoolType.RateView
    treasureRateDict, data.listRewardIconData = self.eventModel.config:GetTreasureRateConfig()
    PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

--- @return void
function UIEventAiryuuTreasureLayout:StopCoroutine()
    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

function UIEventAiryuuTreasureLayout:PlayAinmBeforeCallOpcode(isAllIn, isFree)
    if self.enableAnimation then
        self:PlayChestAnimation(TreasureChest.Open, false)
        self.coroutine = Coroutine.start(function()
            self:SetButtonInteractable(isAllIn, false)
            coroutine.waitforseconds(1.5)
            self:CallOpcode(isAllIn, isFree)
            coroutine.waitforseconds(0.5)
            self:SetButtonInteractable(isAllIn, true)
        end)
    else
        self.coroutine = Coroutine.start(function()
            self:SetButtonInteractable(isAllIn, false)
            coroutine.waitforseconds(0.4)
            self:CallOpcode(isAllIn, isFree)
            coroutine.waitforseconds(0.1)
            self:SetButtonInteractable(isAllIn, true)
        end)
    end
end

function UIEventAiryuuTreasureLayout:SetButtonInteractable(isAllIn, isInteractable)
    if isAllIn then
        self.layoutConfig.buttonAll.interactable = isInteractable
    else
        self.layoutConfig.buttonX1.interactable = isInteractable
    end
end

function UIEventAiryuuTreasureLayout:OnClickOpenChest(isAllIn)
    self.treasureFreeDaily = self.eventModel:GetTreasureFreeDaily()
    if self.treasureFreeDaily >= self.eventModel.config:GetTreasureFreeDailyConfig() then
        local number = InventoryUtils.GetMoney(MoneyType.EVENT_AIRYUU_TREASURE_KEY)
        local canOpen = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_AIRYUU_TREASURE_KEY, 1))
        if canOpen then
            if isAllIn then
                local yesCallback = function()
                    self:PlayAinmBeforeCallOpcode(isAllIn)
                end
                PopupUtils.ShowPopupNotificationYesNo(string.format("%s: %d %s",
                        LanguageUtils.LocalizeCommon("confirm_use_all"), number,
                        UIUtils.SetColorString(UIUtils.green_dark,
                                LanguageUtils.GetStringResourceName(ResourceType.Money, MoneyType.EVENT_AIRYUU_TREASURE_KEY)))
                , nil, yesCallback)
            else
                self:PlayAinmBeforeCallOpcode()
            end
        end
    else
        self:PlayAinmBeforeCallOpcode(isAllIn, true)
    end
end

function UIEventAiryuuTreasureLayout:CallOpcode(isAllIn, isFreeOpen)
    if PopupUtils.IsPopupShowing(UIPopupName.UIPopupNotification) then
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
    end
    local number
    if isAllIn then
        number = InventoryUtils.GetMoney(MoneyType.EVENT_AIRYUU_TREASURE_KEY)
    else
        number = 1
    end
    local rewardList = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        if not isFreeOpen then
            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_AIRYUU_TREASURE_KEY, number)
        else
            self.eventModel:AddTreasureFreeDaily()
        end
        if rewardList ~= nil or rewardList:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList)
        end
        self:SetButton()
    end
    local isFree = isFreeOpen or false
    local outBound = UnknownOutBound.CreateInstance(PutMethod.Bool, not isAllIn, PutMethod.Bool, isFree)

    local onFailed = function(logicCode)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
        SmartPoolUtils.ShowShortNotification(logicCode)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_HERO_AIRYUU_TREASURE_OPEN, outBound, onSuccess, onFailed, onBufferReading)
end

function UIEventAiryuuTreasureLayout:SetButton()
    local remain = self.eventModel.config:GetTreasureFreeDailyConfig() - self.eventModel:GetTreasureFreeDaily()
    if remain > 0 then
        self.layoutConfig.notiFree.gameObject:SetActive(true)
        self.layoutConfig.textX1.text = LanguageUtils.LocalizeCommon("free")
        self.layoutConfig.textFreeRemain.text = string.format("%s: %s", LanguageUtils.LocalizeCommon("remaining"), UIUtils.SetColorString(UIUtils.red_light, remain))
        self.layoutConfig.textFreeRemain.gameObject:SetActive(true)
    else
        self.layoutConfig.notiFree.gameObject:SetActive(false)
        self.layoutConfig.textX1.text = LanguageUtils.LocalizeCommon("open_x1")
        self.layoutConfig.textFreeRemain.gameObject:SetActive(false)
    end
end

function UIEventAiryuuTreasureLayout:OnShow()
    UIEventAiryuuLayout.OnShow(self)
    if not self.eventModel then
        self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
    end
    self:InitMoneyBar()
    self.layoutConfig.buttonInfor.gameObject:SetActive(false)
    self.layoutConfig.buttonReward.gameObject:SetActive(false)
    self.anchor.gameObject:SetActive(true)
    self.layoutConfig.key.gameObject:SetActive(false)
    self:SetButton()
    self:InitTickEnableAnimation()
    if self.enableAnimation then
        self:PlayChestAnimation(TreasureChest.Spawn)
    end
    self:SetButtonInteractable(false, true)
    self:SetButtonInteractable(true, true)
end

function UIEventAiryuuTreasureLayout:SetUpLayout()
    UIEventAiryuuLayout.SetUpLayout(self)
end

function UIEventAiryuuTreasureLayout:OnHide()
    self:ReturnPoolMoneyBar()
    self:StopCoroutine()
    self:ResetAnim()
    UIEventAiryuuLayout.OnHide(self)
end
