require "lua.client.core.network.event.eventQixi.EventQixiFestivalModel"
require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.UIEventQixiFestivalLayout"

local pivotTab = U_Vector2(0.865, 0.5)

--- @class UIEventQixiFestivalView : UIBaseView
UIEventQixiFestivalView = Class(UIEventQixiFestivalView, UIBaseView)

--- @param model UIEventQixiFestivalModel
function UIEventQixiFestivalView:Ctor(model)
	--- @type UIEventQixiFestivalConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventQixiFestivalLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventQixiFestivalModel
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventQixiFestivalModel
	self.model = model
end

function UIEventQixiFestivalView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventQixiFestivalView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventQixiFestivalView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventQixiFestivalLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventQixiFestivalView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type QixiFestivalTab
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
		--- @type QixiFestivalTab
		local tab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(tab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param tab QixiFestivalTab
function UIEventQixiFestivalView:_IsTabChosen(tab)
	return self.layout ~= nil and self.layout.tab == tab
end

--- @param data {callbackClose : function}
function UIEventQixiFestivalView:OnReadyShow(data)
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(QixiFestivalTab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventQixiFestivalView:SelectTab(tab)
	self:GetLayout(tab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventQixiFestivalView:OnClickSelectTab(tab)
	if self:_IsTabChosen(tab) then
		return
	end
	self:TrackingSelectTab(tab)
	self:SelectTab(tab)
end

function UIEventQixiFestivalView:TrackingSelectTab(tab)
	local tabName = nil
	if tab == QixiFestivalTab.LUCKY_WISH then
		tabName = "qixi_festival_lucky_wish"
	elseif tab == QixiFestivalTab.SPECIAL_OFFER then
		tabName = "qixi_festival_special_offer"
	elseif tab == QixiFestivalTab.GOLDEN_TIME then
		tabName = "qixi_festival_golden_time"
	elseif tab == QixiFestivalTab.EXCHANGE then
		tabName = "qixi_festival_exchange"
	elseif tab == QixiFestivalTab.QUEST then
		tabName = "qixi_festival_quest"
	elseif tab == QixiFestivalTab.SHOP then
		tabName = "qixi_festival_shop"
	else
		tabName = nil
		return nil
	end
	if tab ~= nil and tabName ~= nil then
		TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_QIXI_FESTIVAL, tabName)
	end
end

--- @param tab QixiFestivalTab
function UIEventQixiFestivalView:GetLayout(tab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(tab)
	if self.layout == nil then
		if tab == QixiFestivalTab.LUCKY_WISH then
			require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.luckyWish.UIEventQixiFestivalLuckyWishLayout"
			self.layout = UIEventQixiFestivalLuckyWishLayout(self, tab, self.config.diceAnchor)
		elseif tab == QixiFestivalTab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.specialOffer.UIEventQixiFestivalSpecialOfferLayout"
			self.layout = UIEventQixiFestivalSpecialOfferLayout(self, tab, self.config.specialAnchor)
		elseif tab == QixiFestivalTab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.golden_time.UIEventQixiFestivalGoldenTimeLayout"
			self.layout = UIEventQixiFestivalGoldenTimeLayout(self, tab, self.config.goldenTimeAnchor)
		elseif tab == QixiFestivalTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.exchange.UIEventQixiFestivalExchangeLayout"
			self.layout = UIEventQixiFestivalExchangeLayout(self, tab, self.config.exchangeAnchor)
		elseif tab == QixiFestivalTab.QUEST then
			require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.quest.UIEventQixiFestivalQuestLayout"
			self.layout = UIEventQixiFestivalQuestLayout(self, tab, self.config.questAnchor)
		elseif tab == QixiFestivalTab.SHOP then
			require "lua.client.scene.ui.home.uiEventQixiFestival.EventLayout.shop.UIEventQixiFestivalShopLayout"
			self.layout = UIEventQixiFestivalShopLayout(self, tab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. tab)
			return nil
		end
		self.layoutDict:Add(tab, self.layout)
	end
end

function UIEventQixiFestivalView:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventQixiFestivalView:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_qixi_festival_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("qixi_festival_daily_checkin"),
			LanguageUtils.LocalizeCommon("qixi_festival_wish_title"),
			LanguageUtils.LocalizeCommon("qixi_festival_exchange_name"),
			LanguageUtils.LocalizeCommon("qixi_festival_specialoffer"),
			LanguageUtils.LocalizeCommon("qixi_festival_daily_packs"),
			LanguageUtils.LocalizeCommon("qixi_festival_roll"),
			LanguageUtils.LocalizeCommon("qixi_festival_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tab QixiFestivalTab
function UIEventQixiFestivalView:_GetEventName(tab)
	if tab == QixiFestivalTab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_qixi_festival_name")
	elseif tab == QixiFestivalTab.LUCKY_WISH then
		return LanguageUtils.LocalizeCommon("event_qixi_festival_wish_name")
	elseif tab == QixiFestivalTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_qixi_festival_exchange_name")
	elseif tab == QixiFestivalTab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_qixi_festival_specialoffer")
		--elseif QixiFestivalTab == QixiFestivalTab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif tab == QixiFestivalTab.QUEST then
		return LanguageUtils.LocalizeCommon("qixi_festival_quest")
	elseif tab == QixiFestivalTab.SHOP then
		return LanguageUtils.LocalizeCommon("qixi_festival_shop")
	else
		return LanguageUtils.LocalizeCommon("qixi_festival_dice_title")
	end
end

--- @param tab QixiFestivalTab
function UIEventQixiFestivalView:_GetEventIcon(tab)
	return ResourceLoadUtils.LoadEventQixiFestival(tab)
end

--- @param tab QixiFestivalTab
function UIEventQixiFestivalView:_GetEventNotification(tab)
	return self.eventModel:IsTabNotified(tab)
end

function UIEventQixiFestivalView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param QixiFestivalTab QixiFestivalTab
function UIEventQixiFestivalView:UpdateNotificationByTab(QixiFestivalTab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(QixiFestivalTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventQixiFestivalView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEventHalloweenTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	--zg.playerData.remoteConfig.showedEventHalloweenTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	--zg.playerData:SaveRemoteConfig()
end

function UIEventQixiFestivalView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventQixiFestivalView:CheckAllNotificationTab()
	--- @param v QixiFestivalTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventQixiFestivalView:_GetEventEndTime(tab)
	if tab == QixiFestivalTab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventQixiFestivalView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventQixiFestival) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventQixiFestival)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventQixiFestivalView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventQixiFestivalView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventQixiFestivalView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end
