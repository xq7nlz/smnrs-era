require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.UIEventNewYearLayout"
require "lua.client.core.network.event.eventNewYear.EventNewYearModel"

--- @class UIEventNewYearView : UIBaseView
UIEventNewYearView = Class(UIEventNewYearView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

function UIEventNewYearView:Ctor(model)
    --- @type UIEventNewYearConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventNewYearLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventNewYearModel
    self.eventModel = nil

    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR
    ---@type UIPopupName
    self.eventName = UIPopupName.UIEventNewYear
    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventNewYearModel
    self.model = model
end

function UIEventNewYearView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventNewYearView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventNewYearLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventNewYearView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventNewYearView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type NewYearTab
        local newYearTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(newYearTab))
        obj:SetSelectState(self:_IsTabChosen(newYearTab))
        obj:SetIcon(self:_GetEventIcon(newYearTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(newYearTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(newYearTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(newYearTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(newYearTab, obj)
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

--- @param newYearTab NewYearTab
function UIEventNewYearView:_IsTabChosen(newYearTab)
    return self.layout ~= nil and self.layout.newYearTab == newYearTab
end

function UIEventNewYearView:OnReadyShow()
    self.isReloadingData = false
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    self.isOpen = self.eventModel:IsOpening()
    if self.isOpen then
        self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    end
    self:CheckEndSeasonDisplay()
    self:CheckResourceOnSeason()
    self.model:InitListSubEvent(self.eventModel.timeData)
    if self.isOpen then
        if self.model.listSubEvent:Count() > 0 then
            self:SelectTab(self.model.listSubEvent:Get(NewYearTab.GOLDEN_TIME))
            self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
            self:CheckAllNotificationTab()
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            self:OnReadyHide()
        end
    else
        self:SelectTab(self.model.listSubEvent:Get(NewYearTab.CARD))
    end
end

function UIEventNewYearView:CheckEndSeasonDisplay()
    self.config.VerticalScrollTab.gameObject:SetActive(self.isOpen)
end

function UIEventNewYearView:CheckResourceOnSeason()
    local endTime = self.eventModel.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventNewYearEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventNewYearEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function UIEventNewYearView:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    --clearResource(MoneyType.EVENT_CHRISTMAS_CANDY_BAR)
    --clearResource(MoneyType.EVENT_CHRISTMAS_BOX)
    --clearResource(MoneyType.EVENT_CHRISTMAS_STAMINA)
end
function UIEventNewYearView:SelectTab(newYearTab)
    self:GetLayout(newYearTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventNewYearView:OnClickSelectTab(newYearTab)
    if self:_IsTabChosen(newYearTab) then
        return
    end
    self:CheckEventTabNoti()
    self:SelectTab(newYearTab)
end

--- @param newYearTab NewYearTab
function UIEventNewYearView:GetLayout(newYearTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(newYearTab)
    if self.layout == nil then
        if newYearTab == NewYearTab.GOLDEN_TIME then
            require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.goldenTime.UIEventNewYearGoldenTimeLayout"
            self.layout = UIEventNewYearGoldenTimeLayout(self, newYearTab, self.config.goldenAnchor)
        elseif newYearTab == NewYearTab.LOTTERY then
            require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.lottery.UIEventNewYearLotteryLayout"
            self.layout = UIEventNewYearLotteryLayout(self, newYearTab, self.config.lotteryAnchor)
        elseif newYearTab == NewYearTab.EXCHANGE then
            require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.exchange.UIEventNewYearExchangeLayout"
            self.layout = UIEventNewYearExchangeLayout(self, newYearTab, self.config.exchangeAnchor)
        elseif newYearTab == NewYearTab.CARD then
            require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.card.UIEventNewYearCardLayout"
            self.layout = UIEventNewYearCardLayout(self, newYearTab, self.config.cardAnchor)
        elseif newYearTab == NewYearTab.BUNDLE then
            require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.bundle.UIEventNewYearBundleLayout"
            self.layout = UIEventNewYearBundleLayout(self, newYearTab, self.config.bundleAnchor)
        else
            XDebug.Error("Missing layout type " .. newYearTab)
            return nil
        end
        self.layoutDict:Add(newYearTab, self.layout)
    end
end

function UIEventNewYearView:DisableCommon()
    self:HideCurrentLayout()
    self.config.goldenAnchor.gameObject:SetActive(false)
    self.config.lotteryAnchor.gameObject:SetActive(false)
    self.config.exchangeAnchor.gameObject:SetActive(false)
    self.config.cardAnchor.gameObject:SetActive(false)
    self.config.bundleAnchor.gameObject:SetActive(false)
end

function UIEventNewYearView:OnClickHelpInfo()
    local packId = 1
    local maxDay = self.eventModel:GetConfig():GetCardDurationMaxDictionaryConfig():Get(packId)
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, string.format(LanguageUtils.LocalizeHelpInfo("event_new_year_info"), maxDay))
end

--- @param newYearTab NewYearTab
function UIEventNewYearView:_GetEventName(newYearTab)
    if newYearTab == NewYearTab.GOLDEN_TIME then
        return LanguageUtils.LocalizeCommon("new_year_golden_time_name")
    elseif newYearTab == NewYearTab.EXCHANGE then
        return LanguageUtils.LocalizeCommon("event_new_year_exchange")
    elseif newYearTab == NewYearTab.CARD then
        return LanguageUtils.LocalizeCommon("event_new_year_card")
    elseif newYearTab == NewYearTab.LOTTERY then
        return LanguageUtils.LocalizeCommon("event_new_year_lottery")
    elseif newYearTab == NewYearTab.BUNDLE then
        return LanguageUtils.LocalizeCommon("event_new_year_bundle")
    else
        return LanguageUtils.LocalizeCommon("new_year_golden_time_name")
    end
end

--- @param newYearTab NewYearTab
function UIEventNewYearView:_GetEventIcon(newYearTab)
    return ResourceLoadUtils.LoadEventNewYear(newYearTab)
end

function UIEventNewYearView:CheckEventTabNoti() --hoangpl
    for tabEnum ,tabLayout in pairs (self.eventTabDict:GetItems()) do
        if  (tabLayout ~= nil) then
            tabLayout:SetNotificationFunction(function()
                return self:_GetEventNotification(tabEnum)
            end)
        end
    end
end

--- @param newYearTab NewYearTab
function UIEventNewYearView:_GetEventNotification(newYearTab)
    return self.eventModel:IsTabNotified(newYearTab)
end

function UIEventNewYearView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param newYearTab NewYearTab
function UIEventNewYearView:UpdateNotificationByTab(newYearTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(newYearTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventNewYearView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
end

function UIEventNewYearView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventNewYearView:CheckAllNotificationTab()
    --- @param v NewYearTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIEventNewYearView:_GetEventEndTime(newYearTab)
    --if newYearTab == NewYearTab.EXCLUSIVE_OFFER then
    --    return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
    --end
    return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventNewYearView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventNewYearModel
            local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow()
            else
                if PopupUtils.IsPopupShowing(self.eventName) == false then
                    return
                end
                PopupMgr.HidePopup(self.eventName)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

function UIEventNewYearView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideCurrentLayout()
end

function UIEventNewYearView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventNewYearView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end