require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.UIEventHalloweenLayout"
require "lua.client.core.network.event.eventHalloweenModel.EventHalloweenModel"
--- @class UIEventHalloweenView : UIBaseView
UIEventHalloweenView = Class(UIEventHalloweenView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventHalloweenModel
function UIEventHalloweenView:Ctor(model)
    --- @type UIEventHalloweenConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventHalloweenLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventHalloweenModel
    self.eventHalloweenModel = nil

    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventHalloweenModel
    self.model = model
end

function UIEventHalloweenView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventHalloweenView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventHalloweenLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventHalloweenView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventHalloweenView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type HalloweenTab
        local halloweenTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(halloweenTab))
        obj:SetSelectState(self:_IsTabChosen(halloweenTab))
        obj:SetIcon(self:_GetEventIcon(halloweenTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(halloweenTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(halloweenTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(halloweenTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(halloweenTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type HalloweenTab
        local halloweenTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(halloweenTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param halloweenTab HalloweenTab
function UIEventHalloweenView:_IsTabChosen(halloweenTab)
    return self.layout ~= nil and self.layout.halloweenTab == halloweenTab
end

function UIEventHalloweenView:OnReadyShow()
    self.isReloadingData = false
    self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    self.eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    self:CheckResourceOnSeason()
    self.model:InitListSubEvent(self.eventHalloweenModel.timeData)
    if self.model.listSubEvent:Count() > 0 then
        self:SelectTab(self.model.listSubEvent:Get(HalloweenTab.GOLDEN_TIME))
        self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
        self:CheckAllNotificationTab()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
    end
end

function UIEventHalloweenView:CheckResourceOnSeason()
    local endTime = self.eventHalloweenModel.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventHalloweenEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventHalloweenEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function UIEventHalloweenView:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.EVENT_HALLOWEEN_DICE)
    clearResource(MoneyType.EVENT_HALLOWEEN_PUMPKIN)
end
function UIEventHalloweenView:SelectTab(halloweenTab)
    self:GetLayout(halloweenTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventHalloweenView:OnClickSelectTab(halloweenTab)
    if self:_IsTabChosen(halloweenTab) then
        return
    end
    self:SelectTab(halloweenTab)
end

--- @param halloweenTab HalloweenTab
function UIEventHalloweenView:GetLayout(halloweenTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(halloweenTab)
    if self.layout == nil then
        if halloweenTab == HalloweenTab.DICE then
            require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.UIEventDiceLayout"
            self.layout = UIEventDiceLayout(self, halloweenTab, self.config.diceAnchor)
        elseif halloweenTab == HalloweenTab.SPECIAL_OFFER then
            require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventSpecialOffer.UIEventHalloweenSpecialOfferLayout"
            self.layout = UIEventHalloweenSpecialOfferLayout(self, halloweenTab, self.config.specialAnchor)
        elseif halloweenTab == HalloweenTab.GOLDEN_TIME then
            require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventGoldenTime.UIEventHalloweenGoldenTimeLayout"
            self.layout = UIEventHalloweenGoldenTimeLayout(self, halloweenTab, self.config.goldenTimeAnchor)
        elseif halloweenTab == HalloweenTab.EXCHANGE then
            require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventExchange.UIEventHalloweenExchangeLayout"
            self.layout = UIEventHalloweenExchangeLayout(self, halloweenTab, self.config.exchangeAnchor)
        --elseif halloweenTab == HalloweenTab.DAILY_CHECK_IN then
        --    require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.UIEventHalloweenDailyCheckInLayout"
        --    self.layout = UIEventHalloweenDailyCheckInLayout(self, halloweenTab, self.config.dailyCheckInAnchor)
        elseif halloweenTab == HalloweenTab.QUEST then
            require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventQuest.UIEventHalloweenQuestLayout"
            self.layout = UIEventHalloweenQuestLayout(self, halloweenTab, self.config.questAnchor)
        elseif halloweenTab == HalloweenTab.SHOP then
            require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventShop.UIEventHalloweenShopLayout"
            self.layout = UIEventHalloweenShopLayout(self, halloweenTab, self.config.shopAnchor)
        else

            XDebug.Error("Missing layout type " .. halloweenTab)
            return nil
        end
        self.layoutDict:Add(halloweenTab, self.layout)
    end
end

function UIEventHalloweenView:DisableCommon()
    self:HideCurrentLayout()
    self.config.goldenTimeAnchor.gameObject:SetActive(false)
    self.config.exchangeAnchor.gameObject:SetActive(false)
    self.config.specialAnchor.gameObject:SetActive(false)
    self.config.dailyCheckInAnchor.gameObject:SetActive(false)
    self.config.diceAnchor.gameObject:SetActive(false)
    self.config.questAnchor.gameObject:SetActive(false)
    self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventHalloweenView:OnClickHelpInfo()
    --- @type string
    local content = LanguageUtils.LocalizeHelpInfo("event_halloween_info")
    content = StringUtils.FormatLocalize(content, nil,
            LanguageUtils.LocalizeCommon("halloween_daily_checkin"),
            LanguageUtils.LocalizeCommon("dice_title"),
            LanguageUtils.LocalizeCommon("event_halloween_exchange_name"),
            LanguageUtils.LocalizeCommon("event_halloween_specialoffer"),
            LanguageUtils.LocalizeCommon("daily_packs"),
            LanguageUtils.LocalizeCommon("roll"),
            LanguageUtils.LocalizeCommon("halloween_purchase_1"))
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param halloweenTab HalloweenTab
function UIEventHalloweenView:_GetEventName(halloweenTab)
    if halloweenTab == HalloweenTab.GOLDEN_TIME then
        return LanguageUtils.LocalizeCommon("event_golden_time_halloween_name")
    elseif halloweenTab == HalloweenTab.EXCHANGE then
        return LanguageUtils.LocalizeCommon("event_halloween_exchange_name")
    elseif halloweenTab == HalloweenTab.SPECIAL_OFFER then
        return LanguageUtils.LocalizeCommon("event_halloween_specialoffer")
    --elseif halloweenTab == HalloweenTab.DAILY_CHECK_IN then
    --    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
    elseif halloweenTab == HalloweenTab.QUEST then
        return LanguageUtils.LocalizeCommon("halloween_quest")
    elseif halloweenTab == HalloweenTab.SHOP then
        return LanguageUtils.LocalizeCommon("halloween_shop")
    else
        return LanguageUtils.LocalizeCommon("dice_title")
    end
end

--- @param halloweenTab HalloweenTab
function UIEventHalloweenView:_GetEventIcon(halloweenTab)
    return ResourceLoadUtils.LoadEventHalloween(halloweenTab)
end

--- @param halloweenTab HalloweenTab
function UIEventHalloweenView:_GetEventNotification(halloweenTab)
    return self.eventHalloweenModel:IsTabNotified(halloweenTab)
end

function UIEventHalloweenView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventHalloweenModel:GetType(), ["isAdded"] = false })
end

--- @param halloweenTab HalloweenTab
function UIEventHalloweenView:UpdateNotificationByTab(halloweenTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(halloweenTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventHalloweenView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
    --zg.playerData.remoteConfig.showedEventHalloweenTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
    zg.playerData.remoteConfig.showedEventHalloweenTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
    zg.playerData:SaveRemoteConfig()
end

function UIEventHalloweenView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventHalloweenView:CheckAllNotificationTab()
    --- @param v HalloweenTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIEventHalloweenView:_GetEventEndTime(halloweenTab)
    if halloweenTab == HalloweenTab.SPECIAL_OFFER then
        return self.eventHalloweenModel.timeData.endTime - TimeUtils.SecondAMin * 10
    end
    return self.eventHalloweenModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventHalloweenView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventHalloweenModel
            local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow()
            else
                if PopupUtils.IsPopupShowing(UIPopupName.UIEventHalloween) == false then
                    return
                end
                PopupMgr.HidePopup(UIPopupName.UIEventHalloween)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

function UIEventHalloweenView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideCurrentLayout()
end

function UIEventHalloweenView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventHalloweenView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end