require "lua.client.scene.ui.home.uiFlashSale.UIFlashSaleModel"
local pivotTab = U_Vector2(0.865, 0.5)

local numberPackCount = 6

--- @class UIFlashSaleView : UIBaseView
UIFlashSaleView = Class(UIFlashSaleView, UIBaseView)

--- @param model UIFlashSaleModel
function UIFlashSaleView:Ctor(model)
    --- @type Dictionary
    self.flashSaleDict = List()

    --- @type UIFlashSaleConfig
    self.config = nil

    self.rewardTableView = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIFlashSaleBaseLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type number
    self.currentTab = nil
    UIBaseView.Ctor(self, model)
    --- @type UIFlashSaleModel
    self.model = model
end

--- @return void
function UIFlashSaleView:OnReadyCreate()

    ---@type UIFlashSaleConfig
    self.config = UIBaseConfig(self.uiTransform)

    uiCanvas:SetBackgroundSize(self.config.backGround)
    self:SetFlashSaleDict()

    self:_InitButtonListener()

    self:InitScrollTab()
end

--- @return GroupProductConfig
function UIFlashSaleView:GetGroupProductConfigByID(groupID)
    for k, v in pairs(self.model.listNewFlashSaleGroup:GetItems()) do
        if (v.groupId == groupID) then
            return v
        end
    end
    return nil
end

function UIFlashSaleView:SetFlashSaleDict()
    if (self.flashSaleDict == nil or self.flashSaleDict:Count() < numberPackCount) then
        self.flashSaleDict:Clear()
        self.flashSaleDict:Add(tonumber(FlashSalePackageType.WELCOME_PACKAGE), self.config.welcomeAnchor)
        self.flashSaleDict:Add(tonumber(FlashSalePackageType.SUMMONER_PACKAGE), self.config.summmonterAnchor)
        self.flashSaleDict:Add(tonumber(FlashSalePackageType.CHOSEN_PACKAGE), self.config.chosenAnchor)
        self.flashSaleDict:Add(tonumber(FlashSalePackageType.STONE_PACKAGE), self.config.stoneAnchor)
        self.flashSaleDict:Add(tonumber(FlashSalePackageType.DESTINY_PACKAGE), self.config.destinyAnchor)
        self.flashSaleDict:Add(tonumber(FlashSalePackageType.RESOURCE_PACKAGE), self.config.resourceAnchor)
    end
end

function UIFlashSaleView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
    if self.eventTabDict then
        --- @type UIEventPackageTabItem
        for k, v in pairs(self.eventTabDict:GetItems()) do
            ---@type GroupProductConfig
            local groupProductConfig = self:GetGroupProductConfigByID(k)
            if groupProductConfig then
                v:SetText(self:_GetPackageNameLocalizeByID(k))
            end
        end
    end
end

function UIFlashSaleView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIFlashSaleView:OnReadyShow()
    self.model:GetData()
    if self.model.listNewFlashSaleGroup:Count() < 0 then
        self:OnReadyHide()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        return
    end

    self:ResizeTab()

    --- @param v GroupProductConfig
    for k, v in pairs(self.model.listNewFlashSaleGroup:GetItems()) do
        local groupId = v.groupId
        if NotificationCheckUtils.IsFlashSaleTabNotification(groupId) == true then
            self:OnSelectTabByType(groupId)
            return
        end
    end
    --- @type GroupProductConfig
    local firstGroup = self.model.listNewFlashSaleGroup:Get(1)
    self:OnSelectTabByType(firstGroup.groupId)
end

function UIFlashSaleView:ShowCurrentSale()
    --- @type GroupProductConfig
    local groupProductConfig = self.model.groupProductConfig
    if (groupProductConfig == nil) then
        -- XDebug.Log("error here" .. tostring())
    end
    self:GetLayout(groupProductConfig.groupId)
    -- XDebug.Log("show current sale " .. tostring(groupProductConfig.groupId))
    self.layout:OnShow()
    self:EnableSelectTabState(groupProductConfig.groupId, true)
end

--- @return void
function UIFlashSaleView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, { ["isFromFlashSale"] = true }, self.model.uiName)
end

function UIFlashSaleView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIFlashSaleView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_info"))
end

function UIFlashSaleView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
    if self.notificationEvent ~= nil then
        self.notificationEvent:Unsubscribe()
        self.notificationEvent = nil
    end
end

--- @param groupID number
function UIFlashSaleView:OnSelectTabByType(groupID)
    if self.model:IsCurrentTab(groupID) == false then
        self:EnableSelectTabState(self.model.currentTab, false) -- toggle tab selected display
        self:HideLayout()
        self.model:SetTab(groupID)
        self:ShowCurrentSale() -- set hide old layout and show new layout
    end
end

--- @param flashSalePackageType FlashSalePackageType
function UIFlashSaleView:GetLayout(flashSalePackageType)
    flashSalePackageType = tonumber(flashSalePackageType)
    self:SetFlashSaleDict()
    self.layout = self.layoutDict:Get(flashSalePackageType)
    if self.layout == nil then
        require "lua.client.scene.ui.home.uiFlashSale.UIFlashSaleBaseLayout"
        local anchorParent
        if flashSalePackageType == FlashSalePackageType.WELCOME_PACKAGE then
            anchorParent = self.config.welcomeAnchor
        elseif flashSalePackageType == FlashSalePackageType.SUMMONER_PACKAGE then
            anchorParent = self.config.summmonterAnchor
        elseif flashSalePackageType == FlashSalePackageType.CHOSEN_PACKAGE then
            anchorParent = self.config.chosenAnchor
        elseif flashSalePackageType == FlashSalePackageType.UPGRADE_PACKAGE then
            anchorParent = self.config.upgradeAnchor
        elseif flashSalePackageType == FlashSalePackageType.STONE_PACKAGE then
            anchorParent = self.config.stoneAnchor
        elseif flashSalePackageType == FlashSalePackageType.DESTINY_PACKAGE then
            anchorParent = self.config.destinyAnchor
        elseif flashSalePackageType == FlashSalePackageType.RESOURCE_PACKAGE then
            anchorParent = self.config.resourceAnchor
        end
        if (anchorParent == nil) then
            XDebug.Log("nil anchor: pack Type " .. tostring(flashSalePackageType) .. " total pack count " .. tostring(self.flashSaleDict:Count()))
        end
        self.layout = UIFlashSaleBaseLayout(self, flashSalePackageType, anchorParent)
        self.layout:InitLocalization()
        self.layoutDict:Add(flashSalePackageType, self.layout)
    end
end

function UIFlashSaleView:InitScrollTab()
    --- @param obj UIEventPackageTabItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local groupProductConfig = self.model.listNewFlashSaleGroup:Get(dataIndex)
        --- @type number
        local groupId = groupProductConfig.groupId
        obj:SetText(UIFlashSaleView._GetPackageNameLocalizeByID(groupId))
        obj:SetSelectState(groupId == self.model.currentTab)
        obj:SetIcon(ResourceLoadUtils.LoadSpriteFromAtlas("IconTabFlashSale", groupId))
        --- @type ProgressPackCollection
        local progressPackCollection = zg.playerData:GetMethod(PlayerDataMethod.IAP).progressPackData
        local createdTime = progressPackCollection.activeProgressPackDict:Get(groupId)
        ---@type GroupProductConfig
        local groupProductConfig = self:GetGroupProductConfigByID(groupId)
        local endTime = createdTime + groupProductConfig.duration
        obj:SetNotificationFunction(function()
            return NotificationCheckUtils.IsFlashSaleTabNotification(groupId) == true
        end)
        obj:SetEndEventTime(endTime, function()
            self:_OnPackageTimeEnded(groupId)
        end)
        obj:AddOnSelectListener(function()
            self:OnSelectTabByType(groupId)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(groupId, obj)
        obj:SetActive(true)
    end
    --- @param obj UIEventPackageTabItem
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        local groupProductConfig = self.model.listNewFlashSaleGroup:Get(dataIndex)
        --- @type number
        local groupId = groupProductConfig.groupId
        obj:SetSelectState(groupId == self.model.currentTab)
    end
    self.scrollLoopTab = UILoopScroll(self.config.scrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

function UIFlashSaleView:DisableCommon()

end

function UIFlashSaleView:HideLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIFlashSaleView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideLayout()
    self:DisableCommon()
    if self.scrollLoopTab ~= nil then
        self.scrollLoopTab:Hide()
    end
    self.model.currentTab = -1
end

function UIFlashSaleView._GetPackageNameLocalizeByID(id)
    return LanguageUtils.LocalizeCommon("flash_sale_new_" .. tostring(id))
end

function UIFlashSaleView:ResizeTab()
    self.scrollLoopTab:Resize(self.model.listNewFlashSaleGroup:Count())
end

function UIFlashSaleView:_OnPackageTimeEnded(groupId)
    self:OnReadyShow()
end

--- @return UIFlashSalePackageTabItem
function UIFlashSaleView:SpawnTabItem(anchor)
    return SmartPool.Instance:SpawnLuaUIPool(UIPoolType.FlashSalePackageTabItem, anchor)
end

function UIFlashSaleView:EnableSelectTabState(groupID, isEnabled)
    if groupID == nil then
        return
    end
    --- @type UIFlashSalePackageTabItem
    local eventPackageTabItem = self.eventTabDict:Get(groupID)
    if eventPackageTabItem ~= nil then
        eventPackageTabItem:SetSelectState(isEnabled)
    end
end

--- @param groupId number
function UIFlashSaleView:UpdateNotificationByTab(groupId)
    --- @type UIFlashSalePackageTabItem
    local eventPackageTabItem = self.eventTabDict:Get(groupId)
    if eventPackageTabItem then
        eventPackageTabItem:UpdateNotification()
    end
end

function UIFlashSaleView:CheckAllNotificationTab()
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        v:UpdateNotification()
    end
end