require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.UIEventLunarPathLayout"

--- @class UIEventLunarPathView : UIBaseView
UIEventLunarPathView = Class(UIEventLunarPathView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @return void
--- @param model UIEventLunarPathModel
function UIEventLunarPathView:Ctor(model)
    --- @type UIEventLunarPathConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventLunarPathLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventLunarPathModel
    self.eventModel = nil

    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_LUNAR_PATH
    UIBaseView.Ctor(self, model)
    --- @type UIEventLunarPathModel
    self.model = model
end

--- @return void
function UIEventLunarPathView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventLunarPathView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventLunarPathLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventLunarPathView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end)
end

--- @return void
function UIEventLunarPathView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventLunarPathView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventLunarPathView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LunarPathTab
        local lunarPathTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(lunarPathTab))
        obj:SetSelectState(self:_IsTabChosen(lunarPathTab))
        obj:SetIcon(self:_GetEventIcon(lunarPathTab))
        obj:SetNotificationFunction(function()
            return self.eventModel:IsLunarPathTabNotified(lunarPathTab)
        end)
        obj:SetEndEventTime(self.eventModel.timeData.endTime, function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(lunarPathTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(lunarPathTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type NewYearTab
        local newYearTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(newYearTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param lunarPathTab LunarPathTab
function UIEventLunarPathView:_GetEventName(lunarPathTab)
    if lunarPathTab == LunarPathTab.DICE then
        return LanguageUtils.LocalizeCommon("lunar_path_dice")
    elseif lunarPathTab == LunarPathTab.QUEST then
        return LanguageUtils.LocalizeCommon("event_lunar_path_quest")
    elseif lunarPathTab == LunarPathTab.BOSS then
        return LanguageUtils.LocalizeCommon("event_lunar_path_boss")
    elseif lunarPathTab == LunarPathTab.SHOP then
        return LanguageUtils.LocalizeCommon("event_lunar_path_shop")
    elseif lunarPathTab == LunarPathTab.BUNDLE then
        return LanguageUtils.LocalizeCommon("event_lunar_path_bundle")
    else
        return LanguageUtils.LocalizeCommon("event_lunar_path_boss")
    end
end

--- @param lunarPathTab LunarPathTab
function UIEventLunarPathView:_IsTabChosen(lunarPathTab)
    return self.layout ~= nil and self.layout.lunarPathTab == lunarPathTab
end

--- @param lunarPathTab LunarPathTab
function UIEventLunarPathView:_GetEventIcon(lunarPathTab)
    return ResourceLoadUtils.LoadEventLunarPathIcon(lunarPathTab)
end

--- @param newYearTab NewYearTab
function UIEventLunarPathView:_GetEventNotification(newYearTab)
    return self.eventModel:IsLunarPathTabNotified(newYearTab)
end

function UIEventLunarPathView:_OnEventTimeEnded()
    if self.isReloadingData == true then
        return
    end
    self.isReloadingData = true
    EventInBound.ValidateEventModel(function()
        ---@type EventLunarPathModel
        local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_PATH)
        if eventModel:IsOpening() then
            self:HideCurrentLayout()
            self:OnReadyShow()
        else
            if PopupUtils.IsPopupShowing(UIPopupName.UIEventLunarPath) == false then
                return
            end
            PopupMgr.HidePopup(UIPopupName.UIEventLunarPath)
            PopupMgr.ShowPopup(UIPopupName.UIMainArea)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end, true)
end

function UIEventLunarPathView:OnClickSelectTab(lunarPathTab)
    if self:_IsTabChosen(lunarPathTab) then
        return
    end
    self:SelectTab(lunarPathTab)
end

function UIEventLunarPathView:SelectTab(lunarPathTab)
    self:GetLayout(lunarPathTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

--- @param lunarPathTab LunarPathTab
function UIEventLunarPathView:GetLayout(lunarPathTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(lunarPathTab)
    if self.layout == nil then
        if lunarPathTab == LunarPathTab.DICE then
            require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarDiceLayout.UIEventLunarDiceLayout"
            self.layout = UIEventLunarDiceLayout(self, lunarPathTab, self.config.goldenAnchor)
        elseif lunarPathTab == LunarPathTab.QUEST then
            require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarQuestLayout.UIEventLunarQuestLayout"
            self.layout = UIEventLunarQuestLayout(self, lunarPathTab, self.config.lotteryAnchor)
        elseif lunarPathTab == LunarPathTab.BOSS then
            require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarBossLayout.UIEventLunarBossLayout"
            self.layout = UIEventLunarBossLayout(self, lunarPathTab, self.config.exchangeAnchor)
        elseif lunarPathTab == LunarPathTab.SHOP then
            require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.UIEventLunarPathExchangeLayout"
            self.layout = UIEventLunarPathExchangeLayout(self, lunarPathTab, self.config.exchangeAnchor)
        elseif lunarPathTab == LunarPathTab.BUNDLE then
            require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarPathBundleLayout.UIEventLunarPathBundleLayout"
            self.layout = UIEventLunarPathBundleLayout(self, lunarPathTab, self.config.bundleAnchor)
        else
            XDebug.Error("Missing layout type " .. lunarPathTab)
            return nil
        end
        self.layoutDict:Add(lunarPathTab, self.layout)
    end
end

function UIEventLunarPathView:DisableCommon()
    self:HideCurrentLayout()
end

function UIEventLunarPathView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIEventLunarPathView:OnReadyShow(result)
    self.isReloadingData = false
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.isOpen = self.eventModel:IsOpening()
    self:CheckEndSeasonDisplay()
    self:CheckResourceOnSeason()
    self.model:InitListSubEvent()
    if self.isOpen then
        self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
        self:SelectTab(self.model.listSubEvent:Get(LunarPathTab.DICE))
        self:CheckAllNotificationTab()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
    end
    if result ~= nil and result.tab ~= nil then
        self:OnClickSelectTab(result.tab)
    end
end

function UIEventLunarPathView:CheckAllNotificationTab()
    --- @param k LunarPathTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param lunarPathTab LunarPathTab
function UIEventLunarPathView:UpdateNotificationByTab(lunarPathTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(lunarPathTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventLunarPathView:CheckEndSeasonDisplay()
    self.config.VerticalScrollTab.gameObject:SetActive(self.isOpen)
end

function UIEventLunarPathView:CheckResourceOnSeason()
    local endTime = self.eventModel.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventLunarNewYearEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventLunarNewYearEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function UIEventLunarPathView:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.EVENT_LUNAR_NEW_YEAR_DICE)
    clearResource(MoneyType.EVENT_LUNAR_NEW_FLAG)
    clearResource(MoneyType.EVENT_LUNAR_NEW_GUILD_POINT)
    clearResource(MoneyType.EVENT_LUNAR_NEW_YEAR_ENVELOPE)
    clearResource(MoneyType.SUMMON_ELITE_SCROLL)
    clearResource(MoneyType.EVENT_LUNAR_NEW_YEAR_CHALLENGE_STAMINA)
end

function UIEventLunarPathView:Hide()
    UIBaseView.Hide(self)

    self:HideCurrentLayout()

    self:HideScrollTab()
end

function UIEventLunarPathView:HideScrollTab()
    self.scrollLoopTab:Hide()
    self.eventTabDict:Clear()
end

function UIEventLunarPathView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_lunar_path_info"))
end