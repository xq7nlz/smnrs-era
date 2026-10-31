--- @class UIEventBirthdayView : UIBaseView
UIEventBirthdayView = Class(UIEventBirthdayView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventBirthdayModel
function UIEventBirthdayView:Ctor(model)
    --- @type UIEventBirthdayConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventBirthdayLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventBirthdayModel
    self.eventModel = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    --- @type boolean
    self.isReloadingData = nil

    UIBaseView.Ctor(self, model)
    --- @type UIEventBirthdayModel
    self.model = model

    self.dictDarkLightLayout = Dictionary()
end

function UIEventBirthdayView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()
    self:_InitScrollTab()
end

function UIEventBirthdayView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventBirthdayView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventBirthdayLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventBirthdayView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type EventBirthdayTab
        local birthdayTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(birthdayTab))
        obj:SetSelectState(self:_IsTabChosen(birthdayTab))
        obj:SetIcon(self:_GetEventIcon(birthdayTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(birthdayTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(birthdayTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(birthdayTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(birthdayTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type EventBirthdayTab
        local birthdayTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(birthdayTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param eventBirthdayTab EventBirthdayTab
function UIEventBirthdayView:_IsTabChosen(eventBirthdayTab)
    return self.layout ~= nil and self.layout.eventBirthdayTab == eventBirthdayTab
end

function UIEventBirthdayView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
    --zg.playerData.remoteConfig.showedEvenBirthdayTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
    zg.playerData.remoteConfig.showedEvenBirthdayTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
    zg.playerData:SaveRemoteConfig()
end

function UIEventBirthdayView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

--- @param data {callbackClose : function}
function UIEventBirthdayView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.isReloadingData = false
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self.model:InitListSubEvent(self.eventModel.timeData)
    if self.isOpen then
        if self.model.listSubEvent:Count() > 0 then
            if data ~= nil then
                if data.tab ~= nil then
                    self:SelectTab(data.tab)
                else
                    self:SelectTab(self.model.listSubEvent:Get(1))
                end
            else
                self:SelectTab(self.model.listSubEvent:Get(1))
            end
            self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
            self:CheckAllNotificationTab()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            self:OnReadyHide()
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
    end


end

function UIEventBirthdayView:SelectTab(eventBirthdayTab)
    self:CheckAllNotificationTab()
    self:GetLayout(eventBirthdayTab)
    self:GetDynamicLayout(eventBirthdayTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventBirthdayView:OnClickSelectTab(eventBirthdayTab)
    if self:_IsTabChosen(eventBirthdayTab) then
        return
    end
    self:SelectTab(eventBirthdayTab)
end

--- @param eventBirthdayTab EventBirthdayTab
function UIEventBirthdayView:GetLayout(eventBirthdayTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventBirthdayTab)
    if self.layout == nil then
        if eventBirthdayTab == EventBirthdayTab.CHECK_IN then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.dailyCheckin.UIEventBirthdayCheckInLayout"
            self.layout = UIEventBirthdayCheckInLayout(self, eventBirthdayTab, self.config.loginAnchor)
        elseif eventBirthdayTab == EventBirthdayTab.BUNDLE then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.bundle.UIEventBirthdayMultiBundleLayout"
            self.layout = UIEventBirthdayMultiBundleLayout(self, eventBirthdayTab, self.config.bundleAnchor)
        elseif eventBirthdayTab == EventBirthdayTab.EXCLUSIVE_BUNDLE then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.exclusiveBundle.UIEventBirthdayExclusiveBundleLayout"
            self.layout = UIEventBirthdayExclusiveBundleLayout(self, eventBirthdayTab, self.config.exclusiveBundleAnchor)
        elseif eventBirthdayTab == EventBirthdayTab.LEGACY_PATH then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.legacy.UIEventBirthdayLegacyPathLayout"
            self.layout = UIEventBirthdayLegacyPathLayout(self, eventBirthdayTab, self.config.wheelAnchor, 1)
        elseif eventBirthdayTab == EventBirthdayTab.BOSS then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.BirthdayBoss.UIBirthdayBossLayout"
            self.layout = UIBirthdayBossLayout(self, eventBirthdayTab, self.config.bossAnchor)
        else
            if eventBirthdayTab ~= EventBirthdayTab.DARK_LIGHT then
                XDebug.Error("Missing layout type " .. eventBirthdayTab)
            end
            return nil
        end
        self.layoutDict:Add(eventBirthdayTab, self.layout)
    end
end

--- @param eventBirthdayTab EventBirthdayTab
function UIEventBirthdayView:GetDynamicLayout(eventBirthdayTab)
    if eventBirthdayTab == EventBirthdayTab.DARK_LIGHT then
        self:DisableCommon()
        if self.eventModel.selectSideId == -1 then
            self.layout = self:GetDarkLightLayout(DarkLightLayout.SELECT_SIDE)
        else
            self.layout = self:GetDarkLightLayout(DarkLightLayout.VERSUS)
        end
        self.layoutDict:Add(eventBirthdayTab, self.layout)
    end
end

--- @param darkLightLayout DarkLightLayout
function UIEventBirthdayView:GetDarkLightLayout(darkLightLayout)
    local layout = self.dictDarkLightLayout:Get(darkLightLayout)
    if layout == nil then
        if darkLightLayout == DarkLightLayout.SELECT_SIDE then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.darklight.UIEventBirthdayDarkLightSelectSideLayout"
            self.dictDarkLightLayout:Add(DarkLightLayout.SELECT_SIDE, UIEventBirthdayDarkLightSelectSideLayout(self, EventBirthdayTab.DARK_LIGHT, self.config.darkLightAnchor))
        elseif darkLightLayout == DarkLightLayout.VERSUS then
            require "lua.client.scene.ui.home.uiEventBirthday.layout.darklight.UIEventBirthdayDarkLightVersusLayout"
            self.dictDarkLightLayout:Add(DarkLightLayout.VERSUS, UIEventBirthdayDarkLightVersusLayout(self, EventBirthdayTab.DARK_LIGHT, self.config.darkLightVersusAnchor))
        end
        layout = self.dictDarkLightLayout:Get(darkLightLayout)
    end
    return layout
end

function UIEventBirthdayView:DisableCommon()
    self:HideCurrentLayout()
end

function UIEventBirthdayView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_2nd_birthday_info"))
end

--- @param eventBirthdayTab EventBirthdayTab
function UIEventBirthdayView:_GetEventName(eventBirthdayTab)
    if eventBirthdayTab == EventBirthdayTab.CHECK_IN then
        return LanguageUtils.LocalizeCommon("birthday_check_in")
    elseif eventBirthdayTab == EventBirthdayTab.DARK_LIGHT then
        return LanguageUtils.LocalizeCommon("dark_vs_light")
    elseif eventBirthdayTab == EventBirthdayTab.BUNDLE then
        return LanguageUtils.LocalizeCommon("birthday_bundle")
    elseif eventBirthdayTab == EventBirthdayTab.EXCLUSIVE_BUNDLE then
        return LanguageUtils.LocalizeCommon("birthday_exclusive_bundle")
    elseif eventBirthdayTab == EventBirthdayTab.LEGACY_PATH then
        return LanguageUtils.LocalizeCommon("birthday_legacy_path")
    elseif eventBirthdayTab == EventBirthdayTab.BOSS then
        return LanguageUtils.LocalizeCommon("birthday_boss")
    end
end

--- @param eventBirthdayTab EventBirthdayTab
function UIEventBirthdayView:_GetEventIcon(eventBirthdayTab)
    return ResourceLoadUtils.LoadEventBirthdayIcon(eventBirthdayTab)
end

--- @param eventBirthdayTab EventBirthdayTab
function UIEventBirthdayView:_GetEventNotification(eventBirthdayTab)
    return self.eventModel:IsTabNotified(eventBirthdayTab)
end

function UIEventBirthdayView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

--- @param eventBirthdayTab EventBirthdayTab
function UIEventBirthdayView:UpdateNotificationByTab(eventBirthdayTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(eventBirthdayTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventBirthdayView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventBirthdayView:CheckAllNotificationTab()
    --- @param v EventBirthdayTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIEventBirthdayView:_GetEventEndTime(eventBirthdayTab)
    return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventBirthdayView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventBirthdayModel
            local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow()
            else
                if PopupUtils.IsPopupShowing(self.model.uiName) == false then
                    return
                end
                PopupMgr.HidePopup(self.model.uiName)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

function UIEventBirthdayView:Hide()
    UIBaseView.Hide(self)

    self:RemoveListener()

    self:HideCurrentLayout()

    self:HideScrollTab()
end

function UIEventBirthdayView:HideScrollTab()
    self.scrollLoopTab:Hide()
    self.eventTabDict:Clear()
end

function UIEventBirthdayView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventBirthdayView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end