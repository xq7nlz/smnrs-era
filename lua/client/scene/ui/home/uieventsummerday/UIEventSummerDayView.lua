require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.UIEventSummerDayLayout"
require "lua.client.core.network.event.eventSummerDay.EventSummerDayModel"
--- @class UIEventSummerDayView : UIBaseView
UIEventSummerDayView = Class(UIEventSummerDayView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventSummerDayModel
function UIEventSummerDayView:Ctor(model)
	--- @type UIEventSummerDayConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventSummerDayLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventSummerDayModel
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventSummerDayModel
	self.model = model
end

function UIEventSummerDayView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventSummerDayView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventSummerDayLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventSummerDayView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventSummerDayView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type SummerDayTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(tab))
		obj:SetSelectState(self:_IsTabChosen(tab))
		obj:SetIcon(self:_GetEventIcon(tab))
		if tab == SummerDayTab.DICE or tab == SummerDayTab.QUEST then
			obj.config.icon.rectTransform.localScale = U_Vector3.one * 0.75
		end
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(tab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(tab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(tab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(tab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type SummerDayTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(tab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param tab SummerDayTab
function UIEventSummerDayView:_IsTabChosen(tab)
	return self.layout ~= nil and self.layout.tab == tab
end

function UIEventSummerDayView:OnReadyShow()
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SUMMER_DAY)
	self:CheckResourceOnSeason()
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(SummerDayTab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventSummerDayView:CheckResourceOnSeason()
	--local endTime = self.eventModel.timeData.endTime
	--local savedEndSeason = zg.playerData.remoteConfig.eventHalloweenEnd or endTime
	--if savedEndSeason ~= endTime then
	--	self:ClearMoneyType()
	--end
	--zg.playerData.remoteConfig.eventHalloweenEnd = endTime
	--zg.playerData:SaveRemoteConfig()
end

function UIEventSummerDayView:ClearMoneyType()
	local clearResource = function(moneyType)
		local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
		InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
	end
	clearResource(MoneyType.EVENT_SUMMER_PLAY_TICKET)
	clearResource(MoneyType.EVENT_SUMMER_EXCHANGE_TICKET)
end
function UIEventSummerDayView:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventSummerDayView:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:SelectTab(tab)
end

--- @param tab SummerDayTab
function UIEventSummerDayView:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == SummerDayTab.DICE then
			require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventDice.UIEventSummerDayDiceLayout"
			self.layout = UIEventSummerDayDiceLayout(self, tab, self.config.diceAnchor)
		elseif tab == SummerDayTab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventOffer.UIEventSummerDaySpecialOfferLayout"
			self.layout = UIEventSummerDaySpecialOfferLayout(self, tab, self.config.specialAnchor)
		elseif tab == SummerDayTab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventGoldenTime.UIEventSummerDayGoldenTimeLayout"
			self.layout = UIEventSummerDayGoldenTimeLayout(self, tab, self.config.goldenTimeAnchor)
		elseif tab == SummerDayTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventExchange.UIEventSummerDayExchangeLayout"
			self.layout = UIEventSummerDayExchangeLayout(self, tab, self.config.exchangeAnchor)
			--elseif SummerDayTab == SummerDayTab.DAILY_CHECK_IN then
			--    require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.UIEventHalloweenDailyCheckInLayout"
			--    self.layout = UIEventHalloweenDailyCheckInLayout(self, SummerDayTab, self.config.dailyCheckInAnchor)
		elseif tab == SummerDayTab.QUEST then
			require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventQuest.UIEventSummerDayQuestLayout"
			self.layout = UIEventSummerDayQuestLayout(self, tab, self.config.questAnchor)
		elseif tab == SummerDayTab.SHOP then
			require "lua.client.scene.ui.home.uiEventSummerDay.EventLayout.EventShop.UIEventSummerDayShopLayout"
			self.layout = UIEventSummerDayShopLayout(self, tab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. SummerDayTab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventSummerDayView:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventSummerDayView:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_summer_day_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("summer_day_daily_checkin"),
			LanguageUtils.LocalizeCommon("summer_day_dice_title"),
			LanguageUtils.LocalizeCommon("event_summer_day_exchange_name"),
			LanguageUtils.LocalizeCommon("event_summer_day_specialoffer"),
			LanguageUtils.LocalizeCommon("summer_day_daily_packs"),
			LanguageUtils.LocalizeCommon("summer_day_roll"),
			LanguageUtils.LocalizeCommon("summer_day_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tab SummerDayTab
function UIEventSummerDayView:_GetEventName(tab)
	if tab == SummerDayTab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_summer_day_name")
	elseif tab == SummerDayTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_summer_day_exchange_name")
	elseif tab == SummerDayTab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_summer_day_specialoffer")
		--elseif SummerDayTab == SummerDayTab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif tab == SummerDayTab.QUEST then
		return LanguageUtils.LocalizeCommon("summer_day_quest")
	elseif tab == SummerDayTab.SHOP then
		return LanguageUtils.LocalizeCommon("summer_day_shop")
	else
		return LanguageUtils.LocalizeCommon("summer_day_dice_title")
	end
end

--- @param tab SummerDayTab
function UIEventSummerDayView:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventSummerDay(tab)
end

--- @param tab SummerDayTab
function UIEventSummerDayView:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventSummerDayView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param tab SummerDayTab
function UIEventSummerDayView:UpdateNotificationByTab(tab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(tab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventSummerDayView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEventHalloweenTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	--zg.playerData.remoteConfig.showedEventHalloweenTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	--zg.playerData:SaveRemoteConfig()
end

function UIEventSummerDayView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventSummerDayView:CheckAllNotificationTab()
	--- @param v SummerDayTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventSummerDayView:_GetEventEndTime(tab)
	if tab == SummerDayTab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventSummerDayView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SUMMER_DAY)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventSummerDay) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventSummerDay)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventSummerDayView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventSummerDayView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventSummerDayView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end