require "lua.client.core.network.event.eventLunarNewYear2024.EventLunarNewYear2024Model"
require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.UIEventLunarNewYear2024Layout"

local pivotTab = U_Vector2(0.865, 0.5)

--- @class UIEventLunarNewYear2024View : UIBaseView
UIEventLunarNewYear2024View = Class(UIEventLunarNewYear2024View, UIBaseView)

--- @param model UIEventLunarNewYear2024Model
function UIEventLunarNewYear2024View:Ctor(model)
	--- @type UIEventLunarNewYear2024Config
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventLunarNewYear2024Layout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventLunarNewYear2024Model
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventLunarNewYear2024Model
	self.model = model
end

function UIEventLunarNewYear2024View:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
	self:_InitScrollTab()
end

function UIEventLunarNewYear2024View:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventLunarNewYear2024View:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventThanksGivingLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventLunarNewYear2024View:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type LunarNewYear2024Tab
		local lunarNewYear2024Tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(lunarNewYear2024Tab))
		obj:SetSelectState(self:_IsTabChosen(lunarNewYear2024Tab))
		obj:SetIcon(self:_GetEventIcon(lunarNewYear2024Tab))
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(lunarNewYear2024Tab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(lunarNewYear2024Tab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(lunarNewYear2024Tab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(lunarNewYear2024Tab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type LunarNewYear2024Tab
		local lunarNewYear2024Tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(lunarNewYear2024Tab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param tab LunarNewYear2024Tab
function UIEventLunarNewYear2024View:_IsTabChosen(tab)
	return self.layout ~= nil and self.layout.tab == tab
end

--- @param data {callbackClose : function}
function UIEventLunarNewYear2024View:OnReadyShow(data)
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2024)
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(LunarNewYear2024Tab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventLunarNewYear2024View:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventLunarNewYear2024View:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:TrackingSelectTab(tab)
	self:SelectTab(tab)
end

function UIEventLunarNewYear2024View:TrackingSelectTab(tab)
	local tabName = nil
	if tab == LunarNewYear2024Tab.BINGO then
		tabName = "lunar_new_year_2024_bingo"
	elseif tab == LunarNewYear2024Tab.SPECIAL_OFFER then
		tabName = "lunar_new_year_2024_special_offer"
	elseif tab == LunarNewYear2024Tab.GOLDEN_TIME then
		tabName = "lunar_new_year_2024_golden_time"
	elseif tab == LunarNewYear2024Tab.EXCHANGE then
		tabName = "lunar_new_year_2024_exchange"
	elseif tab == LunarNewYear2024Tab.QUEST then
		tabName = "lunar_new_year_2024_quest"
	elseif tab == LunarNewYear2024Tab.SHOP then
		tabName = "lunar_new_year_2024_shop"
	else
		tabName = nil
		return nil
	end
	if tab ~= nil and tabName ~= nil then
		TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_LUNAR_NEW_YEAR_2024, tabName)
	end
end

--- @param tab LunarNewYear2024Tab
function UIEventLunarNewYear2024View:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == LunarNewYear2024Tab.BINGO then
			require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.bingo.UIEventLunarNewYear2024BingoLayout"
			self.layout = UIEventLunarNewYear2024BingoLayout(self, tab, self.config.diceAnchor)
		elseif tab == LunarNewYear2024Tab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.specialOffer.UIEventLunarNewYear2024SpecialOfferLayout"
			self.layout = UIEventLunarNewYear2024SpecialOfferLayout(self, tab, self.config.specialAnchor)
		elseif tab == LunarNewYear2024Tab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.goldenTime.UIEventLunarNewYear2024GoldenTimeLayout"
			self.layout = UIEventLunarNewYear2024GoldenTimeLayout(self, tab, self.config.goldenTimeAnchor)
		elseif tab == LunarNewYear2024Tab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.exchange.UIEventLunarNewYear2024ExchangeLayout"
			self.layout = UIEventLunarNewYear2024ExchangeLayout(self, tab, self.config.exchangeAnchor)
		elseif tab == LunarNewYear2024Tab.QUEST then
			require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.quest.UIEventLunarNewYear2024QuestLayout"
			self.layout = UIEventLunarNewYear2024QuestLayout(self, tab, self.config.questAnchor)
		elseif tab == LunarNewYear2024Tab.SHOP then
			require "lua.client.scene.ui.home.uiEventLunarNewYear2024.EventLayout.shop.UIEventLunarNewYear2024ShopLayout"
			self.layout = UIEventLunarNewYear2024ShopLayout(self, tab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. tab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventLunarNewYear2024View:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventLunarNewYear2024View:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_lunar_new_year_2024_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("new_lunar_year_2024_daily_checkin"),
			LanguageUtils.LocalizeCommon("new_lunar_year_2024_wish_title"),
			LanguageUtils.LocalizeCommon("new_lunar_year_2024_exchange_name"),
			LanguageUtils.LocalizeCommon("new_lunar_year_2024_specialoffer"),
			LanguageUtils.LocalizeCommon("new_lunar_year_2024_daily_packs"),
			LanguageUtils.LocalizeCommon("new_lunar_year_2024_roll"),
			LanguageUtils.LocalizeCommon("new_lunar_year_2024_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tab LunarNewYear2024Tab
function UIEventLunarNewYear2024View:_GetEventName(tab)
	if tab == LunarNewYear2024Tab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_lunar_new_year_2024_name")
	elseif tab == LunarNewYear2024Tab.BINGO then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_2024_bingo_name")
	elseif tab == LunarNewYear2024Tab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_2024_exchange_name")
	elseif tab == LunarNewYear2024Tab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_2024_specialoffer")
		--elseif LunarNewYear2024Tab == LunarNewYear2024Tab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif tab == LunarNewYear2024Tab.QUEST then
		return LanguageUtils.LocalizeCommon("lunar_new_year_2024_quest")
	elseif tab == LunarNewYear2024Tab.SHOP then
		return LanguageUtils.LocalizeCommon("lunar_new_year_2024_shop")
	else
		return LanguageUtils.LocalizeCommon("thanks_giving_dice_title")
	end
end

--- @param tab LunarNewYear2024Tab
function UIEventLunarNewYear2024View:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventLunarNewYear2024(tab)
end

--- @param tab LunarNewYear2024Tab
function UIEventLunarNewYear2024View:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventLunarNewYear2024View:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param tab LunarNewYear2024Tab
function UIEventLunarNewYear2024View:UpdateNotificationByTab(tab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(tab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventLunarNewYear2024View:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

function UIEventLunarNewYear2024View:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventLunarNewYear2024View:CheckAllNotificationTab()
	--- @param v LunarNewYear2024Tab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventLunarNewYear2024View:_GetEventEndTime(tab)
	if tab == LunarNewYear2024Tab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventLunarNewYear2024View:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2024)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventLunarNewYear2024) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventLunarNewYear2024)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventLunarNewYear2024View:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventLunarNewYear2024View:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventLunarNewYear2024View:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

