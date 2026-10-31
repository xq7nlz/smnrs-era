require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.UIEventMidAutumnLayout"

--- @class UIEventMidAutumnView : UIBaseView
UIEventMidAutumnView = Class(UIEventMidAutumnView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventMidAutumnModel
function UIEventMidAutumnView:Ctor(model)
    --- @type UIEventMidAutumnConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventMidAutumnLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventMidAutumnModel
    self.eventMidAutumnModel = nil

    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventMidAutumnModel
    self.model = model
end

function UIEventMidAutumnView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventMidAutumnView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventMidAutumnLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventMidAutumnView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventMidAutumnView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type MidAutumnTab
        local midAutumnTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(midAutumnTab))
        obj:SetSelectState(self:_IsTabChosen(midAutumnTab))
        obj:SetIcon(self:_GetEventIcon(midAutumnTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(midAutumnTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(midAutumnTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(midAutumnTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(midAutumnTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type MidAutumnTab
        local midAutumnTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(midAutumnTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param midAutumnTab MidAutumnTab
function UIEventMidAutumnView:_IsTabChosen(midAutumnTab)
    return self.layout ~= nil and self.layout.midAutumnTab == midAutumnTab
end

function UIEventMidAutumnView:OnReadyShow()
    self.isReloadingData = false
    self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    self.eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    self.model:InitListSubEvent(self.eventMidAutumnModel.timeData)
    if self.model.listSubEvent:Count() > 0 then
        self:SelectTab(self.model.listSubEvent:Get(1))
        self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
        self:CheckAllNotificationTab()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
    end
end

function UIEventMidAutumnView:SelectTab(midAutumnTab)
    self:GetLayout(midAutumnTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventMidAutumnView:OnClickSelectTab(midAutumnTab)
    if self:_IsTabChosen(midAutumnTab) then
        return
    end
    self:SelectTab(midAutumnTab)
end

--- @param midAutumnTab MidAutumnTab
function UIEventMidAutumnView:GetLayout(midAutumnTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(midAutumnTab)
    if self.layout == nil then
        if midAutumnTab == MidAutumnTab.ARENA then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.midAutumnArena.UIMidAutumnArenaLayout"
            self.layout = UIMidAutumnArenaLayout(self, midAutumnTab, self.config.midAutumnArena)
        elseif midAutumnTab == MidAutumnTab.GOLDEN_TIME then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.UIEventGoldenTimeLayout"
            self.layout = UIEventGoldenTimeLayout(self, midAutumnTab, self.config.goldenTimeAnchor)
        elseif midAutumnTab == MidAutumnTab.FEED_BEAST then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.feedTheBeast.UIEventFeedBeastLayout"
            self.layout = UIEventFeedBeastLayout(self, midAutumnTab, self.config.feedBeastAnchor)
        elseif midAutumnTab == MidAutumnTab.EXCHANGE then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.exchange.UIEventExchangeMidAutumnLayout"
            self.layout = UIEventExchangeMidAutumnLayout(self, midAutumnTab, self.config.exchangeAnchor)
        elseif midAutumnTab == MidAutumnTab.SPECIAL_OFFER then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.specialOffer.UIEventSpecialOfferMidAutumnLayout"
            self.layout = UIEventSpecialOfferMidAutumnLayout(self, midAutumnTab, self.config.specialOfferAnchor)
        elseif midAutumnTab == MidAutumnTab.GEM_BOX then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.gemBox.UIEventGemBoxMidAutumnLayout"
            self.layout = UIEventGemBoxMidAutumnLayout(self, midAutumnTab, self.config.gemBoxAnchor)
        elseif midAutumnTab == MidAutumnTab.DAILY_CHECK_IN then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.UIEventDailyLoginMidAutumnLayout"
            self.layout = UIEventDailyLoginMidAutumnLayout(self, midAutumnTab, self.config.dailyCheckInAnchor)
        elseif midAutumnTab == MidAutumnTab.FESTIVAL_MARKET then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.festivalMarket.UIMidAutumnMarketLayout"
            self.layout = UIMidAutumnMarketLayout(self, midAutumnTab, self.config.festivalMarketAnchor)
        elseif midAutumnTab == MidAutumnTab.QUEST then
            require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.quest.UIMidAutumnQuestLayout"
            self.layout = UIMidAutumnQuestLayout(self, midAutumnTab, self.config.festivalQuestAnchor)

        else
            XDebug.Error("Missing layout type " .. midAutumnTab)
            return nil
        end
        self.layoutDict:Add(midAutumnTab, self.layout)
    end
end

function UIEventMidAutumnView:DisableCommon()
    self:HideCurrentLayout()
    self.config.goldenTimeAnchor.gameObject:SetActive(false)
    self.config.feedBeastAnchor.gameObject:SetActive(false)
    self.config.exchangeAnchor.gameObject:SetActive(false)
    self.config.specialOfferAnchor.gameObject:SetActive(false)
    self.config.gemBoxAnchor.gameObject:SetActive(false)
    self.config.dailyCheckInAnchor.gameObject:SetActive(false)
    self.config.festivalMarketAnchor.gameObject:SetActive(false)
    self.config.festivalQuestAnchor.gameObject:SetActive(false)
    self.config.midAutumnArena.gameObject:SetActive(false)
end

function UIEventMidAutumnView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_mid_autumn_info"))
end

--- @param midAutumnTab MidAutumnTab
function UIEventMidAutumnView:_GetEventName(midAutumnTab)
    if midAutumnTab == MidAutumnTab.GOLDEN_TIME then
        return LanguageUtils.LocalizeCommon("event_golden_time_name")
    elseif midAutumnTab == MidAutumnTab.FEED_BEAST then
        return LanguageUtils.LocalizeCommon("event_feed_beast_name")
    elseif midAutumnTab == MidAutumnTab.EXCHANGE then
        return LanguageUtils.LocalizeCommon("event_midautumn_exchange_name")
    elseif midAutumnTab == MidAutumnTab.SPECIAL_OFFER then
        return LanguageUtils.LocalizeCommon("event_midautumn_specialoffer")
    elseif midAutumnTab == MidAutumnTab.GEM_BOX then
        return LanguageUtils.LocalizeCommon("event_gem_box_name")
    elseif midAutumnTab == MidAutumnTab.FESTIVAL_MARKET then
        return LanguageUtils.LocalizeCommon("event_festival_market_name")
    elseif midAutumnTab == MidAutumnTab.QUEST then
        return LanguageUtils.LocalizeCommon("event_mid_autumn_quest_name")
    elseif midAutumnTab == MidAutumnTab.ARENA then
        return LanguageUtils.LocalizeCommon("event_mid_autumn_arena_name")
    else
        return LanguageUtils.LocalizeCommon("event_midautumn_checkin")
    end
end

--- @param midAutumnTab MidAutumnTab
function UIEventMidAutumnView:_GetEventIcon(midAutumnTab)
    return ResourceLoadUtils.LoadEventMidAutumn(midAutumnTab)
end

--- @param midAutumnTab MidAutumnTab
function UIEventMidAutumnView:_GetEventNotification(midAutumnTab)
    return self.eventMidAutumnModel:IsTabNotified(midAutumnTab)
end

function UIEventMidAutumnView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventMidAutumnModel:GetType(), ["isAdded"] = false })
end

--- @param midAutumnTab MidAutumnTab
function UIEventMidAutumnView:UpdateNotificationByTab(midAutumnTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(midAutumnTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventMidAutumnView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
    --zg.playerData.remoteConfig.showedEventAutumnTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
    zg.playerData.remoteConfig.showedEventAutumnTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
    zg.playerData:SaveRemoteConfig()
end

function UIEventMidAutumnView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventMidAutumnView:CheckAllNotificationTab()
    --- @param v MidAutumnTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIEventMidAutumnView:_GetEventEndTime(midAutumnTab)
    if midAutumnTab == MidAutumnTab.SPECIAL_OFFER then
        return self.eventMidAutumnModel.timeData.endTime - TimeUtils.SecondAMin * 10
    end
    return self.eventMidAutumnModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventMidAutumnView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            self:HideCurrentLayout()
            self:RemoveListener()
            self:OnReadyShow()
        end, true)
    end
end

function UIEventMidAutumnView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideCurrentLayout()
end

function UIEventMidAutumnView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventMidAutumnView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end