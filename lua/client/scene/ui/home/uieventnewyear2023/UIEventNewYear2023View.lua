require "lua.client.core.network.event.eventNewYear2023.EventNewYear2023Model"
require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.UIEventNewYear2023Layout"

local pivotTab = U_Vector2(0.865, 0.5)

--- @class UIEventNewYear2023View : UIBaseView
UIEventNewYear2023View = Class(UIEventNewYear2023View, UIBaseView)

--- @param model UIEventNewYear2023Model
function UIEventNewYear2023View:Ctor(model)
	--- @type UIEventNewYear2023Config
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventNewYear2023Layout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventNewYear2023Model
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventNewYear2023Model
	self.model = model
end

function UIEventNewYear2023View:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventNewYear2023View:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventNewYear2023View:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventThanksGivingLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventNewYear2023View:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type HalloweenTab
		local newYear2023Tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(newYear2023Tab))
		obj:SetSelectState(self:_IsTabChosen(newYear2023Tab))
		obj:SetIcon(self:_GetEventIcon(newYear2023Tab))
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(newYear2023Tab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(newYear2023Tab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(newYear2023Tab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(newYear2023Tab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type HalloweenTab
		local newYear2023Tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(newYear2023Tab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param tab NewYear2023Tab
function UIEventNewYear2023View:_IsTabChosen(tab)
	return self.layout ~= nil and self.layout.tab == tab
end

--- @param data {callbackClose : function}
function UIEventNewYear2023View:OnReadyShow(data)
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(NewYear2023Tab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventNewYear2023View:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventNewYear2023View:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:TrackingSelectTab(tab)
	self:SelectTab(tab)
end

function UIEventNewYear2023View:TrackingSelectTab(tab)
	local tabName = nil
	if tab == NewYear2023Tab.LUCKY_WISH then
		tabName = "new_year_2023_lucky_wish"
	elseif tab == NewYear2023Tab.SPECIAL_OFFER then
		tabName = "new_year_2023_special_offer"
	elseif tab == NewYear2023Tab.GOLDEN_TIME then
		tabName = "new_year_2023_golden_time"
	elseif tab == NewYear2023Tab.EXCHANGE then
		tabName = "new_year_2023_exchange"
	elseif tab == NewYear2023Tab.QUEST then
		tabName = "new_year_2023_quest"
	elseif tab == NewYear2023Tab.SHOP then
		tabName = "new_year_2023_shop"
	else
		tabName = nil
		return nil
	end
	if tab ~= nil and tabName ~= nil then
		TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_NEW_YEAR_2023, tabName)
	end
end

--- @param tab NewYear2023Tab
function UIEventNewYear2023View:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == NewYear2023Tab.LUCKY_WISH then
			require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.luckyWish.UIEventNewYear2023LuckyWishLayout"
			self.layout = UIEventNewYear2023LuckyWishLayout(self, tab, self.config.diceAnchor)
		elseif tab == NewYear2023Tab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.specialOffer.UIEventNewYear2023SpecialOfferLayout"
			self.layout = UIEventNewYear2023SpecialOfferLayout(self, tab, self.config.specialAnchor)
		elseif tab == NewYear2023Tab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.golden_time.UIEventNewYear2023GoldenTimeLayout"
			self.layout = UIEventNewYear2023GoldenTimeLayout(self, tab, self.config.goldenTimeAnchor)
		elseif tab == NewYear2023Tab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.exchange.UIEventNewYear2023ExchangeLayout"
			self.layout = UIEventNewYear2023ExchangeLayout(self, tab, self.config.exchangeAnchor)
		elseif tab == NewYear2023Tab.QUEST then
			require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.quest.UIEventNewYear2023QuestLayout"
			self.layout = UIEventNewYear2023QuestLayout(self, tab, self.config.questAnchor)
		elseif tab == NewYear2023Tab.SHOP then
			require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.shop.UIEventNewYear2023ShopLayout"
			self.layout = UIEventNewYear2023ShopLayout(self, tab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. tab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventNewYear2023View:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventNewYear2023View:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_new_year_2023_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("new_year_2023_daily_checkin"),
			LanguageUtils.LocalizeCommon("new_year_2023_wish_title"),
			LanguageUtils.LocalizeCommon("new_year_2023_exchange_name"),
			LanguageUtils.LocalizeCommon("new_year_2023_specialoffer"),
			LanguageUtils.LocalizeCommon("new_year_2023_daily_packs"),
			LanguageUtils.LocalizeCommon("new_year_2023_roll"),
			LanguageUtils.LocalizeCommon("new_year_2023_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tab NewYear2023Tab
function UIEventNewYear2023View:_GetEventName(tab)
	if tab == NewYear2023Tab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_new_year_2023_name")
	elseif tab == NewYear2023Tab.LUCKY_WISH then
		return LanguageUtils.LocalizeCommon("event_new_year_2023_wish_name")
	elseif tab == NewYear2023Tab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_new_year_2023_exchange_name")
	elseif tab == NewYear2023Tab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_new_year_2023_specialoffer")
		--elseif halloweenTab == HalloweenTab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif tab == NewYear2023Tab.QUEST then
		return LanguageUtils.LocalizeCommon("new_year_2023_quest")
	elseif tab == NewYear2023Tab.SHOP then
		return LanguageUtils.LocalizeCommon("new_year_2023_shop")
	else
		return LanguageUtils.LocalizeCommon("thanks_giving_dice_title")
	end
end

--- @param tab NewYear2023Tab
function UIEventNewYear2023View:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventNewYear2023(tab)
end

--- @param tab NewYear2023Tab
function UIEventNewYear2023View:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventNewYear2023View:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param halloweenTab HalloweenTab
function UIEventNewYear2023View:UpdateNotificationByTab(halloweenTab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(halloweenTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventNewYear2023View:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEventHalloweenTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	--zg.playerData.remoteConfig.showedEventHalloweenTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	--zg.playerData:SaveRemoteConfig()
end

function UIEventNewYear2023View:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventNewYear2023View:CheckAllNotificationTab()
	--- @param v HalloweenTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventNewYear2023View:_GetEventEndTime(tab)
	if tab == NewYear2023Tab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventNewYear2023View:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventNewYear2023) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventNewYear2023)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventNewYear2023View:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventNewYear2023View:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventNewYear2023View:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end
