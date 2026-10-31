require "lua.client.scene.ui.home.uiEventSeasonal.layout.UIEventSeasonalLayout"

--- @class UIEventSeasonalView : UIBaseView
UIEventSeasonalView = Class(UIEventSeasonalView, UIBaseView)

function UIEventSeasonalView:Ctor(model)
    --- @type UISeasonalConfig
    self.config = nil
    --- @type Dictionary
    self.layoutDict = Dictionary()
    --- @type UIEventSeasonalLayout
    self.layout = nil
    --- @type Dictionary
    self.eventTabDict = Dictionary()
    --- @type EventSeasonalModel
    self.eventModel = nil
    ---@type EventSeasonalConfig
    self.eventConfig = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SEASONAL
    --- @type boolean
    self.isReloadingData = nil
    UIBaseView.Ctor(self, model)
    --- @type UIEventSeasonalModel
    self.model = model
end

function UIEventSeasonalView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)
    --self.config.textCurrentFloor.gameObject:SetActive(false)
    self:InitButtons()
    self:InitUpdateTime()
end

function UIEventSeasonalView:InitButtons()
    self.config.buttonBack.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonHelpInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_seasonal_info"))
    end)
end

function UIEventSeasonalView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("event_seasonal")
    if self.layoutDict ~= nil then
        --- @param v UIEventAiryuuLayout
        for _, v in pairs(self.layoutDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventSeasonalView:InitEventButtons()
    for eventSeasonalTab = 1, self.model.listSubEvent:Count()do
        local eventButton = self.config.listEventButtons.transform:GetChild(eventSeasonalTab - 1)
        --- @type UIEventSubButtonItem
        local eventSubButtonItem = UIEventSubButtonItem(eventButton)
        eventSubButtonItem:SetConfig(eventButton)
        eventSubButtonItem:SetText(self:_GetEventName(eventSeasonalTab))
        eventSubButtonItem:SetNotificationFunction(function()
            return self:_GetEventNotification(eventSeasonalTab)
        end)
        eventSubButtonItem:AddOnSelectListener(function()
            self:OnClickSelectTab(eventSeasonalTab)
        end)
        self.eventTabDict:Add(eventSeasonalTab, eventSubButtonItem)
    end
end

function UIEventSeasonalView:OnClickBackOrClose()
    zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    if self.layout ~= nil and self.layout.config.gameObject.activeInHierarchy then
        self:HideCurrentLayout()
        return
    end
    self:OnReadyHide()
    zg.playerData:SaveRemoteConfig()
end

--- @param data {callbackClose : function}
function UIEventSeasonalView:OnReadyShow(data)
    UIBaseView.OnReadyShow(self, data)
    self.config.backGroundCover:SetActive(false)
    self.isReloadingData = false
    --- @type EventSeasonalModel
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
    if data and data.tab ~= nil then
        self:SelectTab(data.tab)
    end
end

---@param eventSeasonalTab EventSeasonalTab
function UIEventSeasonalView:SelectTab(eventSeasonalTab)
    self:CheckAllNotificationTab()
    self:GetLayout(eventSeasonalTab)
    self.layout:OnShow(self)
    self.config.backGroundCover:SetActive(true)
end

function UIEventSeasonalView:OnClickSelectTab(eventSeasonalTab)
    self:SelectTab(eventSeasonalTab)
end

--- @param eventSeasonalTab EventSeasonalTab
function UIEventSeasonalView:GetLayout(eventSeasonalTab)
    self:DisableCommon()
    self.layout = self.layoutDict:Get(eventSeasonalTab)
    if self.layout == nil then
        local transform = self.config.listEventAnchor.transform:GetChild(eventSeasonalTab)
        if transform then
            if eventSeasonalTab == EventSeasonalTab.DAILY_CHECKIN then
                require "lua.client.scene.ui.home.uiEventSeasonal.layout.checkin.UIEventSeasonalCheckinLayout"
                self.layout = UIEventSeasonalCheckinLayout(self, eventSeasonalTab, transform)
            elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_SHOP then
                require "lua.client.scene.ui.home.uiEventSeasonal.layout.fireworkShop.UIEventSeasonalFireworkShopLayout"
                self.layout = UIEventSeasonalFireworkShopLayout(self, eventSeasonalTab, transform)
            elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_EXCHANGE then
                require "lua.client.scene.ui.home.uiEventSeasonal.layout.fireworkExchange.UIEventSeasonalExchangeLayout"
                self.layout = UIEventSeasonalExchangeLayout(self, eventSeasonalTab, transform)
            elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_CREATOR then
                require "lua.client.scene.ui.home.uiEventSeasonal.layout.fireworkCreator.UIEventSeasonalFireworkCreatorLayout"
                self.layout = UIEventSeasonalFireworkCreatorLayout(self, eventSeasonalTab, transform)
            elseif eventSeasonalTab == EventSeasonalTab.SUPPER_GIFT then
                require "lua.client.scene.ui.home.uiEventSeasonal.layout.superGift.UIEventSeasonalSuperGiftLayout"
                self.layout = UIEventSeasonalSuperGiftLayout(self, eventSeasonalTab, transform)
            elseif eventSeasonalTab == EventSeasonalTab.ROYAL_CHALLENGE then
                require "lua.client.scene.ui.home.uiEventSeasonal.layout.royalChallenge.UIEventSeasonalRoyalChallengeLayout"
                self.layout = UIEventSeasonalRoyalChallengeLayout(self, eventSeasonalTab, transform)
            else
                require "lua.client.scene.ui.home.uiEventSeasonal.layout.checkin.UIEventSeasonalCheckinLayout"
                self.layout = UIEventSeasonalCheckinLayout(self, eventSeasonalTab, transform)
            end
        else
            return nil
        end
        self.layoutDict:Add(eventSeasonalTab, self.layout)
    end
end

function UIEventSeasonalView:DisableCommon()
    self:HideCurrentLayout()
end

--- @param eventSeasonalTab EventSeasonalTab
function UIEventSeasonalView:_GetEventName(eventSeasonalTab)
    if eventSeasonalTab == EventSeasonalTab.DAILY_CHECKIN then
        return LanguageUtils.LocalizeCommon("seasonal_daily_checkin")
    elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_CREATOR then
        return LanguageUtils.LocalizeCommon("seasonal_firework_creator")
    elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_SHOP then
        return LanguageUtils.LocalizeCommon("seasonal_firework_shop")
    elseif eventSeasonalTab == EventSeasonalTab.FIREWORK_EXCHANGE then
        return LanguageUtils.LocalizeCommon("seasonal_firework_exchange")
    elseif eventSeasonalTab == EventSeasonalTab.ROYAL_CHALLENGE then
        return LanguageUtils.LocalizeCommon("seasonal_royal_challenge")
    elseif eventSeasonalTab == EventSeasonalTab.SUPPER_GIFT then
        return LanguageUtils.LocalizeCommon("seasonal_super_gift")
    end
end

--- @param eventSeasonalTab EventSeasonalTab
function UIEventSeasonalView:_GetEventNotification(eventSeasonalTab)
    if self.eventModel then
        return self.eventModel:IsTabNotified(eventSeasonalTab)
    else
        return false
    end
end
--- @param eventSeasonalTab EventSeasonalTab
function UIEventSeasonalView:UpdateNotificationByTab(eventSeasonalTab)
    --- @type UIEventSubButtonItem
    local objTab = self.eventTabDict:Get(eventSeasonalTab)
    if objTab ~= nil then
        objTab:UpdateNotification()
    end
end

function UIEventSeasonalView:OnReadyHide()
    PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventSeasonalView:CheckAllNotificationTab()
    --- @param v UIEventSubButtonItem
    for k, _ in pairs(self.eventTabDict:GetItems()) do
        self:UpdateNotificationByTab(k)
    end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventSeasonalView:OnEventStateChange(data)
    local isAdded = data.isAdded
    if isAdded == false and self.isReloadingData ~= true then
        self.isReloadingData = true
        EventInBound.ValidateEventModel(function()
            ---@type EventSeasonalModel
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

function UIEventSeasonalView:Hide()
    UIBaseView.Hide(self)
    self:RemoveListener()
    self:RemoveUpdateTime()
    self:HideCurrentLayout()
end

function UIEventSeasonalView:RemoveListener()
    if self.eventListener ~= nil then
        self.eventListener:Unsubscribe()
        self.eventListener = nil
    end
end

function UIEventSeasonalView:HideCurrentLayout()
    if self.layout ~= nil then
        self.layout:OnHide()
        self.layout = nil
    end
end

function UIEventSeasonalView:_GetEventEndTime()
    if self.eventModel then
        return self.eventModel.timeData.endTime
    end
    return 0
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventSeasonalView:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

function UIEventSeasonalView:_OnEventTimeEnded()
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

function UIEventSeasonalView:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSeasonalView:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSeasonalView:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSeasonalView:InitUpdateTime()
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