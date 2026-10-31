require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.UIEventChristmasLayout"

--- @class UIEventChristmasView : UIBaseView
UIEventChristmasView = Class(UIEventChristmasView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventChristmasModel
function UIEventChristmasView:Ctor(model)
	--- @type UIEventChristmasConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventChristmasLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventChristmasModel
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventChristmasModel
	self.model = model
end

function UIEventChristmasView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
	self:_InitScrollTab()
end

function UIEventChristmasView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventChristmasLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventChristmasView:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventChristmasView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type ChristmasTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		if tab == ChristmasTab.EXCHANGE then
			obj.config.icon.rectTransform.localPosition = U_Vector3(-93,15)
		end
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
		--- @type ChristmasTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(tab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param tab ChristmasTab
function UIEventChristmasView:_IsTabChosen(tab)
	return self.layout ~= nil and self.layout.tab == tab
end

function UIEventChristmasView:OnReadyShow()
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(1))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventChristmasView:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventChristmasView:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:TrackingSelectTab(tab)
	self:SelectTab(tab)
end

--- @param tab ChristmasTab
function UIEventChristmasView:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == ChristmasTab.ARENA then
			require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.christmasArena.UIChristmasArenaLayout"
			self.layout = UIChristmasArenaLayout(self, tab, self.config.midAutumnArena)
		elseif tab == ChristmasTab.FEED_BEAST then
			require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.feed.UIEventChristmasFeedLayout"
			self.layout = UIEventChristmasFeedLayout(self, tab, self.config.feedBeastAnchor)
		elseif tab == ChristmasTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.exchange.UIEventExchangeChristmasLayout"
			self.layout = UIEventExchangeChristmasLayout(self, tab, self.config.exchangeAnchor)
		elseif tab == ChristmasTab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.specialOffer.UIEventSpecialOfferChristmasLayout"
			self.layout = UIEventSpecialOfferChristmasLayout(self, tab, self.config.specialOfferAnchor)
		elseif tab == ChristmasTab.QUEST then
			require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.quest.UIChristmasQuestLayout"
			self.layout = UIChristmasQuestLayout(self, tab, self.config.festivalQuestAnchor)
		elseif tab == ChristmasTab.FESTIVAL_MARKET then
			require "lua.client.scene.ui.home.uiEventChristmas.eventLayout.market.UIChristmasMarketLayout"
			self.layout = UIChristmasMarketLayout(self, tab, self.config.festivalMarketAnchor)
		else
			XDebug.Error("Missing layout type " .. tab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventChristmasView:TrackingSelectTab(tab)
	local tabName = nil
	if tab == ChristmasTab.ARENA then
		tabName = "christmas_arena"
	elseif tab == ChristmasTab.FEED_BEAST then
		tabName = "christmas_blessing"
	elseif tab == ChristmasTab.EXCHANGE then
		tabName = "christmas_exchange"
	elseif tab == ChristmasTab.SPECIAL_OFFER then
		tabName = "christmas_special_offer"
	elseif tab == ChristmasTab.QUEST then
		tabName = "christmas_quest"
	elseif tab == ChristmasTab.FESTIVAL_MARKET then
		tabName = "christmas_shop"
	else
		tabName = nil
		return nil
	end
	if tab ~= nil and tabName ~= nil then
		TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_CHRISTMAS, tabName)
	end
end

function UIEventChristmasView:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.feedBeastAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialOfferAnchor.gameObject:SetActive(false)
	self.config.gemBoxAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.festivalMarketAnchor.gameObject:SetActive(false)
	self.config.festivalQuestAnchor.gameObject:SetActive(false)
	self.config.midAutumnArena.gameObject:SetActive(false)
end

function UIEventChristmasView:OnClickHelpInfo()
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_christmas_info"))
end

--- @param tab ChristmasTab
function UIEventChristmasView:_GetEventName(tab)
	if tab == ChristmasTab.FEED_BEAST then
		return LanguageUtils.LocalizeCommon("event_christmas_feed_name")
	elseif tab == ChristmasTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_christmas_exchange_name")
	elseif tab == ChristmasTab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_christmas_specialoffer")
	elseif tab == ChristmasTab.FESTIVAL_MARKET then
		return LanguageUtils.LocalizeCommon("event_christmas_market_title")
	elseif tab == ChristmasTab.QUEST then
		return LanguageUtils.LocalizeCommon("event_christmas_quest_title")
	elseif tab == ChristmasTab.ARENA then
		return LanguageUtils.LocalizeCommon("event_christmas_arena_title")
	end
end

--- @param tab ChristmasTab
function UIEventChristmasView:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventChristmas(tab)
end

--- @param tab ChristmasTab
function UIEventChristmasView:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventChristmasView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param tab ChristmasTab
function UIEventChristmasView:UpdateNotificationByTab(tab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(tab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventChristmasView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEventAutumnTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	zg.playerData.remoteConfig.showedEventAutumnTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	zg.playerData:SaveRemoteConfig()
end

function UIEventChristmasView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventChristmasView:CheckAllNotificationTab()
	--- @param v MidAutumnTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventChristmasView:_GetEventEndTime(tab)
	if tab == ChristmasTab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventChristmasView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			self:HideCurrentLayout()
			self:RemoveListener()
			self:OnReadyShow()
		end, true)
	end
end

function UIEventChristmasView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventChristmasView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventChristmasView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end
