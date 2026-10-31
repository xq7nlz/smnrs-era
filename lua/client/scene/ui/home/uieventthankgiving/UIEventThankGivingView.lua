require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.UIEventThanksGivingLayout"
require "lua.client.core.network.event.eventThankGiving.EventThankGivingModel"
--- @class UIEventThankGivingView : UIBaseView
UIEventThankGivingView = Class(UIEventThankGivingView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventThankGivingModel
function UIEventThankGivingView:Ctor(model)
	--- @type UIEventThankGivingConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventThanksGivingLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventThankGivingModel
	self.eventModel = nil

	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventThankGivingModel
	self.model = model
end

function UIEventThankGivingView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventThankGivingView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventThanksGivingLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventThankGivingView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventThankGivingView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type HalloweenTab
		local thanksGivingTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(thanksGivingTab))
		obj:SetSelectState(self:_IsTabChosen(thanksGivingTab))
		obj:SetIcon(self:_GetEventIcon(thanksGivingTab))
		if thanksGivingTab == ThankGivingTab.DICE or thanksGivingTab == ThankGivingTab.QUEST then
			obj.config.icon.rectTransform.localScale = U_Vector3.one * 0.75
		end
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(thanksGivingTab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(thanksGivingTab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(thanksGivingTab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(thanksGivingTab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type HalloweenTab
		local thanksGivingTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(thanksGivingTab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param thanksGivingTab ThankGivingTab
function UIEventThankGivingView:_IsTabChosen(thanksGivingTab)
	return self.layout ~= nil and self.layout.halloweenTab == thanksGivingTab
end

function UIEventThankGivingView:OnReadyShow()
	self.isReloadingData = false
	self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_THANKS_GIVING)
	self:CheckResourceOnSeason()
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.model.listSubEvent:Count() > 0 then
		self:SelectTab(self.model.listSubEvent:Get(ThankGivingTab.GOLDEN_TIME))
		self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
		self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventThankGivingView:CheckResourceOnSeason()
	--local endTime = self.eventModel.timeData.endTime
	--local savedEndSeason = zg.playerData.remoteConfig.eventHalloweenEnd or endTime
	--if savedEndSeason ~= endTime then
	--	self:ClearMoneyType()
	--end
	--zg.playerData.remoteConfig.eventHalloweenEnd = endTime
	--zg.playerData:SaveRemoteConfig()
end

function UIEventThankGivingView:ClearMoneyType()
	local clearResource = function(moneyType)
		local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
		InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
	end
	clearResource(MoneyType.THANK_GIVING_DICE)
	clearResource(MoneyType.THANK_GIVING_PUMPKIN)
end
function UIEventThankGivingView:SelectTab(thanksGivingTab)
	self:GetLayout(thanksGivingTab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventThankGivingView:OnClickSelectTab(thanksGivingTab)
	if self:_IsTabChosen(thanksGivingTab) then
		return
	end
	self:SelectTab(thanksGivingTab)
end

--- @param thanksGivingTab ThankGivingTab
function UIEventThankGivingView:GetLayout(thanksGivingTab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(thanksGivingTab)
	if self.layout == nil then
		if thanksGivingTab == ThankGivingTab.DICE then
			require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventDice.UIEventThanksGivingDiceLayout"
			self.layout = UIEventThanksGivingDiceLayout(self, thanksGivingTab, self.config.diceAnchor)
		elseif thanksGivingTab == ThankGivingTab.SPECIAL_OFFER then
			require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventSpecialOffer.UIEventThanksGivingSpecialOfferLayout"
			self.layout = UIEventThanksGivingSpecialOfferLayout(self, thanksGivingTab, self.config.specialAnchor)
		elseif thanksGivingTab == ThankGivingTab.GOLDEN_TIME then
			require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventGoldenTime.UIEventThanksGivingGoldenTimeLayout"
			self.layout = UIEventThanksGivingGoldenTimeLayout(self, thanksGivingTab, self.config.goldenTimeAnchor)
		elseif thanksGivingTab == ThankGivingTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventExchange.UIEventThanksGivingExchangeLayout"
			self.layout = UIEventThanksGivingExchangeLayout(self, thanksGivingTab, self.config.exchangeAnchor)
			--elseif halloweenTab == HalloweenTab.DAILY_CHECK_IN then
			--    require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDailyCheckin.UIEventHalloweenDailyCheckInLayout"
			--    self.layout = UIEventHalloweenDailyCheckInLayout(self, halloweenTab, self.config.dailyCheckInAnchor)
		elseif thanksGivingTab == ThankGivingTab.QUEST then
			require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventQuest.UIEventThanksGivingQuestLayout"
			self.layout = UIEventThanksGivingQuestLayout(self, thanksGivingTab, self.config.questAnchor)
		elseif thanksGivingTab == ThankGivingTab.SHOP then
			require "lua.client.scene.ui.home.uiEventThankGiving.EventLayout.EventShop.UIEventThanksGivingShopLayout"
			self.layout = UIEventThanksGivingShopLayout(self, thanksGivingTab, self.config.shopAnchor)
		else

			XDebug.Error("Missing layout type " .. halloweenTab)
			return nil
		end
		self.layoutDict:Add(thanksGivingTab, self.layout)
	end
end

function UIEventThankGivingView:DisableCommon()
	self:HideCurrentLayout()
	self.config.goldenTimeAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.specialAnchor.gameObject:SetActive(false)
	self.config.dailyCheckInAnchor.gameObject:SetActive(false)
	self.config.diceAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.shopAnchor.gameObject:SetActive(false)
end

function UIEventThankGivingView:OnClickHelpInfo()
	--- @type string
	local content = LanguageUtils.LocalizeHelpInfo("event_thanks_giving_info")
	content = StringUtils.FormatLocalize(content, nil,
			LanguageUtils.LocalizeCommon("thanks_giving_daily_checkin"),
			LanguageUtils.LocalizeCommon("thanks_giving_dice_title"),
			LanguageUtils.LocalizeCommon("event_thanks_giving_exchange_name"),
			LanguageUtils.LocalizeCommon("event_thanks_giving_specialoffer"),
			LanguageUtils.LocalizeCommon("thanks_giving_daily_packs"),
			LanguageUtils.LocalizeCommon("thanks_giving_roll"),
			LanguageUtils.LocalizeCommon("thanks_giving_purchase_1"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param thanksGivingTab ThankGivingTab
function UIEventThankGivingView:_GetEventName(thanksGivingTab)
	if thanksGivingTab == ThankGivingTab.GOLDEN_TIME then
		return LanguageUtils.LocalizeCommon("event_golden_time_thanks_giving_name")
	elseif thanksGivingTab == ThankGivingTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("event_thanks_giving_exchange_name")
	elseif thanksGivingTab == ThankGivingTab.SPECIAL_OFFER then
		return LanguageUtils.LocalizeCommon("event_thanks_giving_specialoffer")
		--elseif halloweenTab == HalloweenTab.DAILY_CHECK_IN then
		--    return LanguageUtils.LocalizeCommon("halloween_daily_checkin")
	elseif thanksGivingTab == ThankGivingTab.QUEST then
		return LanguageUtils.LocalizeCommon("thanks_giving_quest")
	elseif thanksGivingTab == ThankGivingTab.SHOP then
		return LanguageUtils.LocalizeCommon("thanks_giving_shop")
	else
		return LanguageUtils.LocalizeCommon("thanks_giving_dice_title")
	end
end

--- @param thanksGivingTab ThankGivingTab
function UIEventThankGivingView:_GetEventIcon(thanksGivingTab)
	return ResourceLoadUtils.LoadEventThanksGiving(thanksGivingTab)
end

--- @param halloweenTab HalloweenTab
function UIEventThankGivingView:_GetEventNotification(halloweenTab)
	return self.eventModel:IsTabNotified(halloweenTab)
end

function UIEventThankGivingView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

--- @param halloweenTab HalloweenTab
function UIEventThankGivingView:UpdateNotificationByTab(halloweenTab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(halloweenTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventThankGivingView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEventHalloweenTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	--zg.playerData.remoteConfig.showedEventHalloweenTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	--zg.playerData:SaveRemoteConfig()
end

function UIEventThankGivingView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventThankGivingView:CheckAllNotificationTab()
	--- @param v HalloweenTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventThankGivingView:_GetEventEndTime(thankGivingTab)
	if thankGivingTab == ThankGivingTab.SPECIAL_OFFER then
		return self.eventModel.timeData.endTime - TimeUtils.SecondAMin * 10
	end
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventThankGivingView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type eventModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_THANKS_GIVING)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(UIPopupName.UIEventThankGiving) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UIEventThankGiving)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventThankGivingView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:HideCurrentLayout()
end

function UIEventThankGivingView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventThankGivingView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end