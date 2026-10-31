require "lua.client.core.network.event.eventBlossomDay.EventBlossomDayModel"
require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.UIEventBlossomDayLayout"

local pivotTab = U_Vector2(0.865, 0.5)

--- @class UIEventBlossomDayView : UIBaseView
UIEventBlossomDayView = Class(UIEventBlossomDayView, UIBaseView)

--- @param model UIEventBlossomDayModel
function UIEventBlossomDayView:Ctor(model)
	--- @type UIEventBlossomDayConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventBlossomDayLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventBlossomDayModel
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventBlossomDayModel
	self.model = model
end

function UIEventBlossomDayView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventBlossomDayView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventBlossomDayView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventBlossomDayLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventBlossomDayView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type BlossomDayTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(tab))
		obj:SetSelectState(self:_IsTabChosen(tab))
		obj:SetIcon(self:_GetEventIcon(tab))
		if tab == BlossomDayTab.LUCKY_WISH or tab == BlossomDayTab.QUEST then
			obj.config.icon.rectTransform.localScale = U_Vector3.one * 0.8
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
		--- @type BlossomDayTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(tab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param tab BlossomDayTab
function UIEventBlossomDayView:_IsTabChosen(tab)
	return self.layout ~= nil and self.layout.tab == tab
end

--- @param data {callbackClose : function}
function UIEventBlossomDayView:OnReadyShow(data)
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(BlossomDayTab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventBlossomDayView:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventBlossomDayView:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:TrackingSelectTab(tab)
	self:SelectTab(tab)
end

function UIEventBlossomDayView:TrackingSelectTab(tab)
	local tabName = nil
	if tab == BlossomDayTab.LUCKY_WISH then
		tabName = "blossom_day_lucky_wish"
	elseif tab == BlossomDayTab.SPECIAL_OFFER then
		tabName = "blossom_day_special_offer"
	elseif tab == BlossomDayTab.GOLDEN_TIME then
		tabName = "blossom_day_golden_time"
	elseif tab == BlossomDayTab.EXCHANGE then
		tabName = "blossom_day_exchange"
	elseif tab == BlossomDayTab.QUEST then
		tabName = "blossom_day_quest"
	elseif tab == BlossomDayTab.SHOP then
		tabName = "blossom_day_shop"
	else
		tabName = nil
		return nil
	end
	if tab ~= nil and tabName ~= nil then
		TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_BLOSSOM, tabName)
	end
end

--- @param tab BlossomDayTab
function UIEventBlossomDayView:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == BlossomDayTab.LUCKY_WISH then
			require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.lucky_wish.UIEventBlossomDayLuckyWishLayout"
			self.layout = UIEventBlossomDayLuckyWishLayout(self, tab, self.config.diceAnchor)
		elseif tab == BlossomDayTab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.specialOffer.UIEventBlossomDaySpecialOfferLayout"
			self.layout = UIEventBlossomDaySpecialOfferLayout(self, tab, self.config.specialAnchor)
		elseif tab == BlossomDayTab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.golden_time.UIEventBlossomDayGoldenTimeLayout"
			self.layout = UIEventBlossomDayGoldenTimeLayout(self, tab, self.config.goldenTimeAnchor)
		elseif tab == BlossomDayTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.exchange.UIEventBlossomDayExchangeLayout"
			self.layout = UIEventBlossomDayExchangeLayout(self, tab, self.config.exchangeAnchor)
		elseif tab == BlossomDayTab.QUEST then
			require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.quest.UIEventBlossomDayQuestLayout"
			self.layout = UIEventBlossomDayQuestLayout(self, tab, self.config.questAnchor)
		elseif tab == BlossomDayTab.SHOP then
			require "lua.client.scene.ui.home.uiEventBlossomDay.EventLayout.shop.UIEventBlossomDayShopLayout"
			self.layout = UIEventBlossomDayShopLayout(self, tab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. tab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventBlossomDayView:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventBlossomDayView:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_blossom_day_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("blossom_day_daily_checkin"),
			LanguageUtils.LocalizeCommon("blossom_day_wish_title"),
			LanguageUtils.LocalizeCommon("blossom_day_exchange_name"),
			LanguageUtils.LocalizeCommon("blossom_day_specialoffer"),
			LanguageUtils.LocalizeCommon("blossom_day_daily_packs"),
			LanguageUtils.LocalizeCommon("blossom_day_roll"),
			LanguageUtils.LocalizeCommon("blossom_day_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tab BlossomDayTab
function UIEventBlossomDayView:_GetEventName(tab)
	if tab == BlossomDayTab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_blossom_day_name")
	elseif tab == BlossomDayTab.LUCKY_WISH then
		return LanguageUtils.LocalizeCommon("blossom_day_wish_name")
	elseif tab == BlossomDayTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("blossom_day_exchange_name")
	elseif tab == BlossomDayTab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_blossom_day_specialoffer")
		--elseif BlossomDayTab == BlossomDayTab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif tab == BlossomDayTab.QUEST then
		return LanguageUtils.LocalizeCommon("blossom_day_quest")
	elseif tab == BlossomDayTab.SHOP then
		return LanguageUtils.LocalizeCommon("blossom_day_shop")
	else
		return LanguageUtils.LocalizeCommon("blossom_day_dice_title")
	end
end

--- @param tab BlossomDayTab
function UIEventBlossomDayView:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventBlossomDay(tab)
end

--- @param tab BlossomDayTab
function UIEventBlossomDayView:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventBlossomDayView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param tab BlossomDayTab
function UIEventBlossomDayView:UpdateNotificationByTab(tab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(tab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventBlossomDayView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEventHalloweenTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	--zg.playerData.remoteConfig.showedEventHalloweenTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	--zg.playerData:SaveRemoteConfig()
end

function UIEventBlossomDayView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventBlossomDayView:CheckAllNotificationTab()
	--- @param v BlossomDayTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventBlossomDayView:_GetEventEndTime(tab)
	if tab == BlossomDayTab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventBlossomDayView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventBlossomDay) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventBlossomDay)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventBlossomDayView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventBlossomDayView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventBlossomDayView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

