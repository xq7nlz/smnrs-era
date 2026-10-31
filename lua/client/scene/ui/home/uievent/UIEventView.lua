require "lua.client.scene.ui.home.uiEvent.quest.UIEventQuestLayout"

--- @class UIEventView : UIBaseView
UIEventView = Class(UIEventView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @return void
--- @param model UIEventModel
function UIEventView:Ctor(model)
    --- @type UIEventConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventTimeType
    self.currentTab = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventModel
    self.model = model
end

--- @return void
function UIEventView:OnReadyCreate()
    ---@type UIEventConfig
    self.config = UIBaseConfig(self.uiTransform)

    uiCanvas:SetBackgroundSize(self.config.backGround)

    self:_InitButtonListener()

    self:_InitCommunityTab()
end

function UIEventView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
    if self.eventTabDict then
        local eventInBound = zg.playerData:GetEvents()
        if eventInBound then
            --- @type UIEventPackageTabItem
            for k, v in pairs(self.eventTabDict:GetItems()) do
                local eventPopupModel = eventInBound:GetEvent(k)
                if eventPopupModel then
                    v:SetText(self:_GetEventName(eventPopupModel.timeData))
                end
            end
        end

        --- @type UIEventPackageTabItem
        local eventPackageTabItem = self.eventTabDict:Get(EventTimeType.COMMUNITY_TYPE)
        if eventPackageTabItem then
            eventPackageTabItem:SetText(LanguageUtils.LocalizeCommon("social_tab"))
            self.config.textCommunity.text = LanguageUtils.LocalizeCommon("community")
        end
    end
end

function UIEventView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

function UIEventView:_InitCommunityTab() --spawn and init tabs
    local eventPackageTabItem = self:SpawnEventTabItem(self.config.communityTab)
    eventPackageTabItem:SetText(LanguageUtils.LocalizeCommon("social_tab"))
    eventPackageTabItem:SetIcon(ResourceLoadUtils.LoadEventTimeIcon(EventTimeType.COMMUNITY_TYPE))
    eventPackageTabItem:SetNotificationFunction(function()
        return zg.playerData:GetEvents().eventCommunityInBound:HasNotification()
    end)
    eventPackageTabItem:AddOnSelectListener(function()
        self:OnSelectTabByType(EventTimeType.COMMUNITY_TYPE)
    end)
    eventPackageTabItem:EnableTimer(false)
    eventPackageTabItem:SetPivot(pivotTab)
    eventPackageTabItem:SetLocalPos(U_Vector3(130, 0, 0))
    self.eventTabDict:Add(EventTimeType.COMMUNITY_TYPE, eventPackageTabItem)
end

function UIEventView:OnReadyShow()
    self.model:GetData()
    self:ResizeTab()
    self:ShowCurrentEvent()
    self.layout:PlayMotion()

    self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    self.notificationEvent = RxMgr.notificationEventPopup:Subscribe(RxMgr.CreateFunction(self, self.UpdateNotificationByTab))
end

function UIEventView:ShowCurrentEvent()
    self:HideLayout()
    local eventPopupModel = self.model.currentEventModel
    self:GetLayout(self.model.currentTab)
    self.layout:OnShow(eventPopupModel)

    self:EnableSelectTabState(self.model.currentTab, true)
end

--- @return void
function UIEventView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_info"))
end

function UIEventView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
    if self.notificationEvent ~= nil then
        self.notificationEvent:Unsubscribe()
        self.notificationEvent = nil
    end
end

--- @param eventTimeType EventTimeType
function UIEventView:OnSelectTabByType(eventTimeType)
    if self.model:IsCurrentTab(eventTimeType) == false then
        self:EnableSelectTabState(self.model.currentTab, false) -- toggle tab selected display
        self.model:SetTab(eventTimeType) --set current tab and current event model
        self:ShowCurrentEvent() -- set hide old layout and show new layout
    end
end

--- @param eventTimeData EventTimeData
function UIEventView:SetTitle(eventTimeData)
    local eventTimeType = eventTimeData.eventType
    if eventTimeType == EventTimeType.EVENT_EXCHANGE_QUEST then
        local _, type = ResourceMgr.GetEventExchangeConfig():GetDataFromId(eventTimeData.dataId)
        self.config.eventTittle.text = EventTimeType.GetLocalize(eventTimeType, type)
        self.config.eventDesc.text = EventTimeType.GetInfoLocalize(eventTimeType, type)
    elseif eventTimeType ~= EventTimeType.EVENT_LOGIN then
        self.config.eventTittle.text = EventTimeType.GetLocalize(eventTimeType)
        self.config.eventDesc.text = EventTimeType.GetInfoLocalize(eventTimeType)
    else
        self.config.eventTittle.text = ""
        self.config.eventDesc.text = ""
    end
end

--- @param opCode OpCode
--- @param packId number
--- @param dataId number
function UIEventView:OnClickBuyPack(opCode, packId, dataId)
    RxMgr.purchaseProduct:Next(ClientConfigUtils.GetPurchaseKey(opCode, packId, dataId))
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false then
        EventTimeData.flag = 1
        self.model.eventInBound.lastTimeGetEventPopupModel = nil
        self:RemoveListener()
        EventInBound.ValidateEventModel(function()
            --- @type EventInBound
            local eventInBound = zg.playerData:GetEvents()
            if eventInBound:IsOpeningEventPopup() then
                self:HideLayout()
                self:OnReadyShow()
            else
                if PopupUtils.IsPopupShowing(UIPopupName.UIEvent) == false then
                    return
                end
                PopupMgr.HidePopup(UIPopupName.UIEvent)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

--- @return string
--- @param eventTimeData EventTimeData
function UIEventView:GetBannerNameByType(eventTimeData)
    local bannerId = eventTimeData.eventType
    if bannerId == EventTimeType.EVENT_LOGIN then
        return nil
    end
    if bannerId == EventTimeType.EVENT_ARENA_RANKING then
        bannerId = EventTimeType.EVENT_ARENA_QUEST
    elseif bannerId == EventTimeType.EVENT_EXCHANGE_QUEST then
        local _, type = ResourceMgr.GetEventExchangeConfig():GetDataFromId(eventTimeData.dataId)
        bannerId = string.format("%s_%s", EventTimeType.EVENT_EXCHANGE_QUEST, type)
    end
    return string.format("banner_event_%s", bannerId)
end

--- @param eventTimeType EventTimeType
function UIEventView:GetLayout(eventTimeType)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventTimeType)
    if self.layout == nil then
        if eventTimeType == EventTimeType.EVENT_SUMMON_QUEST then
            require "lua.client.scene.ui.home.uiEvent.quest.UIEventHeroicSummonLayout"
            self.layout = UIEventHeroicSummonLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_PROPHET_TREE_QUEST then
            require "lua.client.scene.ui.home.uiEvent.quest.UIEventProphetTreeLayout"
            self.layout = UIEventProphetTreeLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_COLLECT_QUEST then
            require "lua.client.scene.ui.home.uiEvent.quest.UIEventHeroCollectLayout"
            self.layout = UIEventHeroCollectLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_TAVERN_QUEST then
            require "lua.client.scene.ui.home.uiEvent.quest.UIEventTavernLayout"
            self.layout = UIEventTavernLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_ARENA_QUEST then
            require "lua.client.scene.ui.home.uiEvent.quest.UIEventArenaQuestLayout"
            self.layout = UIEventArenaQuestLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_CASINO_QUEST then
            require "lua.client.scene.ui.home.uiEvent.quest.UIEventWheelOfFateLayout"
            self.layout = UIEventWheelOfFateLayout(self, eventTimeType)
        elseif EventTimeType.IsEventPopupQuest(eventTimeType) then
            self.layout = UIEventQuestLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_HOT_DEAL then
            require "lua.client.scene.ui.home.uiEvent.purchase.UIEventPurchaseLayout"
            self.layout = UIEventPurchaseLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_ARENA_RANKING then
            require "lua.client.scene.ui.home.uiEvent.arenaRanking.UIEventArenaRankingLayout"
            self.layout = UIEventArenaRankingLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_LOGIN then
            require "lua.client.scene.ui.home.uiEvent.eventLogin.UIEventLoginLayout"
            self.layout = UIEventLoginLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_RELEASE_FESTIVAL then
            require "lua.client.scene.ui.home.uiEvent.releaseFestival.UIEventReleaseFestivalLayout"
            self.layout = UIEventReleaseFestivalLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_EXCHANGE_QUEST then
            require "lua.client.scene.ui.home.uiEvent.exchange.UIEventExchangeLayout"
            self.layout = UIEventExchangeLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.EVENT_BUNDLE then
            require "lua.client.scene.ui.home.uiEvent.bundle.UIEventBundleLayout"
            self.layout = UIEventBundleLayout(self, eventTimeType)
        --elseif eventTimeType == EventTimeType.EVENT_GUILD_QUEST then
        --    require "lua.client.scene.ui.home.uiEvent.guildQuest.UIEventGuildQuestLayout"
        --    self.layout = UIEventGuildQuestLayout(self, eventTimeType)
        elseif eventTimeType == EventTimeType.COMMUNITY_TYPE then
            require "lua.client.scene.ui.home.uiEvent.community.UIEventCommunityLayout"
            self.layout = UIEventCommunityLayout(self, eventTimeType)
        else
            XDebug.Error("Missing layout type " .. eventTimeType)
            return nil
        end
        self.layout:InitLocalization()
        self.layoutDict:Add(eventTimeType, self.layout)
    end
end

function UIEventView:DisableCommon()
    self.config.textRound.text = ""
    if self.scrollLoopContent ~= nil then
        self.scrollLoopContent:Hide()
    end
    self.config.eventBanner.gameObject:SetActive(false)
end

function UIEventView:HideLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

--- @param eventTimeType EventTimeType
function UIEventView:UpdateNotificationByTab(eventTimeType)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(eventTimeType)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

--- @param cellSize UnityEngine_Vector2
--- @param spacing UnityEngine_Vector2
--- @param constraintCount number
function UIEventView:SetGridContentSize(cellSize, spacing, constraintCount)
    self.config.contentGroupLayout.cellSize = cellSize
    self.config.contentGroupLayout.spacing = spacing
    self.config.contentGroupLayout.constraintCount = constraintCount
end

function UIEventView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideLayout()
    self:HideAllTab()
    EventTimeData.flag = 1
end

function UIEventView:OnDestroy()
    --- @param v UIEventLayout
    for _, v in pairs(self.layoutDict:GetItems()) do
        v:OnDestroy()
    end
end

--- @param eventTimeData EventTimeData
function UIEventView:_GetEventName(eventTimeData)
    local eventTimeType = eventTimeData.eventType
    if eventTimeType == EventTimeType.EVENT_EXCHANGE_QUEST then
        local _, type = ResourceMgr.GetEventExchangeConfig():GetDataFromId(eventTimeData.dataId)
        return EventTimeType.GetLocalize(eventTimeType, type)
    else
        return EventTimeType.GetLocalize(eventTimeType)
    end
end

--- @param eventTimeData EventTimeData
function UIEventView:_GetEventIcon(eventTimeData) -- set time icon
    local eventTimeType = eventTimeData.eventType
    local sprite
    if eventTimeType == EventTimeType.EVENT_EXCHANGE_QUEST then
        local _, type = ResourceMgr.GetEventExchangeConfig():GetDataFromId(eventTimeData.dataId)
        sprite = ResourceLoadUtils.LoadEventTimeIcon(string.format("%s_%s", eventTimeType, type))
    else
        sprite = ResourceLoadUtils.LoadEventTimeIcon(eventTimeType)
    end
    return sprite
end

--- @param eventTimeType EventTimeType
function UIEventView:_OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventView:ResizeTab()
    self:HideAllTab()

    for i = 1, self.model.eventDataList:Count() do
        --- @type EventPopupModel
        local eventPopupModel = self.model.eventDataList:Get(i)
        --- @type EventTimeType
        local eventTimeType = eventPopupModel.timeData.eventType
        --- @type UIEventPackageTabItem
        local eventPackageTabItem = self.eventTabDict:Get(eventTimeType)
        if eventPackageTabItem == nil then
            eventPackageTabItem = self:SpawnEventTabItem(self.config.scrollTabContent)
            eventPackageTabItem:SetText(self:_GetEventName(eventPopupModel.timeData))
            eventPackageTabItem:SetIcon(self:_GetEventIcon(eventPopupModel.timeData))
            eventPackageTabItem:SetNotificationFunction(function()
                return eventPopupModel:HasNotification()
            end)
            eventPackageTabItem:AddOnSelectListener(function()
                self:OnSelectTabByType(eventTimeType)
            end)
            eventPackageTabItem:SetPivot(pivotTab)
            self.eventTabDict:Add(eventTimeType, eventPackageTabItem)
        end
        eventPackageTabItem:SetAsLastSibling()
        eventPackageTabItem:SetEndEventTime(eventPopupModel.timeData.endTime, function()
            self:_OnEventTimeEnded(eventTimeType)
        end)
        eventPackageTabItem:UpdateNotification()
        eventPackageTabItem:SetActive(true)
    end
    self.config.communityTab:SetAsLastSibling()
    local eventPackageTabItem = self.eventTabDict:Get(EventTimeType.COMMUNITY_TYPE)
    if eventPackageTabItem then
        eventPackageTabItem:UpdateNotification()
    end
end

--- @return UIEventPackageTabItem
function UIEventView:SpawnEventTabItem(anchor)
    return SmartPool.Instance:SpawnLuaUIPool(UIPoolType.EventPackageTabItem, anchor)
end

function UIEventView:HideAllTab()
    --- @param v UIEventPackageTabItem
    for eventTimeType, v in pairs(self.eventTabDict:GetItems()) do
        if eventTimeType ~= EventTimeType.COMMUNITY_TYPE then
            v:SetActive(false)
        end
        v:SetSelectState(false)
    end
end

function UIEventView:EnableSelectTabState(eventTimeType, isEnabled)
    if eventTimeType == nil then
        return
    end
    --- @type UIEventPackageTabItem
    local eventPackageTabItem = self.eventTabDict:Get(eventTimeType)
    if eventPackageTabItem ~= nil then
        eventPackageTabItem:SetSelectState(isEnabled)
    end
end
