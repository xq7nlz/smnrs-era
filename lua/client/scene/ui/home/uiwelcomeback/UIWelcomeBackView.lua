require "lua.client.scene.ui.home.uiWelcomeBack.UIWelcomeBackLayout"

--- @class UIWelcomeBackView : UIBaseView
UIWelcomeBackView = Class(UIWelcomeBackView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIWelcomeBackModel
function UIWelcomeBackView:Ctor(model)
    --- @type UIWelcomeBackConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIWelcomeBackLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()
    --- @type WelcomeBackInBound
    self.welcomeBackInBound = nil
    UIBaseView.Ctor(self, model)
    --- @type UIWelcomeBackModel
    self.model = model
end

function UIWelcomeBackView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    self:_InitScrollTab()
end

function UIWelcomeBackView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

function UIWelcomeBackView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type WelcomeBackTab
        local welcomeBackTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(welcomeBackTab))
        obj:SetSelectState(self:_IsTabChosen(welcomeBackTab))
        obj:SetIcon(self:_GetEventIcon(welcomeBackTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(welcomeBackTab)
        end)
        obj:SetEndEventTime(self.welcomeBackInBound.endTime, function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(welcomeBackTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(welcomeBackTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type WelcomeBackTab
        local welcomeBackTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(welcomeBackTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

function UIWelcomeBackView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIWelcomeBackView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIWelcomeBackView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_easter_egg"))
end

function UIWelcomeBackView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIWelcomeBackLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

--- @param welcomeBackTab WelcomeBackTab
function UIWelcomeBackView:_IsTabChosen(welcomeBackTab)
    return self.layout ~= nil and self.layout.welcomeBackTab == welcomeBackTab
end

--- @param data {callbackClose : function}
function UIWelcomeBackView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.isReloadingData = false
    self.welcomeBackInBound = zg.playerData:GetMethod(PlayerDataMethod.COMEBACK)

    self.model:InitListSubEvent()

    if self.welcomeBackInBound.isInComingBackEvent == true then
        if self.model.listSubEvent:Count() > 0 then
            self:SelectTab(self.model.listSubEvent:Get(1))
            self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
            self:CheckAllNotificationTab()
        else
            self:_OnEventTimeEnded()
        end
    else
        self:_OnEventTimeEnded()
    end
end

function UIWelcomeBackView:SelectTab(welcomeBackTab)
    self:GetLayout(welcomeBackTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIWelcomeBackView:OnClickSelectTab(welcomeBackTab)
    if self:_IsTabChosen(welcomeBackTab) then
        return
    end
    self:SelectTab(welcomeBackTab)
end

--- @param welcomeBackTab WelcomeBackTab
function UIWelcomeBackView:GetLayout(welcomeBackTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(welcomeBackTab)
    if self.layout == nil then
        if welcomeBackTab == WelcomeBackTab.LOGIN then
            require "lua.client.scene.ui.home.uiWelcomeBack.WelcomeBackLoginLayout.WelcomeBackLoginLayout"
            self.layout = WelcomeBackLoginLayout(self, welcomeBackTab, self.config.loginAnchor)
        elseif welcomeBackTab == WelcomeBackTab.QUEST then
            require "lua.client.scene.ui.home.uiWelcomeBack.WelcomeBackQuestLayout.UIWelcomeBackQuestLayout"
            self.layout = UIWelcomeBackQuestLayout(self, welcomeBackTab, self.config.questAnchor)
        elseif welcomeBackTab == WelcomeBackTab.BUNDLE then
            require "lua.client.scene.ui.home.uiWelcomeBack.WelcomeBackBundleLayout.UIWelcomeBackBundleLayout"
            self.layout = UIWelcomeBackBundleLayout(self, welcomeBackTab, self.config.bundleAnchor)
        else
            XDebug.Error("Missing layout type " .. welcomeBackTab)
            return nil
        end
        self.layoutDict:Add(welcomeBackTab, self.layout)
    end
end

function UIWelcomeBackView:DisableCommon()
    self:HideCurrentLayout()
end

function UIWelcomeBackView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("welcome_back_info"))
end

--- @param welcomeBackTab WelcomeBackTab
function UIWelcomeBackView:_GetEventName(welcomeBackTab)
    if welcomeBackTab == WelcomeBackTab.LOGIN then
        return LanguageUtils.LocalizeCommon("welcome_back_login")
    elseif welcomeBackTab == WelcomeBackTab.QUEST then
        return LanguageUtils.LocalizeCommon("welcome_back_quest")
    elseif welcomeBackTab == WelcomeBackTab.BUNDLE then
        return LanguageUtils.LocalizeCommon("welcome_back_bundle")
    else
        return LanguageUtils.LocalizeCommon("welcome_back_login")
    end
end

--- @param welcomeBackTab WelcomeBackTab
function UIWelcomeBackView:_GetEventIcon(welcomeBackTab)
    return ResourceLoadUtils.LoadWelcomeBackIcon(welcomeBackTab)
end

--- @param welcomeBackTab WelcomeBackTab
function UIWelcomeBackView:_GetEventNotification(welcomeBackTab)
    return self.welcomeBackInBound:IsTabNotified(welcomeBackTab)
end

function UIWelcomeBackView:_OnEventTimeEnded()
    SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
    self:OnReadyHide()
end

--- @param welcomeBackTab WelcomeBackTab
function UIWelcomeBackView:UpdateNotificationByTab(welcomeBackTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(welcomeBackTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIWelcomeBackView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIWelcomeBackView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIWelcomeBackView:CheckAllNotificationTab()
    --- @param v WelcomeBackTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIWelcomeBackView:Hide()
    UIBaseView.Hide(self)

    self:HideCurrentLayout()

    self:HideScrollTab()
end

function UIWelcomeBackView:HideScrollTab()
    self.scrollLoopTab:Hide()
    self.eventTabDict:Clear()
end

function UIWelcomeBackView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end