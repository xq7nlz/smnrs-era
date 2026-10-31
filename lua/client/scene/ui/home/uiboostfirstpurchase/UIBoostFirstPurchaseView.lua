--- @class UIBoostFirstPurchaseView : UIBaseView
UIBoostFirstPurchaseView = Class(UIBoostFirstPurchaseView, UIBaseView)

local ItemSize = 1500
local PaddingSize = 100

--- @param model UIBoostFirstPurchaseModel
function UIBoostFirstPurchaseView:Ctor(model)
    UIBaseView.Ctor(self, model)
    --- @type UIBoostFirstPurchaseConfig
    self.config = nil
    --- @type UIBoostFirstPurchaseModel
    self.model = model
    ---@type boolean
    self.alreadyIAP = true
    ---@type GroupProductConfig
    self.groupBundle = nil
    ---@type List
    self.listProductConfig = nil
    ---@type List
    self.listBundlePackItem = List()
    ---@type List
    self.listDotSelect = List()
    ---@type number
    self.currentIndex = nil
    ---@type BoostFirstPurchaseCollection
    self.boostFirstPurchaseCollection = BoostFirstPurchaseCollection()
end

function UIBoostFirstPurchaseView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:GetGroupBundle()
    self:GetGroupBundleBuyDict()
    self:GetGroupBundleEndTime()
    self:InitButtons()
end

function UIBoostFirstPurchaseView:InitButtons()
    self.config.btnClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonLeft.onClick:AddListener(function()
        self:PreviousBundle()
    end)
    self.config.buttonRight.onClick:AddListener(function()
        self:NextBundle()
    end)
end

function UIBoostFirstPurchaseView:InitLocalization()

end

function UIBoostFirstPurchaseView:CheckArrow()
    if self.currentIndex == 1 then
        self.config.buttonLeft.gameObject:SetActive(false)
        self.config.buttonRight.gameObject:SetActive(true)
    elseif self.currentIndex == self.listProductConfig:Count() then
        self.config.buttonLeft.gameObject:SetActive(true)
        self.config.buttonRight.gameObject:SetActive(false)
    else
        self.config.buttonLeft.gameObject:SetActive(true)
        self.config.buttonRight.gameObject:SetActive(true)
    end
end

function UIBoostFirstPurchaseView:SetStateDotSelect()
    ---@param v DotSelect
    for k, v in pairs(self.listDotSelect:GetItems()) do
        if k == self.currentIndex then
            v:SetActiveState(true)
        else
            v:SetActiveState(false)
        end
    end
end

function UIBoostFirstPurchaseView:ResetStateDotSelect()
    ---@param v DotSelect
    for _, v in pairs(self.listDotSelect:GetItems()) do
        v:SetActiveState(false)
    end
end

function UIBoostFirstPurchaseView:NextBundle()
    self:Move(true, 1)
end

function UIBoostFirstPurchaseView:PreviousBundle()
    self:Move(false, -1)
end

function UIBoostFirstPurchaseView:Move(isMoveLeft, times)
    local times = times or 1
    self.currentIndex = self.currentIndex + times
    ---@type UnityEngine_Vector2
    local pos = self.config.bundleAnchor.anchoredPosition
    local currentPosX = pos.x
    self.coroutine = Coroutine.start(function()
        self:SetAllDotSelectInteractable(false)
        self:SetButtonInteractable(false)
        while true do
            coroutine.waitforendofframe()
            if isMoveLeft then
                if pos.x - (ItemSize + PaddingSize) / ClientConfigUtils.FPS > currentPosX - (ItemSize + PaddingSize) * math.abs(times) then
                    pos.x = pos.x - (ItemSize + PaddingSize) / ClientConfigUtils.FPS
                else
                    pos.x = currentPosX - (ItemSize + PaddingSize) * math.abs(times)
                    self.config.bundleAnchor.anchoredPosition = pos
                    break
                end
            else
                if pos.x + (ItemSize + PaddingSize) / ClientConfigUtils.FPS < currentPosX + (ItemSize + PaddingSize) * math.abs(times) then
                    pos.x = pos.x + (ItemSize + PaddingSize) / ClientConfigUtils.FPS
                else
                    pos.x = currentPosX + (ItemSize + PaddingSize) * math.abs(times)
                    self.config.bundleAnchor.anchoredPosition = pos
                    break
                end
            end
            self.config.bundleAnchor.anchoredPosition = pos
        end
        self:SetButtonInteractable(true)
        self:CheckArrow()
        self:SetStateDotSelect()
        self:SetAllDotSelectInteractable(true)
    end)
end

function UIBoostFirstPurchaseView:ResetBundleAnchorPosition()
    local pos = self.config.bundleAnchor.anchoredPosition
    self.config.bundleAnchor.anchoredPosition = Vector2(0, pos.y)
end

function UIBoostFirstPurchaseView:SetButtonInteractable(isInteractable)
    self.config.buttonLeft.interactable = isInteractable
    self.config.buttonRight.interactable = isInteractable
end

function UIBoostFirstPurchaseView:GetGroupBundle()
    self.groupBundle = self.model:GetListBundle()
    self.listProductConfig = self.groupBundle.listProductConfig
end

function UIBoostFirstPurchaseView:GetGroupBundleBuyDict()
    --- @type IapDataInBound
    local iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self.boostFirstPurchaseCollection = iapDataInBound.boostFirstPurchaseCollection
end

function UIBoostFirstPurchaseView:GetGroupBundleEndTime()
    local createdTime = self.boostFirstPurchaseCollection:GetCreatedTime()
    local durationTme = self.groupBundle.duration
    self.endTime = createdTime + durationTme
    return self.endTime
end

function UIBoostFirstPurchaseView:InitBundleItem()
    ---@param v ProductConfig
    for _, v in pairs(self.listProductConfig:GetItems()) do
        ---@type PurchaseBundleItem
        local purchaseBundleItem = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.PurchaseBundleItem, self.config.bundleAnchor)
        local isAvailable = v.stock > self.boostFirstPurchaseCollection:GetBoughtCount(v.id)
        purchaseBundleItem:SetData(v, self.endTime)
        purchaseBundleItem:SetBuyState(isAvailable)
        purchaseBundleItem:AddListener(function()
            self:OnClickBuy(v, isAvailable, purchaseBundleItem)
        end)
        self.listBundlePackItem:Add(purchaseBundleItem)
    end
end

---@param productConfig ProductConfig
---@param isAvailable boolean
------ @param purchaseBundleItem PurchaseBundleItem
function UIBoostFirstPurchaseView:OnClickBuy(productConfig, isAvailable, purchaseBundleItem)
    if isAvailable then
        BuyUtils.InitListener(
                function()
                    RxMgr.notificationPurchasePacks:Next()
                    purchaseBundleItem:SetBuyState(false)
                    purchaseBundleItem:AddListener( function()
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
                    end)
                end)
        RxMgr.purchaseProduct:Next(productConfig.productID)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function UIBoostFirstPurchaseView:SetPopupSeen()
    local remoteConfigData = zg.playerData.remoteConfig
    if remoteConfigData.isBoostFirstPurchaseSeen == nil then
        remoteConfigData.isBoostFirstPurchaseSeen = true
    end
    zg.playerData:SaveRemoteConfig()
end

--- @param data {callbackClose : function}
function UIBoostFirstPurchaseView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    UIBaseView.OnReadyShow(self, data)
    self.currentIndex = 1
    self:ResetBundleAnchorPosition()
    self:InitLocalization()
    self:GetGroupBundle()
    self:GetGroupBundleBuyDict()
    self:GetGroupBundleEndTime()
    self:CheckBundleTime()
    self:CheckArrow()
    self:SetPopupSeen()
    self:InitBundleItem()
    self:InitDotSelect()
    self:SetStateDotSelect()
end

function UIBoostFirstPurchaseView:CheckBundleTime()
    if not self.groupBundle then
        self:OnReadyHide()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
    end
end

function UIBoostFirstPurchaseView:InitDotSelect()
    for i = 1, self.listProductConfig:Count() do
        ---@type DotSelect
        local dotSelect = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.DotSelect, self.config.dotAnchor)
        dotSelect:AddListener(function()
            self:ResetStateDotSelect()
            local times = i - self.currentIndex
            if times ~= 0 then
                self:Move(times > 0, times)
            end
        end)
        self.listDotSelect:Add(dotSelect)
    end
end

function UIBoostFirstPurchaseView:ReturnPoolBundlePackItem()
    ---@param v PurchaseBundleItem
    for _, v in pairs(self.listBundlePackItem:GetItems()) do
        v:ReturnPool()
    end
    self.listBundlePackItem:Clear()
end

function UIBoostFirstPurchaseView:SetAllDotSelectInteractable(isInteractable)
    ---@param v DotSelect
    for _, v in pairs(self.listDotSelect:GetItems()) do
        v:SetButton(isInteractable)
    end
end

function UIBoostFirstPurchaseView:ReturnPoolDotSelect()
    ---@param v DotSelect
    for _, v in pairs(self.listDotSelect:GetItems()) do
        v:ReturnPool()
    end
    self.listDotSelect:Clear()
end

function UIBoostFirstPurchaseView:KillCoroutine()
    if self.coroutine then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

function UIBoostFirstPurchaseView:Hide()
    UIBaseView.Hide(self)
    self:ReturnPoolBundlePackItem()
    self:ReturnPoolDotSelect()
    self:KillCoroutine()
    self:SetButtonInteractable(true)
end

function UIBoostFirstPurchaseView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end
