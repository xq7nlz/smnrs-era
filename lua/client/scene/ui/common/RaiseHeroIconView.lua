--- @class RaiseHeroIconView : MotionIconView
RaiseHeroIconView = Class(RaiseHeroIconView, MotionIconView)

--- @param transform UnityEngine_RectTransform
function RaiseHeroIconView:Ctor(transform)
    MotionIconView.Ctor(self, transform)
    self:InitButtons()
    self:InitLocalization()
    ---@type RaiseLevelConfig
    self.raiseConfig = ResourceMgr.GetRaiseHeroConfig()
    ---@type PlayerRaiseLevelInbound
    self.inbound = nil
end

RaiseHeroIconView.STATE = {
    LOCKED = 1,
    UNLOCKED = 2,
    USED = 3,
    COUNT_DOWN = 4,
}

--- @return void
function RaiseHeroIconView:SetPrefabName()
    self.prefabName = 'raise_hero_icon_info'
    self.uiPoolType = UIPoolType.RaiseHeroIconView
end

--- @return void
--- @param transform UnityEngine_Transform
function RaiseHeroIconView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    --- @type RaiseHeroIconInfoConfig
    self.config = UIBaseConfig(transform)
end

function RaiseHeroIconView:InitButtons()
    self.config.buttonPlus.onClick:AddListener(function()
        self:OnClickPickHero()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.iconHeroAnchor.onClick:AddListener(function()
        self:OnClickUnBindingHero()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.buySlot.onClick:AddListener(function()
        self:OnClickBuySlot()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
    self.config.iconBlockCanBuy.onClick:AddListener(function()
        self:OnClickOpenSlot()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function RaiseHeroIconView:InitLocalization()
    self.config.timeOnCooldownText.text = LanguageUtils.LocalizeCommon("on_cooldown")
end

--- @param raisedSlotData RaisedSlotData
function RaiseHeroIconView:SetDataIcon(raisedSlotData, index, onRefreshCells)
    self:KillTween()
    self.onRefreshCells = onRefreshCells
    self.inbound = zg.playerData:GetRaiseLevelHero()
    self.index = index
    self.raisedSlotData = raisedSlotData
    if self.raisedSlotData == nil then
        self:SetLock()
    else
        self:SetupDisplay(raisedSlotData.state)
    end
end

--- @param raisedSlotData RaisedSlotData
function RaiseHeroIconView:SetActionUpdateRaisedCount(action)
    self.action = nil
    self.action = action
end

function RaiseHeroIconView:ResetEffect()
    Coroutine.start(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.CLAIM)
        self.config.resetEffect:SetActive(false)
        self.config.resetEffect:SetActive(true)
        self.resetEffect = coroutine.waitforseconds(1)
        self.config.resetEffect:SetActive(false)
    end)
end
--- @return void
function RaiseHeroIconView:SetupDisplay(state)
    if state == RaiseHeroIconView.STATE.LOCKED then
        self:SetLock()
    elseif state == RaiseHeroIconView.STATE.UNLOCKED then
        self:SetUnlock()
    elseif state == RaiseHeroIconView.STATE.USED then
        self:SetUsed()
    else
        self:SetCountDown()
    end
end

--- @return void
function RaiseHeroIconView:SetLock()
    self.config.iconBlockCanBuy.gameObject:SetActive(true)
    self.config.buttonPlus.gameObject:SetActive(false)
    self.config.countDownAnchor.gameObject:SetActive(false)
    self.config.iconHeroAnchor.gameObject:SetActive(false)

    local listReward = self.raiseConfig:GetUnLockPriceWithId(self.index)
    local canBuy = InventoryUtils.IsEnoughMultiResourceRequirement(listReward, false)
    ---@type PlayerRaiseLevelInbound
    local isNextSlot = self.inbound:IsNextSlot(self.index)

    local isEnable = canBuy and isNextSlot
    self.config.iconBlockCanNotBuy.gameObject:SetActive(not isEnable)
    self.config.noti.gameObject:SetActive(isEnable)
    if isEnable then
        self.config.button.onClick:RemoveAllListeners()
        self.config.button.onClick:AddListener(function()
        end)
    end
end

function RaiseHeroIconView:SetUnlock()
    self.config.iconBlockCanBuy.gameObject:SetActive(false)
    self.config.countDownAnchor.gameObject:SetActive(false)
    self.config.buttonPlus.gameObject:SetActive(true)
    self.config.iconHeroAnchor.gameObject:SetActive(false)
end

function RaiseHeroIconView:SetUsed()
    if self.heroIconView == nil then
        --- @type HeroIconView
        self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.iconHeroAnchor.transform)
    end
    self.config.countDownAnchor.gameObject:SetActive(false)
    self.config.iconBlockCanBuy.gameObject:SetActive(false)
    self.config.buttonPlus.gameObject:SetActive(false)
    self.config.iconHeroAnchor.gameObject:SetActive(true)
    local data = InventoryUtils.GetHeroResourceByInventoryId(self.raisedSlotData.inventoryId)

    ---@type HeroIconData
    local heroIconData = HeroIconData.CreateByHeroResource(data)
    heroIconData.level = self.inbound.pentaGram:GetLowestHero()

    self.heroIconView:SetIconData(heroIconData)
    data.heroLevel = self.inbound.pentaGram:GetLowestHero()
end

function RaiseHeroIconView:SetCountDown()
    self.config.countDownAnchor.gameObject:SetActive(true)
    self.config.iconBlockCanBuy.gameObject:SetActive(false)
    self.config.buttonPlus.gameObject:SetActive(false)
    self.config.iconHeroAnchor.gameObject:SetActive(false)
    self:UpdateTime()
    self:UpdatePriceForSkipCountDown()
end

function RaiseHeroIconView:UpdatePriceForSkipCountDown()
    self.slotConfig = ResourceMgr.GetRaiseHeroConfig():GetSlotConfig()
    self.config.textMoney.text = self.slotConfig.rewardInbound.number
    self.config.iconMoney.sprite = ResourceLoadUtils.LoadMoneyIcon(self.slotConfig.rewardInbound.id)
end

function RaiseHeroIconView:OnClickPickHero()
    PopupMgr.ShowPopup(UIPopupName.UIRaisePickHero, { ["index"] = self.index, ["resetEffect"] = function()
        -- self:ResetEffect()
        if self.action ~= nil then
            self.action()
        end
    end })
end

function RaiseHeroIconView:OnClickUnBindingHero()
    PopupMgr.ShowPopup(UIPopupName.UIPopupUnbindingRaiseHero, { ["index"] = self.index, ["inventoryId"] = self.raisedSlotData.inventoryId, ["resetEffect"] = function()
        self:ResetEffect()
        if self.action ~= nil then
            self.action()
        end
    end })
end

function RaiseHeroIconView:OnClickBuySlot()
    PopupMgr.ShowPopup(UIPopupName.UIPopupResetCoolDownRaiseHero, { ["index"] = self.index, ["resetEffect"] = function()
        self:ResetEffect()
        if self.action ~= nil then
            self.action()
        end
    end })
end

function RaiseHeroIconView:ShowConfirmOpenSlot()
    local data = {}
    local rewardList = self.raiseConfig:GetUnLockPriceWithId(self.index)
    data.notification = LanguageUtils.LocalizeCommon("noti_confirm_resource")
    data.alignment = U_TextAnchor.MiddleCenter
    data.canCloseByBackButton = true
    local itemIconList = List()
    for i = 1, rewardList:Count() do
        ---@type RewardInBound
        local data = rewardList:Get(i)
        ---@type ItemIconData
        local itemIconData = ItemIconData.CreateInstance(data.type, data.id, data.number)
        itemIconList:Add(itemIconData)
    end
    data.listItem = itemIconList
    local buttonNo = {}
    buttonNo.text = LanguageUtils.LocalizeCommon("cancel")
    buttonNo.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
    end
    data.button1 = buttonNo

    local buttonYes = {}
    buttonYes.text = LanguageUtils.LocalizeCommon("confirm")
    buttonYes.callback = function()
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
        self:OnConfirmOpenSlot()
    end
    data.button2 = buttonYes
    PopupMgr.ShowPopup(UIPopupName.UIPopupNotification, data)
end

function RaiseHeroIconView:IsShowConfirmOpenSlot()
    local listReward = self.raiseConfig:GetUnLockPriceWithId(self.index)
    for i = 1, listReward:Count() do
        ---@type RewardInBound
        local data = listReward:Get(i)
        if data.id == MoneyType.GEM then
            return true
        end
    end
    return false
end

function RaiseHeroIconView:OnClickOpenSlot()
    local isNextSlot = self.inbound:IsNextSlot(self.index)
    local isShowConfirm = self:IsShowConfirmOpenSlot()
    if isNextSlot then
        local listReward = self.raiseConfig:GetUnLockPriceWithId(self.index)
        local canBuy = InventoryUtils.IsEnoughMultiResourceRequirement(listReward)
        if canBuy then
            if isShowConfirm then
                self:ShowConfirmOpenSlot()
            else
                self:OnConfirmOpenSlot()
            end
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("open_slot_before"))
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
    end
end

function RaiseHeroIconView:OnConfirmOpenSlot()
    local listReward = self.raiseConfig:GetUnLockPriceWithId(self.index)
    local success = function()
        self.inbound:AddOpenedSlot(self.index)
        for i = 1, listReward:Count() do
            local rewardInbound = listReward:Get(i)
            InventoryUtils.SubSingleRewardInBound(rewardInbound)
        end
        if self.onRefreshCells ~= nil then
            self:ResetEffect()
            self.onRefreshCells()
        end
        if self.action ~= nil then
            self.action()
        end
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("unlock_slot_success"))
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeLogicCode(logicCode))
    end
    NetworkUtils.RequestAndCallback(OpCode.RAISE_HERO_UNLOCK_SLOT, UnknownOutBound.CreateInstance(PutMethod.Byte, self.index), success, onFailed)
end

function RaiseHeroIconView:UpdateTime()
    if self.raisedSlotData.state == RaiseHeroIconView.STATE.COUNT_DOWN then
        self.updateTimeCoroutine = Coroutine.start(function()
            while self.raisedSlotData.updateTime > 0 do
                self.raisedSlotData.updateTime = self.raisedSlotData.updateTime - 1
                self.config.timeCountDown.text = TimeUtils.SecondsToClock(self.raisedSlotData.updateTime)
                coroutine.waitforseconds(1)
            end
            if self.raisedSlotData.updateTime == 0 then
                self.raisedSlotData.state = RaiseHeroIconView.STATE.UNLOCKED
                self:SetupDisplay(self.raisedSlotData.state)
            end
        end)
    end
end

function RaiseHeroIconView:KillTween()
    if self.updateTimeCoroutine ~= nil then
        Coroutine.stop(self.updateTimeCoroutine)
        self.updateTimeCoroutine = nil
    end
    if self.resetEffect ~= nil then
        Coroutine.stop(self.resetEffect)
        self.resetEffect = nil
    end
end

function RaiseHeroIconView:ReturnPool()
    MotionIconView.ReturnPool(self)

    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

return RaiseHeroIconView