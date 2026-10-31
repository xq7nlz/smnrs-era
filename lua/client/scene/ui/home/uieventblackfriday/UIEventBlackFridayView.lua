require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.UIEventBlackFridayLayout"
require "lua.client.core.network.event.eventBlackFridayModel.EventBlackFridayModel"

--- @class UIEventBlackFridayView : UIBaseView
UIEventBlackFridayView = Class(UIEventBlackFridayView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventBlackFridayModel
function UIEventBlackFridayView:Ctor(model)
    --- @type UIBlackFridayConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventBlackFridayLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()
    --- @type EventBlackFridayModel
    self.eventBlackFridayModel = nil
    --- @type UIEventBlackFridayModel
    self.model = model
    --- @type string
    self.uiName = model.uiName

    --- @type boolean
    self.isReloadingData = nil
    --- @type List
    self.listSubEvent = List()
    UIBaseView.Ctor(self, model)
    self:InitListSubEvent()
end

function UIEventBlackFridayView:InitListSubEvent()
    self.listSubEvent = List()
    self.listSubEvent:Add(BlackFridayTab.CARD)
    self.listSubEvent:Add(BlackFridayTab.GEM_BOX)
    self.listSubEvent:Add(BlackFridayTab.DAILY_CHECK_IN)
    self.listSubEvent:Add(BlackFridayTab.BUNDLE)
end


function UIEventBlackFridayView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventBlackFridayView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventBlackFridayLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventBlackFridayView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    --self.config.tapToClose.onClick:AddListener(function()
    --    self:OnClickBackOrClose()
    --end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventBlackFridayView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnReadyHide()
    --zg.playerData.remoteConfig.showedEvenBlackFridayTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
    zg.playerData.remoteConfig.showedEvenBlackFridayTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
    zg.playerData:SaveRemoteConfig()
end

function UIEventBlackFridayView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type BlackFridayTab
        local blackFridayTab = self.listSubEvent:Get(dataIndex)
        --print("black tab " .. tostring(blackFridayTab) .. tostring(self:_IsTabChosen(blackFridayTab)))

        obj:SetText(self:_GetEventName(blackFridayTab))
        obj:SetSelectState(self:_IsTabChosen(blackFridayTab))
        obj:SetIcon(self:_GetEventIcon(blackFridayTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(blackFridayTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(blackFridayTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(blackFridayTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(blackFridayTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type BlackFridayTab
        local blackFridayTab = self.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(blackFridayTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param blackFridayTab BlackFridayTab
function UIEventBlackFridayView:_IsTabChosen(blackFridayTab)
    return self.layout ~= nil and self.layout.blackFridayTab == blackFridayTab
end

function UIEventBlackFridayView:OnReadyShow()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.eventBlackFridayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    self.isReloadingData = false
    local isOpen = self.eventBlackFridayModel:IsOpening()
    if isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self:CheckEndSeasonDisplay()

    if self.listSubEvent:Count() > 0 then
        self:SelectTab(self.listSubEvent:Get(BlackFridayTab.CARD))
        self.scrollLoopTab:Resize(self.listSubEvent:Count())
        self:CheckAllNotificationTab()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
    end
end

function UIEventBlackFridayView:CheckEndSeasonDisplay()
    local event = self.eventBlackFridayModel
    self.config.VerticalScrollTab.gameObject:SetActive(event:IsOpening())
end

function UIEventBlackFridayView:SelectTab(blackFridayTab)
    self:GetLayout(blackFridayTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventBlackFridayView:OnClickSelectTab(blackFridayTab)
    if self:_IsTabChosen(blackFridayTab) then
        return
    end
    self:SelectTab(blackFridayTab)
end

--- @param blackFridayTab BlackFridayTab
function UIEventBlackFridayView:GetLayout(blackFridayTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(blackFridayTab)
    if self.layout == nil then
        if blackFridayTab == BlackFridayTab.CARD then
            require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.EventCard.UICardLayout"
            self.layout = UICardLayout(self, blackFridayTab, self.config.cardAnchor)
        elseif blackFridayTab == BlackFridayTab.GEM_BOX then
            require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.EventGemPack.UIGemPackLayout"
            self.layout = UIGemPackLayout(self, blackFridayTab, self.config.gemPackAnchor)
        elseif blackFridayTab == BlackFridayTab.DAILY_CHECK_IN then
            require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.EventDailyCheckin.UIBlackFridayCheckinLayout"
            self.layout = UIBlackFridayCheckinLayout(self, blackFridayTab, self.config.dailyAnchor)
        elseif blackFridayTab == BlackFridayTab.BUNDLE then
            require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.Bundle.UIBlackFridayBundle2Layout"
           self.layout = UIBlackFridayBundle2Layout(self, blackFridayTab, self.config.bundleAnchor)
        else
            XDebug.Error("Missing layout type " .. blackFridayTab)
            return nil
        end
        self.layoutDict:Add(blackFridayTab, self.layout)
    end
end

function UIEventBlackFridayView:DisableCommon()
    self:HideCurrentLayout()
    self.config.gemPackAnchor.gameObject:SetActive(false)
    self.config.cardAnchor.gameObject:SetActive(false)
    self.config.dailyAnchor.gameObject:SetActive(false)
    self.config.bundleAnchor.gameObject:SetActive(false)
end

function UIEventBlackFridayView:OnClickHelpInfo()
    local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("event_black_friday_info"),
            LanguageUtils.LocalizeCommon("event_daily_black_friday"),
            LanguageUtils.LocalizeCommon("event_card_black_friday"),
            LanguageUtils.LocalizeCommon("event_card_gem_pack"),
            LanguageUtils.LocalizeCommon("event_black_friday_bundle_pack"),
            LanguageUtils.LocalizeCommon("black_friday_gem_pack_desc")
    )
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param blackFridayTab BlackFridayTab
function UIEventBlackFridayView:_GetEventName(blackFridayTab)
    if blackFridayTab == BlackFridayTab.CARD then
        return LanguageUtils.LocalizeCommon("event_card_black_friday")
    elseif blackFridayTab == BlackFridayTab.GEM_BOX then
        return LanguageUtils.LocalizeCommon("event_card_gem_pack")
    elseif blackFridayTab == BlackFridayTab.DAILY_CHECK_IN then
        return LanguageUtils.LocalizeCommon("event_new_server_week_login")
    elseif blackFridayTab == BlackFridayTab.BUNDLE then
        return LanguageUtils.LocalizeCommon("event_black_friday_bundle_pack")
    else
        return LanguageUtils.LocalizeCommon("event_card_gem_pack")
    end
end

--- @param blackFridayTab BlackFridayTab
function UIEventBlackFridayView:_GetEventIcon(blackFridayTab)
    return ResourceLoadUtils.LoadEventBlackFriday(blackFridayTab)
end

--- @param blackFridayTab BlackFridayTab
function UIEventBlackFridayView:_GetEventNotification(blackFridayTab)
    return self.eventBlackFridayModel:IsTabNotified(blackFridayTab)
end

function UIEventBlackFridayView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventBlackFridayModel:GetType(), ["isAdded"] = false })
end

--- @param blackFridayTab BlackFridayTab
function UIEventBlackFridayView:UpdateNotificationByTab(blackFridayTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(blackFridayTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventBlackFridayView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.uiName)
end

function UIEventBlackFridayView:CheckAllNotificationTab()
    --- @param v BlackFridayTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIEventBlackFridayView:_GetEventEndTime(blackFridayTab)
    if blackFridayTab == BlackFridayTab.SPECIAL_OFFER then
        return self.eventBlackFridayModel.timeData.endTime - TimeUtils.SecondAMin * 10
    end
    return self.eventBlackFridayModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventBlackFridayView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventBlackFridayModel
            local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow()
            else
                zg.playerData.remoteConfig.lastTimeDurationBlackFriday = nil
                zg.playerData:SaveRemoteConfig()
                if PopupUtils.IsPopupShowing(UIPopupName.UIEventBlackFriday) == false then
                    return
                end
                PopupMgr.HidePopup(UIPopupName.UIEventBlackFriday)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

function UIEventBlackFridayView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideCurrentLayout()
end

function UIEventBlackFridayView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventBlackFridayView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end