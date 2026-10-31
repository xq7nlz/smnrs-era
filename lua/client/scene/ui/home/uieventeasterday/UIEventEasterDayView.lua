require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.UIEventEasterDayLayout"
require "lua.client.core.network.event.eventEasterDay.EventEasterDayModel"
--- @class UIEventEasterDayView : UIBaseView
UIEventEasterDayView = Class(UIEventEasterDayView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventEasterDayModel
function UIEventEasterDayView:Ctor(model)
	--- @type UIEventEasterDayConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventEasterDayLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventEasterDayModel
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventEasterDayModel
	self.model = model
end

function UIEventEasterDayView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventEasterDayView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventEasterDayLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventEasterDayView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventEasterDayView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EasterDayTab
		local easterDayTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(easterDayTab))
		obj:SetSelectState(self:_IsTabChosen(easterDayTab))
		obj:SetIcon(self:_GetEventIcon(easterDayTab))
		if easterDayTab == EasterDayTab.DICE then
			obj.config.icon.rectTransform.localScale = U_Vector3.one * 0.8
		end
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(easterDayTab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(easterDayTab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(easterDayTab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(easterDayTab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EasterDayTab
		local easterDayTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(easterDayTab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param easterDayTab EasterDayTab
function UIEventEasterDayView:_IsTabChosen(easterDayTab)
	return self.layout ~= nil and self.layout.tab == easterDayTab
end

--- @param data {callbackClose : function}
function UIEventEasterDayView:OnReadyShow(data)
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_DAY)
	self:CheckResourceOnSeason()
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(EasterDayTab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventEasterDayView:CheckResourceOnSeason()
	--local endTime = self.eventModel.timeData.endTime
	--local savedEndSeason = zg.playerData.remoteConfig.eventHalloweenEnd or endTime
	--if savedEndSeason ~= endTime then
	--	self:ClearMoneyType()
	--end
	--zg.playerData.remoteConfig.eventHalloweenEnd = endTime
	--zg.playerData:SaveRemoteConfig()
end

function UIEventEasterDayView:ClearMoneyType()
	local clearResource = function(moneyType)
		local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
		InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
	end
	clearResource(MoneyType.EASTER_DAY_PLAY_TICKET)
	clearResource(MoneyType.EASTER_DAY_EXCHANGE_TICKET)
end

function UIEventEasterDayView:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventEasterDayView:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:SelectTab(tab)
end

--- @param tab EasterDayTab
function UIEventEasterDayView:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == EasterDayTab.DICE then
			require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventDice.UIEventEasterDayDiceLayout"
			self.layout = UIEventEasterDayDiceLayout(self, tab, self.config.diceAnchor)
		elseif tab == EasterDayTab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventSpecialOffer.UIEventEasterDaySpecialOfferLayout"
			self.layout = UIEventEasterDaySpecialOfferLayout(self, tab, self.config.specialAnchor)
		elseif tab == EasterDayTab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventGoldenTime.UIEventEasterDayGoldenTimeLayout"
			self.layout = UIEventEasterDayGoldenTimeLayout(self, tab, self.config.goldenTimeAnchor)
		elseif tab == EasterDayTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventExchange.UIEventEasterDayExchangeLayout"
			self.layout = UIEventEasterDayExchangeLayout(self, tab, self.config.exchangeAnchor)
			--elseif tab == tab.DAILY_CHECK_IN then
			--    require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.UIEventHalloweenDailyCheckInLayout"
			--    self.layout = UIEventHalloweenDailyCheckInLayout(self, tab, self.config.dailyCheckInAnchor)
		elseif tab == EasterDayTab.QUEST then
			require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventQuest.UIEventEasterDayQuestLayout"
			self.layout = UIEventEasterDayQuestLayout(self, tab, self.config.questAnchor)
		elseif tab == EasterDayTab.SHOP then
			require "lua.client.scene.ui.home.uiEventEasterDay.EventLayout.EventShop.UIEventEasterDayShopLayout"
			self.layout = UIEventEasterDayShopLayout(self, tab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. tab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventEasterDayView:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventEasterDayView:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_easter_day_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("easter_day_daily_checkin"),
			LanguageUtils.LocalizeCommon("easter_day_dice_title"),
			LanguageUtils.LocalizeCommon("event_easter_day_exchange_name"),
			LanguageUtils.LocalizeCommon("event_easter_day_specialoffer"),
			LanguageUtils.LocalizeCommon("easter_day_daily_packs"),
			LanguageUtils.LocalizeCommon("easter_day_roll"),
			LanguageUtils.LocalizeCommon("easter_day_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tab EasterDayTab
function UIEventEasterDayView:_GetEventName(tab)
	if tab == EasterDayTab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_easter_day_name")
	elseif tab == EasterDayTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_easter_day_exchange_name")
	elseif tab == EasterDayTab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_easter_day_specialoffer")
		--elseif tab == tab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif tab == EasterDayTab.QUEST then
		return LanguageUtils.LocalizeCommon("easter_day_quest")
	elseif tab == EasterDayTab.SHOP then
		return LanguageUtils.LocalizeCommon("easter_day_shop")
	else
		return LanguageUtils.LocalizeCommon("easter_day_dice_title")
	end
end

--- @param tab EasterDayTab
function UIEventEasterDayView:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventEasterDay(tab)
end

--- @param tab EasterDayTab
function UIEventEasterDayView:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventEasterDayView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param tab EasterDayTab
function UIEventEasterDayView:UpdateNotificationByTab(tab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(tab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventEasterDayView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEventHalloweenTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	--zg.playerData.remoteConfig.showedEventHalloweenTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	--zg.playerData:SaveRemoteConfig()
end

function UIEventEasterDayView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventEasterDayView:CheckAllNotificationTab()
	--- @param v HalloweenTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventEasterDayView:_GetEventEndTime(tab)
	if tab == EasterDayTab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventEasterDayView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_DAY)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventEasterDay) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventEasterDay)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventEasterDayView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventEasterDayView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventEasterDayView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end
