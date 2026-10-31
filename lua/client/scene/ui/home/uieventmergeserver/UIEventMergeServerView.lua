require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerLayout.UIEventMergeServerLayout"

--- @class UIEventMergeServerView : UIBaseView
UIEventMergeServerView = Class(UIEventMergeServerView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventMergeServerModel
function UIEventMergeServerView:Ctor(model)
    --- @type UIEventMergeServerConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventMergeServerLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventMergeServerModel
    self.eventModel = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_MERGE_SERVER
    --- @type boolean
    self.isReloadingData = nil

    UIBaseView.Ctor(self, model)
    --- @type UIEventMergeServerModel
    self.model = model
end

function UIEventMergeServerView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()
    self:_InitScrollTab()
end

function UIEventMergeServerView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventMergeServerView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventMergeServerLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventMergeServerView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type MergeServerTab
        local mergeServerTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(mergeServerTab))
        obj:SetSelectState(self:_IsTabChosen(mergeServerTab))
        obj:SetIcon(self:_GetEventIcon(mergeServerTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(mergeServerTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(mergeServerTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(mergeServerTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(mergeServerTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type MergeServerTab
        local mergeServerTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(mergeServerTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param mergeServerTab MergeServerTab
function UIEventMergeServerView:_IsTabChosen(mergeServerTab)
    return self.layout ~= nil and self.layout.mergeServerTab == mergeServerTab
end

function UIEventMergeServerView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventMergeServerView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

--- @param data {callbackClose : function}
function UIEventMergeServerView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.isReloadingData = false
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.eventModel:CheckResourceOnSeason()
    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self.model:InitListSubEvent(self.eventModel.timeData)
    if self.isOpen then
        if self.model.listSubEvent:Count() > 0 then
            self:SelectTab(self.model.listSubEvent:Get(1))
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

function UIEventMergeServerView:SelectTab(mergeServerTab)
    self:GetLayout(mergeServerTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventMergeServerView:OnClickSelectTab(mergeServerTab)
    if self:_IsTabChosen(mergeServerTab) then
        return
    end
    self:SelectTab(mergeServerTab)
end

--- @param mergeServerTab MergeServerTab
function UIEventMergeServerView:GetLayout(mergeServerTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(mergeServerTab)
    if self.layout == nil then
        if mergeServerTab == MergeServerTab.CHECK_IN then
            require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerLayout.dailyCheckin.UIEventMergeServerCheckinLayout"
            self.layout = UIEventMergeServerCheckinLayout(self, mergeServerTab, self.config.loginAnchor)
        elseif mergeServerTab == MergeServerTab.QUEST then
            require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerLayout.DailyQuest.UIEventMergeServerDailyQuestLayout"
            self.layout = UIEventMergeServerDailyQuestLayout(self, mergeServerTab, self.config.questAnchor)
        elseif mergeServerTab == MergeServerTab.EXCHANGE then
            require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerLayout.UIEventMergeServerExchangeLayout"
            self.layout = UIEventMergeServerExchangeLayout(self, mergeServerTab, self.config.exchangeAnchor )
        elseif mergeServerTab == MergeServerTab.ACCUMULATION then
            require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerLayout.Accumulation.UIEventMergeServerAccumulationLayout"
            self.layout = UIEventMergeServerAccumulationLayout(self, mergeServerTab, self.config.accumulationAnchor)
        elseif mergeServerTab == MergeServerTab.BUNDLE then
            require "lua.client.scene.ui.home.uiEventMergeServer.UIEventMergeServerLayout.limitedBundle.UIEventMergeServerBundleLayout"
            self.layout = UIEventMergeServerBundleLayout(self, mergeServerTab, self.config.bundleAnchor)
        else
            XDebug.Error("Missing layout type " .. mergeServerTab)
            return nil
        end
        self.layoutDict:Add(mergeServerTab, self.layout)
    end
end

function UIEventMergeServerView:DisableCommon()
    self:HideCurrentLayout()
end

function UIEventMergeServerView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_merge_server_info"))
end

--- @param mergeServerTab MergeServerTab
function UIEventMergeServerView:_GetEventName(mergeServerTab)
    if mergeServerTab == MergeServerTab.CHECK_IN then
        return LanguageUtils.LocalizeCommon("merge_server_check_in")
    elseif mergeServerTab == MergeServerTab.QUEST then
        return LanguageUtils.LocalizeCommon("merge_server_quest")
    elseif mergeServerTab == MergeServerTab.EXCHANGE then
        return LanguageUtils.LocalizeCommon("merge_server_exchange")
    elseif mergeServerTab == MergeServerTab.BUNDLE then
        return LanguageUtils.LocalizeCommon("merge_server_bundle")
    elseif mergeServerTab == MergeServerTab.ACCUMULATION then
        return LanguageUtils.LocalizeCommon("merge_server_accumulation")
    else
        return LanguageUtils.LocalizeCommon("merge_server_check_in")
    end
end

--- @param mergeServerTab MergeServerTab
function UIEventMergeServerView:_GetEventIcon(mergeServerTab)
    return ResourceLoadUtils.LoadEventMergeServerIcon(mergeServerTab)
end

--- @param mergeServerTab MergeServerTab
function UIEventMergeServerView:_GetEventNotification(mergeServerTab)
    return self.eventModel:IsTabNotified(mergeServerTab)
end

function UIEventMergeServerView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

--- @param mergeServerTab MergeServerTab
function UIEventMergeServerView:UpdateNotificationByTab(mergeServerTab)
    if mergeServerTab == MergeServerTab.ACCUMULATION then
         self.eventModel:UpdateAccumulationProgress()
    end
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(mergeServerTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventMergeServerView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventMergeServerView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventMergeServerView:CheckAllNotificationTab()
    --- @param v MergeServerTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIEventMergeServerView:_GetEventEndTime(mergeServerTab)
    return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventMergeServerView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventMergeServerModel
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

function UIEventMergeServerView:Hide()
    UIBaseView.Hide(self)

    self:RemoveListener()

    self:HideCurrentLayout()

    self:HideScrollTab()
end

function UIEventMergeServerView:HideScrollTab()
    self.scrollLoopTab:Hide()
    self.eventTabDict:Clear()
end

function UIEventMergeServerView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventMergeServerView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end
