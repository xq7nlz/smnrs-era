require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.UIEventXmasLayout"
require "lua.client.core.network.event.eventXmasModel.EventXmasModel"

--- @class UIEventXmasView : UIBaseView
UIEventXmasView = Class(UIEventXmasView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventXmasModel
function UIEventXmasView:Ctor(model)
    --- @type UIEventXMasConfig
    self.config = nil
    --- @type UILoopScroll
    self.scrollLoopTab = nil
    --- @type UILoopScroll
    self.scrollLoopContent = nil

    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventXmasLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()

    --- @type EventXmasModel
    self.eventModel = nil

    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventXmasModel
    self.model = model
end

function UIEventXmasView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    self:_InitButtonListener()
    self:_InitScrollTab()
end

function UIEventXmasView:InitLocalization()
    if self.layoutDict ~= nil then
        --- @param v UIEventXmasLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventXmasView:_InitButtonListener()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelpInfo()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    end)
end

function UIEventXmasView:_InitScrollTab()
    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type XmasTab
        local xmasTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetText(self:_GetEventName(xmasTab))
        obj:SetSelectState(self:_IsTabChosen(xmasTab))
        obj:SetIcon(self:_GetEventIcon(xmasTab))
        obj:SetNotificationFunction(function()
            return self:_GetEventNotification(xmasTab)
        end)
        obj:SetEndEventTime(self:_GetEventEndTime(xmasTab), function()
            self:_OnEventTimeEnded()
        end)
        obj:AddOnSelectListener(function()
            self:OnClickSelectTab(xmasTab)
        end)
        obj:SetPivot(pivotTab)
        self.eventTabDict:Add(xmasTab, obj)
    end

    --- @param obj UIEventPackageTabItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type XmasTab
        local xmasTab = self.model.listSubEvent:Get(dataIndex)
        obj:SetSelectState(self:_IsTabChosen(xmasTab))
    end
    self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
    self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param xmasTab XmasTab
function UIEventXmasView:_IsTabChosen(xmasTab)
    return self.layout ~= nil and self.layout.xmasTab == xmasTab
end

function UIEventXmasView:OnReadyShow(result)
    self.isReloadingData = false
    self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    self:CheckResourceOnSeason()
    self.model:InitListSubEvent(self.eventModel.timeData)
    if self.model.listSubEvent:Count() > 0 then
        self:SelectTab(self.model.listSubEvent:Get(XmasTab.GOLDEN_TIME))
        self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
        self:CheckAllNotificationTab()
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        self:OnReadyHide()
    end
    if result ~= nil and result.tab ~= nil then
        self:OnClickSelectTab(result.tab)
    end
end

function UIEventXmasView:CheckResourceOnSeason()
    local endTime = self.eventModel.timeData.endTime
    local savedEndSeason = zg.playerData.remoteConfig.eventXmasEnd or endTime
    if savedEndSeason ~= endTime then
        self:ClearMoneyType()
    end
    zg.playerData.remoteConfig.eventXmasEnd = endTime
    zg.playerData:SaveRemoteConfig()
end

function UIEventXmasView:ClearMoneyType()
    local clearResource = function(moneyType)
        local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
        InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
    end
    clearResource(MoneyType.EVENT_CHRISTMAS_CANDY_BAR)
    clearResource(MoneyType.EVENT_CHRISTMAS_BOX)
    clearResource(MoneyType.EVENT_CHRISTMAS_STAMINA)
end
function UIEventXmasView:SelectTab(xmasTab)
    self:GetLayout(xmasTab)
    self.layout:OnShow()
    self.scrollLoopTab:RefreshCells()
end

function UIEventXmasView:OnClickSelectTab(xmasTab)
    if self:_IsTabChosen(xmasTab) then
        return
    end
    self:SelectTab(xmasTab)
end

--- @param xmasTab XmasTab
function UIEventXmasView:GetLayout(xmasTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(xmasTab)
    if self.layout == nil then
        if xmasTab == XmasTab.DAILY_CHECK_IN then
            require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.checkIn.UIEventXmasCheckinLayout"
            self.layout = UIEventXmasCheckinLayout(self, xmasTab, self.config.dailyCheckInAnchor)
        elseif xmasTab == XmasTab.EXCLUSIVE_OFFER then
            require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.exclusiveOffer.UIEventXmasExclusiveOfferLayout"
            self.layout = UIEventXmasExclusiveOfferLayout(self, xmasTab, self.config.exclusiveAnchor)
        elseif xmasTab == XmasTab.SHOP then
            require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.shop.UIEventXmasShopLayout"
            self.layout = UIEventXmasShopLayout(self, xmasTab, self.config.shopAnchor)
        elseif xmasTab == XmasTab.GOLDEN_TIME then
            require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.goldenTime.UIEventXmasFullOfGiftLayout"
            self.layout = UIEventXmasFullOfGiftLayout(self, xmasTab, self.config.goldenAnchor)
        elseif xmasTab == XmasTab.FROSTY_IGNATIUS then
            require "lua.client.scene.ui.home.uiEventXmas.uiEventXmasLayout.frosty.UIEventFrostyIgnatiusLayout"
            self.layout = UIEventFrostyIgnatiusLayout(self, xmasTab, self.config.frostAnchor)
        else

            XDebug.Error("Missing layout type " .. xmasTab)
            return nil
        end
        self.layoutDict:Add(xmasTab, self.layout)
    end
end

function UIEventXmasView:DisableCommon()
    self:HideCurrentLayout()
    self.config.dailyCheckInAnchor.gameObject:SetActive(false)
    self.config.exclusiveAnchor.gameObject:SetActive(false)
    self.config.shopAnchor.gameObject:SetActive(false)
    self.config.goldenAnchor.gameObject:SetActive(false)
    self.config.frostAnchor.gameObject:SetActive(false)
end

function UIEventXmasView:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_xmas_info"))
end

--- @param xmasTab XmasTab
function UIEventXmasView:_GetEventName(xmasTab)
    if xmasTab == XmasTab.GOLDEN_TIME then
        return LanguageUtils.LocalizeCommon("event_xmas_golden_time_name")
    elseif xmasTab == XmasTab.FROSTY_IGNATIUS then
        return LanguageUtils.LocalizeCommon("event_frosty_ignatius")
    elseif xmasTab == XmasTab.SHOP then
        return LanguageUtils.LocalizeCommon("event_xmas_shop_name")
    elseif xmasTab == XmasTab.EXCLUSIVE_OFFER then
        return LanguageUtils.LocalizeCommon("event_exclusive_offer")
    elseif xmasTab == XmasTab.DAILY_CHECK_IN then
        return LanguageUtils.LocalizeCommon("event_xmas_daily_checkin")
    else
        return LanguageUtils.LocalizeCommon("event_xmas_golden_time_name")
    end
end

--- @param xmasTab XmasTab
function UIEventXmasView:_GetEventIcon(xmasTab)
    return ResourceLoadUtils.LoadEventXmas(xmasTab)
end

--- @param xmasTab XmasTab
function UIEventXmasView:_GetEventNotification(xmasTab)
    return self.eventModel:IsTabNotified(xmasTab)
end

function UIEventXmasView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param xmasTab XmasTab
function UIEventXmasView:UpdateNotificationByTab(xmasTab)
    --- @type UIEventPackageTabItem
    local objTab = self.eventTabDict:Get(xmasTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventXmasView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    self:OnReadyHide()
    --zg.playerData.remoteConfig.showedEvenXmasTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
    zg.playerData.remoteConfig.showedEvenXmasTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
    zg.playerData:SaveRemoteConfig()
end

function UIEventXmasView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventXmasView:CheckAllNotificationTab()
    --- @param v XmasTab
    --- @param v UIEventPackageTabItem
    for k, v in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

function UIEventXmasView:_GetEventEndTime(xmasTab)
    if xmasTab == XmasTab.EXCLUSIVE_OFFER then
        return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
    end
    return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventXmasView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventXmasModel
            local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
            if eventModel:IsOpening() then
                self:HideCurrentLayout()
                self:RemoveListener()
                self:OnReadyShow()
            else
                if PopupUtils.IsPopupShowing(UIPopupName.UIEventXmas) == false then
                    return
                end
                PopupMgr.HidePopup(UIPopupName.UIEventXmas)
                PopupMgr.ShowPopup(UIPopupName.UIMainArea)
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
            end
        end, true)
    end
end

function UIEventXmasView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:HideCurrentLayout()
end

function UIEventXmasView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventXmasView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end