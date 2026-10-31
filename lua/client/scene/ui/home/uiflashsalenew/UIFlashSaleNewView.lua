require "lua.client.scene.ui.home.uiFlashSaleNew.UIFlashSaleNewModel"
local pivotTab = U_Vector2(0.865, 0.5)

--- @class UIFlashSaleNewView : UIBaseView
UIFlashSaleNewView = Class(UIFlashSaleNewView, UIBaseView)

--- @param model UIFlashSaleNewModel
function UIFlashSaleNewView:Ctor(model)
    --- @type Dictionary
    self.flashSaleDict = List()

    --- @type UIFlashSaleNewConfig
    self.config = nil

    self.rewardTableView = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIFlashSaleNewBaseLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type number
    self.currentTab = nil
    UIBaseView.Ctor(self, model)
    --- @type UIFlashSaleNewModel
    self.model = model
end

--- @return void
function UIFlashSaleNewView:OnReadyCreate()

    ---@type UIFlashSaleNewConfig
    self.config = UIBaseConfig(self.uiTransform)

    self:SetFlashSaleDict()

    self:InitButtonListener()

    self:InitScrollTab()
end

--- @return GroupProductConfig
function UIFlashSaleNewView:GetGroupProductConfigByID(groupID)
    for k, v in pairs(self.model.listNewFlashSaleGroup:GetItems()) do
        if (v.groupId == groupID) then
            return v
        end
    end
    return nil
end

function UIFlashSaleNewView:SetFlashSaleDict()
    if (self.flashSaleDict == nil or self.flashSaleDict:Count() == 0) then
        for i = 0, self.config.anchorCollection.childCount - 1 do
            self.flashSaleDict:Add(i+1, self.config.anchorCollection:GetChild(i));
        end
    end
end

function UIFlashSaleNewView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
    if self.eventTabDict then
        --- @type UIFlashSaleNewPackageTabItem
        for k, v in pairs(self.eventTabDict:GetItems()) do
            ---@type GroupProductConfig
            local groupProductConfig = self:GetGroupProductConfigByID(k)
            if groupProductConfig then
                v:SetText(self:_GetPackageNameLocalizeByID(k))
            end
        end
    end
end

function UIFlashSaleNewView:InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.bgNone.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
end

function UIFlashSaleNewView:OnReadyShow()
    self.model:GetData()
    if self.model.listNewFlashSaleGroup:Count() < 1 then
        self:OnReadyHide()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        return
    end

    self:ResizeTab()

    --- @param v GroupProductConfig
    for k, v in pairs(self.model.listNewFlashSaleGroup:GetItems()) do
        local groupId = v.groupId
        if NotificationCheckUtils.IsNewFlashSaleTabNotification(groupId) == true then
            self:OnSelectTabByType(groupId)
            return
        end
    end
    --- @type GroupProductConfig
    local firstGroup = self.model.listNewFlashSaleGroup:Get(1)
    self:OnSelectTabByType(firstGroup.groupId)
end

function UIFlashSaleNewView:ShowCurrentSale()
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
function UIFlashSaleNewView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, { ["isFromFlashSale"] = true }, self.model.uiName)
end

function UIFlashSaleNewView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIFlashSaleNewView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_info"))
end

function UIFlashSaleNewView:RemoveListener()
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
function UIFlashSaleNewView:OnSelectTabByType(groupID)
    if self.model:IsCurrentTab(groupID) == false then
        self:EnableSelectTabState(self.model.currentTab, false) -- toggle tab selected display
        self:HideLayout()
        self.model:SetTab(groupID)
        self:ShowCurrentSale() -- set hide old layout and show new layout
    end
end

--- @param flashSalePackageType FlashSaleNewPackageType
function UIFlashSaleNewView:GetLayout(flashSalePackageType)
    self:SetFlashSaleDict()
    self.layout = self.layoutDict:Get(flashSalePackageType)
    if self.layout == nil then
        require "lua.client.scene.ui.home.uiFlashSaleNew.UIFlashSaleNewBaseLayout"
        local anchorParent = self.config.anchorCollection:GetChild(flashSalePackageType - 1);
        if (anchorParent == nil) then
            XDebug.Log("flash sale new nil anchor: pack type " .. tostring(flashSalePackageType) .. " total pack count:" .. tostring(self.flashSaleDict:Count()))
        end
        self.layout = UIFlashSaleNewBaseLayout(self, flashSalePackageType, anchorParent)
        self.layoutDict:Add(flashSalePackageType, self.layout)
    end
end

function UIFlashSaleNewView:InitScrollTab()
    --- @param obj UIFlashSaleNewPackageTabItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        local groupProductConfig = self.model.listNewFlashSaleGroup:Get(dataIndex)
        --- @type number
        local groupId = groupProductConfig.groupId
        obj:SetText(UIFlashSaleNewView._GetPackageNameLocalizeByID(groupId))
        obj:SetSelectState(groupId == self.model.currentTab)
        --obj:SetIcon(ResourceLoadUtils.LoadSpriteFromAtlas("IconTabFlashSaleNew", groupId) or ResourceLoadUtils.LoadSpriteFromAtlas("IconTabFlashSaleNew", 1))
        obj:SetIcon(ResourceLoadUtils.LoadSpriteFromAtlas("IconTabFlashSaleNew", 1))
        --- @type ProgressPackCollection
        local progressPackCollection = zg.playerData:GetMethod(PlayerDataMethod.IAP).progressPackData
        local createdTime = progressPackCollection.activeProgressPackDict:Get(groupId)
        ---@type GroupProductConfig
        local groupProductConfig = self:GetGroupProductConfigByID(groupId)
        local endTime = createdTime + groupProductConfig.duration
        obj:SetNotificationFunction(function()
            return NotificationCheckUtils.IsNewFlashSaleTabNotification(groupId)
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
    --- @param obj UIFlashSaleNewPackageTabItem
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        local groupProductConfig = self.model.listNewFlashSaleGroup:Get(dataIndex)
        --- @type number
        local groupId = groupProductConfig.groupId
        obj:SetSelectState(groupId == self.model.currentTab)
    end
    self.scrollLoopTab = UILoopScroll(self.config.scrollTab, UIPoolType.FlashSaleNewPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

function UIFlashSaleNewView:DisableCommon()

end

function UIFlashSaleNewView:HideLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIFlashSaleNewView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideLayout()
    self:DisableCommon()
    if self.scrollLoopTab ~= nil then
        self.scrollLoopTab:Hide()
    end
    self.model.currentTab = -1
end

function UIFlashSaleNewView._GetPackageNameLocalizeByID(id)
    return LanguageUtils.LocalizeCommon("flash_sale_new_" .. tostring(id))
end

function UIFlashSaleNewView:ResizeTab()
    self.scrollLoopTab:Resize(self.model.listNewFlashSaleGroup:Count())
end

function UIFlashSaleNewView:_OnPackageTimeEnded(groupId)
    self:OnReadyShow()
end

function UIFlashSaleNewView:EnableSelectTabState(groupID, isEnabled)
    if groupID == nil then
        return
    end
    --- @type UIFlashSaleNewPackageTabItem
    local eventPackageTabItem = self.eventTabDict:Get(groupID)
    if eventPackageTabItem ~= nil then
        eventPackageTabItem:SetSelectState(isEnabled)
    end
end

--- @param groupId number
function UIFlashSaleNewView:UpdateNotificationByTab(groupId)
    --- @type UIFlashSaleNewPackageTabItem
    local eventPackageTabItem = self.eventTabDict:Get(groupId)
    if eventPackageTabItem then
        eventPackageTabItem:UpdateNotification()
    end
end

function UIFlashSaleNewView:CheckAllNotificationTab()
    --- @param v UIFlashSaleNewPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        v:UpdateNotification()
    end
end