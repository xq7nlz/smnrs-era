require "lua.client.scene.ui.home.uiEventTowerOfEitri.layout.UIEventTowerOfEitriLayout"

--- @class UIEventTowerOfEitriView : UIBaseView
UIEventTowerOfEitriView = Class(UIEventTowerOfEitriView, UIBaseView)

function UIEventTowerOfEitriView:Ctor(model)
    --- @type UIEventTowerOfEitriConfig
    self.config = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventTowerOfEitriLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()
    --- @type EventTowerOfEitriModel
    self.eventModel = nil
    ---@type EventTowerOfEitriConfig
    self.eventConfig = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_TOWER_OF_EITRI
    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventTowerOfEitriModel
    self.model = model
end

function UIEventTowerOfEitriView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    --self.config.textCurrentFloor.gameObject:SetActive(false)
    self:InitButtons()
    self:InitUpdateTime()
end

function UIEventTowerOfEitriView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventTowerOfEitriView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("event_tower_of_eitri")
    if self.layoutDict ~= nil then
        --- @param v UIEventAiryuuLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventTowerOfEitriView:InitEventButtons()
    for eventTowerOfEitriTab = 1, self.model.listSubEvent:Count() do
        local eventButton = self.config.listEventButtons.transform:GetChild(eventTowerOfEitriTab - 1)
        --- @type UIEventSubButtonItem
        local eventSubButtonItem = UIEventSubButtonItem(eventButton)
        eventSubButtonItem:SetConfig(eventButton)
        eventSubButtonItem:SetText(self:_GetEventName(eventTowerOfEitriTab))
        eventSubButtonItem:SetNotificationFunction(function()
            return self:_GetEventNotification(eventTowerOfEitriTab)
        end)
        eventSubButtonItem:AddOnSelectListener(function()
            self:OnClickSelectTab(eventTowerOfEitriTab)
        end)
        self.eventTabDict:Add(eventTowerOfEitriTab, eventSubButtonItem)
    end
end

function UIEventTowerOfEitriView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    if self.layout ~= nil and self.layout.config.gameObject.activeInHierarchy then
        self:HideCurrentLayout()
        return
    end
    self:OnReadyHide()
    zg.playerData:SaveRemoteConfig()
end

function UIEventTowerOfEitriView:SetCurrentFloor(number)
    if not number then
        number = self.eventModel:GetTowerCurrentFloor()
    end
    self.config.textCurrentFloor.text = string.format("%s: %s",
            UIUtils.SetColorString(UIUtils.yellow1,
                    LanguageUtils.LocalizeCommon("current_floor")),
            UIUtils.SetColorString(UIUtils.color6, number))
end

--- @param data {callbackClose : function}
function UIEventTowerOfEitriView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.config.backGroundCover.enabled = false
    self.isReloadingData = false
    --- @type EventTowerOfEitriModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.eventConfig = self.eventModel.config
    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self:SetEndEventTime(self:_GetEventEndTime(), function()
        self:_OnEventTimeEnded()
    end)
    self:InitEventButtons()
    self:SetCurrentFloor()
    if data and data.tab ~= nil then
        self:SelectTab(data.tab)
    end
end

function UIEventTowerOfEitriView:SelectTab(eventTowerOfEitriTab)
    self:CheckAllNotificationTab()
    self:GetLayout(eventTowerOfEitriTab)
    self.layout:OnShow(self)
    self.config.backGroundCover.enabled = true
end

function UIEventTowerOfEitriView:OnClickSelectTab(eventTowerOfEitriTab)
    self:SelectTab(eventTowerOfEitriTab)
end

--- @param eventTowerOfEitriTab EventTowerOfEitriTab
function UIEventTowerOfEitriView:GetLayout(eventTowerOfEitriTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventTowerOfEitriTab)
    if self.layout == nil then
        local transform = self.config.listEventAnchor.transform:GetChild(eventTowerOfEitriTab)
        if transform then
            if eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_BUILD then
                require "lua.client.scene.ui.home.uiEventTowerOfEitri.layout.tower.UIEventTowerOfEitriTowerLayout"
                self.layout = UIEventTowerOfEitriTowerLayout(self, eventTowerOfEitriTab, transform)
            elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_EXCHANGE then
                require "lua.client.scene.ui.home.uiEventTowerOfEitri.layout.exchange.UIEventTowerOfEitriExchangeLayout"
                self.layout = UIEventTowerOfEitriExchangeLayout(self, eventTowerOfEitriTab, transform)
            elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_BUNDLE then
                require "lua.client.scene.ui.home.uiEventTowerOfEitri.layout.bundle.UIEventTowerOfEitriBundleLayout"
                self.layout = UIEventTowerOfEitriBundleLayout(self, eventTowerOfEitriTab, transform)
            elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_QUEST then
                require "lua.client.scene.ui.home.uiEventTowerOfEitri.layout.quest.UIEventTowerOfEitriQuestLayout"
                self.layout = UIEventTowerOfEitriQuestLayout(self, eventTowerOfEitriTab, transform)
            else
                return nil
            end
        else
            return nil
        end
        self.layoutDict:Add(eventTowerOfEitriTab, self.layout)
    end
end

function UIEventTowerOfEitriView:DisableCommon()
    self:HideCurrentLayout()
end

function UIEventTowerOfEitriView:OnClickHelpInfo()
    ---@type EventTimeData
    local timeData = self.eventModel.timeData
    local dayStart = TimeUtils.GetDateMonthYearFromTimestamp(timeData.startTime)
    local dayEnd = TimeUtils.GetDateMonthYearFromTimestamp(timeData.endTime)
    local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("event_tower_of_eitri_info", dayStart, dayEnd),
            LanguageUtils.LocalizeCommon("tower_of_eitri_tower"),
            LanguageUtils.LocalizeCommon("tower_of_eitri_exchange"),
            LanguageUtils.LocalizeCommon("tower_of_eitri_bundle"),
            LanguageUtils.LocalizeCommon("tower_of_eitri_quest"))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param eventTowerOfEitriTab EventTowerOfEitriTab
function UIEventTowerOfEitriView:_GetEventName(eventTowerOfEitriTab)
    if eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_BUILD then
        return LanguageUtils.LocalizeCommon("tower_of_eitri_tower")
    elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_EXCHANGE then
        return LanguageUtils.LocalizeCommon("tower_of_eitri_exchange")
    elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_BUNDLE then
        return LanguageUtils.LocalizeCommon("tower_of_eitri_bundle")
    elseif eventTowerOfEitriTab == EventTowerOfEitriTab.TOWER_QUEST then
        return LanguageUtils.LocalizeCommon("tower_of_eitri_quest")
    end
end

--- @param eventTowerOfEitriTab EventTowerOfEitriTab
function UIEventTowerOfEitriView:_GetEventNotification(eventTowerOfEitriTab)
    if self.eventModel then
        return self.eventModel:IsTabNotified(eventTowerOfEitriTab)
    else
        return false
    end
end

function UIEventTowerOfEitriView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

--- @param eventTowerOfEitriTab EventTowerOfEitriTab
function UIEventTowerOfEitriView:UpdateNotificationByTab(eventTowerOfEitriTab)
    --- @type UIEventSubButtonItem
    local objTab = self.eventTabDict:Get(eventTowerOfEitriTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventTowerOfEitriView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventTowerOfEitriView:CheckAllNotificationTab()
    --- @param v EventTowerOfEitriTab
    --- @param v UIEventSubButtonItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventTowerOfEitriView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventTowerOfEitriModel
            local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow(data)
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

function UIEventTowerOfEitriView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:RemoveUpdateTime()
    self:HideCurrentLayout()
end

function UIEventTowerOfEitriView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventTowerOfEitriView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIEventTowerOfEitriView:_GetEventEndTime()
    if self.eventModel then
        return self.eventModel.timeData.endTime
    end
    return 0
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventTowerOfEitriView:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

function UIEventTowerOfEitriView:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventTowerOfEitriView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventTowerOfEitriView:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventTowerOfEitriView:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end