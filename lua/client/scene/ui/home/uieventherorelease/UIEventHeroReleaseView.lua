require "lua.client.scene.ui.home.uiEventHeroRelease.uiEventHeroReleaseLayout.UIEventHeroReleaseLayout"

--- @class UIEventHeroReleaseView : UIBaseView
UIEventHeroReleaseView = Class(UIEventHeroReleaseView, UIBaseView)
--local HERO_RELEASE_IMG_PATH = "TexturesAutoLoaded/UI/HomeScene/Event/EventHeroRelease/"
local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventHeroReleaseModel
function UIEventHeroReleaseView:Ctor(model)
    --- @type UIEventHeroReleaseConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventHeroReleaseLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventHeroReleaseModel
    self.eventModel = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_HERO_RELEASE

    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventHeroReleaseModel
    self.model = model

    ---@type number
    self.dataID = nil
end

function UIEventHeroReleaseView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self:InitButtons()

    self:InitScrollTab()
end

function UIEventHeroReleaseView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

function UIEventHeroReleaseView:InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type EventHeroReleaseTab
        local eventHeroReleaseTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(eventHeroReleaseTab))
        obj:SetSelectState(self:_IsTabChosen(eventHeroReleaseTab))
        obj:SetIcon(self:_GetEventTabIcon(eventHeroReleaseTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(eventHeroReleaseTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(eventHeroReleaseTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(eventHeroReleaseTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(eventHeroReleaseTab, obj)
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

function UIEventHeroReleaseView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventHeroReleaseLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventHeroReleaseView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
    --zg.playerData.remoteConfig.showedEvenReleaseHeroTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
    zg.playerData.remoteConfig.showedEvenReleaseHeroTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
    zg.playerData:SaveRemoteConfig()
end

function UIEventHeroReleaseView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventHeroReleaseView:GetEventDataID()
    return zg.playerData:GetEvents():GetEvent(self.eventTimeType).timeData.dataId
end

--- @param data {eventTab : EventHeroReleaseTab, callbackClose : function}
function UIEventHeroReleaseView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)

    self.isReloadingData = false
    ---@type EventPopupModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)

    self:SetupBg()

    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self.model:InitListSubEvent(self.eventModel.timeData)
    if self.isOpen then
        if self.model.listSubEvent:Count() > 0 then
            if data ~= nil and data.eventTab ~= nil then
                self:SelectTab(data.eventTab)
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

--- @param eventHeroReleaseTab EventHeroReleaseTab
function UIEventHeroReleaseView:SelectTab(eventHeroReleaseTab)
    self:GetLayout(eventHeroReleaseTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventHeroReleaseView:OnClickSelectTab(eventTimeType)
    if self:_IsTabChosen(eventTimeType) then
        return
    end
    self:SelectTab(eventTimeType)
end

--- @param eventHeroReleaseTab EventHeroReleaseTab
function UIEventHeroReleaseView:_IsTabChosen(eventHeroReleaseTab)
    return self.layout ~= nil and self.layout.eventTab == eventHeroReleaseTab
end

--- @param eventHeroReleaseTab EventHeroReleaseTab
function UIEventHeroReleaseView:_GetEventTabIcon(eventHeroReleaseTab)
    return ResourceLoadUtils.LoadIconTabEventHeroReleaseTab(eventHeroReleaseTab, self:GetEventDataID())
end

function UIEventHeroReleaseView:OnClickHelpInfo()
    local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.dataID = eventModel.timeData.dataId
    local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("event_hero_release_info_" .. self.dataID),
            LanguageUtils.LocalizeCommon("hero_release_daily_quest_tittle_" .. self.dataID),
            LanguageUtils.LocalizeCommon("hero_release_collection_tittle_" .. self.dataID),
            LanguageUtils.LocalizeCommon("event_hero_release_bundle_tittle_" .. self.dataID))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param eventHeroReleaseTab EventHeroReleaseTab
function UIEventHeroReleaseView:GetLayout(eventHeroReleaseTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventHeroReleaseTab)
    if self.layout == nil then
        if eventHeroReleaseTab == EventHeroReleaseTab.Overview then
            require "lua.client.scene.ui.home.uiEventHeroRelease.uiEventHeroReleaseLayout.overview.UIEventHeroReleaseOverviewLayout"
            self.layout = UIEventHeroReleaseOverviewLayout(self, eventHeroReleaseTab, self.config.overviewAnchor)
        elseif eventHeroReleaseTab == EventHeroReleaseTab.DailyQuest then
            require "lua.client.scene.ui.home.uiEventHeroRelease.uiEventHeroReleaseLayout.UIEventHeroReleaseDailyQuestLayout"
            self.layout = UIEventHeroReleaseDailyQuestLayout(self, eventHeroReleaseTab, self.config.dailyQuestAnchor)
        elseif eventHeroReleaseTab == EventHeroReleaseTab.Collection then
            require "lua.client.scene.ui.home.uiEventHeroRelease.uiEventHeroReleaseLayout.UIEventHeroReleaseCollectionLayout"
            self.layout = UIEventHeroReleaseCollectionLayout(self, eventHeroReleaseTab, self.config.collectionAnchor)
        elseif eventHeroReleaseTab == EventHeroReleaseTab.Bundle then
            require "lua.client.scene.ui.home.uiEventHeroRelease.uiEventHeroReleaseLayout.bundle.UIEventHeroReleaseBundleLayout"
            self.layout = UIEventHeroReleaseBundleLayout(self, eventHeroReleaseTab, self.config.bundleAnchor)
        elseif eventHeroReleaseTab == EventHeroReleaseTab.OverviewOtherHero then
            require "lua.client.scene.ui.home.uiEventHeroRelease.uiEventHeroReleaseLayout.overview.UIEventHeroReleaseOtherOverviewLayout"
            self.layout = UIEventHeroReleaseOtherOverviewLayout(self, eventHeroReleaseTab, self.config.otherOverviewAnchor)
        else
            XDebug.Error("Missing layout type " .. eventHeroReleaseTab)
            return nil
        end
        self.layoutDict:Add(eventHeroReleaseTab, self.layout)
    end
end

--- @param eventHeroReleaseTab EventHeroReleaseTab
function UIEventHeroReleaseView:_GetEventName(eventHeroReleaseTab)
    if eventHeroReleaseTab == EventHeroReleaseTab.Overview then
        return LanguageUtils.LocalizeCommon("hero_release_overview")
    elseif eventHeroReleaseTab == EventHeroReleaseTab.OverviewOtherHero then
        return LanguageUtils.LocalizeCommon("hero_release_overview")
    elseif eventHeroReleaseTab == EventHeroReleaseTab.DailyQuest then
        return LanguageUtils.LocalizeCommon("hero_release_daily_quest")
    elseif eventHeroReleaseTab == EventHeroReleaseTab.Collection then
        return LanguageUtils.LocalizeCommon("hero_release_collection")
    else
        return LanguageUtils.LocalizeCommon("hero_release_bundle")
    end
end

--- @param eventHeroReleaseTab EventHeroReleaseTab
function UIEventHeroReleaseView:_GetEventNotification(eventHeroReleaseTab)
    return self.eventModel:IsTabNotified(eventHeroReleaseTab)
end

function UIEventHeroReleaseView:_GetEventEndTime(eventBirthdayTab)
    return self.eventModel.timeData.endTime
end

function UIEventHeroReleaseView:DisableCommon()
    self:HideCurrentLayout()
end

--- @param data {eventTab : EventHeroReleaseTab, isAdded}
function UIEventHeroReleaseView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventHeroReleaseModel
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

function UIEventHeroReleaseView:CheckAllNotificationTab()
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param eventHeroReleaseTab EventHeroReleaseTab
function UIEventHeroReleaseView:UpdateNotificationByTab(eventHeroReleaseTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(eventHeroReleaseTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventHeroReleaseView:Hide()
    UIBaseView.Hide(self)

    self:RemoveListener()

    self:HideCurrentLayout()

    self:HideScrollTab()
end

function UIEventHeroReleaseView:HideScrollTab()
    self.scrollLoopTab:Hide()

    self.eventTabDict:Clear()
end

function UIEventHeroReleaseView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventHeroReleaseView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIEventHeroReleaseView:SetupBg()
    local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    local dataId = eventModel.timeData.dataId

    local bg = ResourceLoadUtils.LoadTexture("BgEventHeroRelease", tostring(dataId), ComponentName.UnityEngine_Sprite)
    if bg ~= nil then
        self.config.backGround.sprite = bg
        uiCanvas:SetBackgroundSize(self.config.backGround)
    end
    local factionNumber = ClientConfigUtils.GetFactionIdByEventHeroRelease(eventModel:GetConfig())

    local bgColumn = ResourceLoadUtils.LoadObject("Textures/BannerHeroReleaseOverview/" .. "icon_column_" .. factionNumber, ComponentName.UnityEngine_Sprite)

    local eventNewHeroModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_SUMMON)
    if eventNewHeroModel ~= nil and eventNewHeroModel:IsOpening() then
        local dataId = eventNewHeroModel.timeData.dataId
        bgColumn = ResourceLoadUtils.LoadSpriteFromAtlas("CollumnEventNewHero", dataId)
    end

    self.config.bgColumn1.sprite = bgColumn
    self.config.bgColumn2.sprite = bgColumn
end