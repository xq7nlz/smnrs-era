require "lua.client.core.network.event.eventMayDay.EventMayDayModel"
require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.UIEventMayDayLayout"

local pivotTab = U_Vector2(0.865, 0.5)

--- @class UIEventMayDayView : UIBaseView
UIEventMayDayView = Class(UIEventMayDayView, UIBaseView)

--- @param model UIEventMayDayModel
function UIEventMayDayView:Ctor(model)
	--- @type UIEventMayDayConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventMayDayLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventMayDayModel
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventMayDayModel
	self.model = model
end

function UIEventMayDayView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
	self:_InitScrollTab()
end

function UIEventMayDayView:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventMayDayView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventThanksGivingLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventMayDayView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type MayDayTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(tab))
		obj:SetSelectState(self:_IsTabChosen(tab))
		obj:SetIcon(self:_GetEventIcon(tab))
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
		--- @type MayDayTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(tab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param tab MayDayTab
function UIEventMayDayView:_IsTabChosen(tab)
	return self.layout ~= nil and self.layout.tab == tab
end

--- @param data {callbackClose : function}
function UIEventMayDayView:OnReadyShow(data)
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MAY_DAY)
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(MayDayTab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventMayDayView:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventMayDayView:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:TrackingSelectTab(tab)
	self:SelectTab(tab)
end

function UIEventMayDayView:TrackingSelectTab(tab)
	local tabName = nil
	if tab == MayDayTab.BINGO then
		tabName = "may_day_bingo"
	elseif tab == MayDayTab.SPECIAL_OFFER then
		tabName = "may_day_special_offer"
	elseif tab == MayDayTab.GOLDEN_TIME then
		tabName = "may_day_golden_time"
	elseif tab == MayDayTab.EXCHANGE then
		tabName = "may_day_exchange"
	elseif tab == MayDayTab.QUEST then
		tabName = "may_day_quest"
	elseif tab == MayDayTab.SHOP then
		tabName = "may_day_shop"
	else
		tabName = nil
		return nil
	end
	if tab ~= nil and tabName ~= nil then
		TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_MAY_DAY, tabName)
	end
end

--- @param tab MayDayTab
function UIEventMayDayView:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == MayDayTab.BINGO then
			require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.bingo.UIEventMayDayBingoLayout"
			self.layout = UIEventMayDayBingoLayout(self, tab, self.config.diceAnchor)
		elseif tab == MayDayTab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.specialOffer.UIEventMayDaySpecialOfferLayout"
			self.layout = UIEventMayDaySpecialOfferLayout(self, tab, self.config.specialAnchor)
		elseif tab == MayDayTab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.golden_time.UIEventMayDayGoldenTimeLayout"
			self.layout = UIEventMayDayGoldenTimeLayout(self, tab, self.config.goldenTimeAnchor)
		elseif tab == MayDayTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.exchange.UIEventMayDayExchangeLayout"
			self.layout = UIEventMayDayExchangeLayout(self, tab, self.config.exchangeAnchor)
		elseif tab == MayDayTab.QUEST then
			require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.quest.UIEventMayDayQuestLayout"
			self.layout = UIEventMayDayQuestLayout(self, tab, self.config.questAnchor)
		elseif tab == MayDayTab.SHOP then
			require "lua.client.scene.ui.home.uiEventMayDay.EventLayout.shop.UIEventMayDayShopLayout"
			self.layout = UIEventMayDayShopLayout(self, tab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. tab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventMayDayView:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventMayDayView:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_may_day_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("may_day_daily_checkin"),
			LanguageUtils.LocalizeCommon("may_day_wish_title"),
			LanguageUtils.LocalizeCommon("may_day_exchange_name"),
			LanguageUtils.LocalizeCommon("may_day_specialoffer"),
			LanguageUtils.LocalizeCommon("may_day_daily_packs"),
			LanguageUtils.LocalizeCommon("may_day_roll"),
			LanguageUtils.LocalizeCommon("may_day_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tab MayDayTab
function UIEventMayDayView:_GetEventName(tab)
	if tab == MayDayTab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_may_day_name")
	elseif tab == MayDayTab.BINGO then
		return LanguageUtils.LocalizeCommon("event_may_day_bingo_name")
	elseif tab == MayDayTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_may_day_exchange_name")
	elseif tab == MayDayTab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_may_day_specialoffer")
		--elseif MayDayTab == MayDayTab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif tab == MayDayTab.QUEST then
		return LanguageUtils.LocalizeCommon("may_day_quest")
	elseif tab == MayDayTab.SHOP then
		return LanguageUtils.LocalizeCommon("may_day_shop")
	else
		return LanguageUtils.LocalizeCommon("thanks_giving_dice_title")
	end
end

--- @param tab MayDayTab
function UIEventMayDayView:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventMayDay(tab)
end

--- @param tab MayDayTab
function UIEventMayDayView:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventMayDayView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param tab MayDayTab
function UIEventMayDayView:UpdateNotificationByTab(tab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(tab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventMayDayView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

function UIEventMayDayView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventMayDayView:CheckAllNotificationTab()
	--- @param v MayDayTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventMayDayView:_GetEventEndTime(tab)
	if tab == MayDayTab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventMayDayView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MAY_DAY)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventMayDay) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventMayDay)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventMayDayView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventMayDayView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventMayDayView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

