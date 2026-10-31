require "lua.client.scene.ui.home.uiEventAiryuu.layout.UIEventAiryuuLayout"

--- @class UIEventAiryuuView : UIBaseView
UIEventAiryuuView = Class(UIEventAiryuuView, UIBaseView)

--- @param model UIEventAiryuuModel
function UIEventAiryuuView:Ctor(model)
    --- @type UIEventAiryuuConfig
    self.config = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventAiryuuLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventAiryuuModel
    self.eventModel = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_AIRYUU
    --- @type boolean
    self.isReloadingData = nil

    UIBaseView.Ctor(self, model)
    --- @type UIEventAiryuuModel
    self.model = model
end

function UIEventAiryuuView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()
    self:InitUpdateTime()
end

function UIEventAiryuuView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventAiryuuView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("title_event_airyuu")
    if self.layoutDict ~= nil then
        --- @param v UIEventAiryuuLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventAiryuuView:InitEventButtons()
    for airyuuTab = 1, self.model.listSubEvent:Count() do
        local eventButton = self.config.listEventButtons.transform:GetChild(airyuuTab - 1)
        --- @type UIEventSubButtonItem
        local eventSubButtonItem = UIEventSubButtonItem(eventButton)
        eventSubButtonItem:SetConfig(eventButton)

        eventSubButtonItem:SetText(self:_GetEventName(airyuuTab))
        eventSubButtonItem:SetNotificationFunction(function()
            return self:_GetEventNotification(airyuuTab)
        end)
        eventSubButtonItem:AddOnSelectListener(function()
            self:OnClickSelectTab(airyuuTab)
        end)
        self.eventTabDict:Add(airyuuTab, eventSubButtonItem)
    end
end

function UIEventAiryuuView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    if self.layout ~= nil and self.layout.config.gameObject.activeInHierarchy then
        self:HideCurrentLayout()
        return
    end
    self:OnReadyHide()
    --zg.playerData.remoteConfig.showedEvenAiryuuTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
    zg.playerData.remoteConfig.showedEvenAiryuuTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
    zg.playerData:SaveRemoteConfig()
end

function UIEventAiryuuView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

--- @param data {callbackClose : function}
function UIEventAiryuuView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.config.backGroundCover.gameObject:SetActive(false)
    self.isReloadingData = false
    --- @type EventAiryuuModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    --self.model:InitListSubEvent(self.eventModel.timeData)
    self:SetEndEventTime(self:_GetEventEndTime(), function()
        self:_OnEventTimeEnded()
    end)
    self:InitEventButtons()
    if data and data.tab ~= nil then
        self:SelectTab(data.tab)
    end
end

function UIEventAiryuuView:SelectTab(eventAiryuuTab)
    self:CheckAllNotificationTab()
    self:GetLayout(eventAiryuuTab)
    self.layout:OnShow(self)
    self.config.backGroundCover.gameObject:SetActive(true)
end

function UIEventAiryuuView:OnClickSelectTab(eventAiryuuTab)
    self:SelectTab(eventAiryuuTab)
end

--- @param eventAiryuuTab EventAiryuuTab
function UIEventAiryuuView:GetLayout(eventAiryuuTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventAiryuuTab)
    if self.layout == nil then
        if eventAiryuuTab == EventAiryuuTab.CHECK_IN then
            require "lua.client.scene.ui.home.uiEventAiryuu.layout.checkin.UIEventAiryuuCheckinLayout"
            self.layout = UIEventAiryuuCheckinLayout(self, eventAiryuuTab, self.config.checkinAnchor)
        elseif eventAiryuuTab == EventAiryuuTab.HERO_TREASURE then
            require "lua.client.scene.ui.home.uiEventAiryuu.layout.treasure.UIEventAiryuuTreasureLayout"
            self.layout = UIEventAiryuuTreasureLayout(self, eventAiryuuTab, self.config.treasureAnchor)
        elseif eventAiryuuTab == EventAiryuuTab.HERO_QUEST then
            require "lua.client.scene.ui.home.uiEventAiryuu.layout.quest.UIEventAiryuuQuestLayout"
            self.layout = UIEventAiryuuQuestLayout(self, eventAiryuuTab, self.config.questAnchor)
        elseif eventAiryuuTab == EventAiryuuTab.HERO_BUNDLE then
            require "lua.client.scene.ui.home.uiEventAiryuu.layout.bundle.UIEventAiryuuBundleLayout"
            self.layout = UIEventAiryuuBundleLayout(self, eventAiryuuTab, self.config.bundleAnchor)
        elseif eventAiryuuTab == EventAiryuuTab.HERO_EVOLUTION then
            require "lua.client.scene.ui.home.uiEventAiryuu.layout.evolution.UIEventAiryuuEvolutionQuestLayout"
            self.layout = UIEventAiryuuEvolutionQuestLayout(self, eventAiryuuTab, self.config.evolutionAnchor)
        elseif eventAiryuuTab == EventAiryuuTab.HERO_TRIAL then
            require "lua.client.scene.ui.home.uiEventAiryuu.layout.trial.UIEventAiryuuTrialLayout"
            self.layout = UIEventAiryuuTrialLayout(self, eventAiryuuTab, self.config.trialAnchor)
        else
            return nil
        end
        self.layoutDict:Add(eventAiryuuTab, self.layout)
    end
end

function UIEventAiryuuView:DisableCommon()
    self:HideCurrentLayout()
end

function UIEventAiryuuView:OnClickHelpInfo()
     local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("event_airyuu_info"),
             LanguageUtils.LocalizeCommon("airyuu_check_in"),
             LanguageUtils.LocalizeCommon("airyuu_treasure"),
             LanguageUtils.LocalizeCommon("airyuu_quest"),
             LanguageUtils.LocalizeCommon("airyuu_trial"),
             LanguageUtils.LocalizeCommon("airyuu_collection"),
             LanguageUtils.LocalizeCommon("airyuu_bundle"))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param eventAiryuuTab EventAiryuuTab
function UIEventAiryuuView:_GetEventName(eventAiryuuTab)
    if eventAiryuuTab == EventAiryuuTab.CHECK_IN then
        return LanguageUtils.LocalizeCommon("airyuu_check_in")
    elseif eventAiryuuTab == EventAiryuuTab.HERO_TREASURE then
        return LanguageUtils.LocalizeCommon("airyuu_treasure")
    elseif eventAiryuuTab == EventAiryuuTab.HERO_QUEST then
        return LanguageUtils.LocalizeCommon("airyuu_quest")
    elseif eventAiryuuTab == EventAiryuuTab.HERO_BUNDLE then
        return LanguageUtils.LocalizeCommon("airyuu_bundle")
    elseif eventAiryuuTab == EventAiryuuTab.HERO_EVOLUTION then
        return LanguageUtils.LocalizeCommon("airyuu_collection")
    elseif eventAiryuuTab == EventAiryuuTab.HERO_TRIAL then
        return LanguageUtils.LocalizeCommon("airyuu_trial")
    end
end

--- @param eventAiryuuTab EventAiryuuTab
function UIEventAiryuuView:_GetEventNotification(eventAiryuuTab)
    if self.eventModel then
        return self.eventModel:IsTabNotified(eventAiryuuTab)
    else
        return false
    end
end

function UIEventAiryuuView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

--- @param eventAiryuuTab EventAiryuuTab
function UIEventAiryuuView:UpdateNotificationByTab(eventAiryuuTab)
    --- @type UIEventSubButtonItem
    local objTab = self.eventTabDict:Get(eventAiryuuTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventAiryuuView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventAiryuuView:CheckAllNotificationTab()
    --- @param v EventAiryuuTab
    --- @param v UIEventSubButtonItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventAiryuuView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventAiryuuModel
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

function UIEventAiryuuView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:RemoveUpdateTime()
    self:HideCurrentLayout()
end

function UIEventAiryuuView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventAiryuuView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIEventAiryuuView:_GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventAiryuuView:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

function UIEventAiryuuView:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventAiryuuView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventAiryuuView:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventAiryuuView:InitUpdateTime()
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