require "lua.client.scene.ui.home.uiEventZodiac.layout.UIEventZodiacLayout"

--- @class UIEventZodiacView : UIBaseView
UIEventZodiacView = Class(UIEventZodiacView, UIBaseView)

--- @param model UIEventZodiacModel
function UIEventZodiacView:Ctor(model)
	--- @type UIEventZodiacConfig
	self.config = nil
	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventZodiacLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventZodiacModel
	self.eventModel = nil
	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_ZODIAC
	--- @type boolean
	self.isReloadingData = nil

	UIBaseView.Ctor(self, model)
	--- @type UIEventZodiacModel
	self.model = model
end

function UIEventZodiacView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
	self:InitUpdateTime()
end

function UIEventZodiacView:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventZodiacView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("title_event_zodiac")
	if self.layoutDict ~= nil then
		--- @param v UIEventZodiacLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventZodiacView:InitEventButtons()
	for zodiacTab = 1, self.model.listSubEvent:Count() do
		local eventButton = self.config.listEventButtons.transform:GetChild(zodiacTab - 1)
		--- @type UIEventSubButtonItem
		local eventSubButtonItem = UIEventSubButtonItem(eventButton)
		eventSubButtonItem:SetConfig(eventButton)

		eventSubButtonItem:SetText(self:_GetEventName(zodiacTab))
		eventSubButtonItem:SetNotificationFunction(function()
			return self:_GetEventNotification(zodiacTab)
		end)
		eventSubButtonItem:AddOnSelectListener(function()
			self:OnClickSelectTab(zodiacTab)
		end)
		self.eventTabDict:Add(zodiacTab, eventSubButtonItem)
	end
end

function UIEventZodiacView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	if self.layout ~= nil and self.layout.config.gameObject.activeInHierarchy then
		self:HideCurrentLayout()
		return
	end
	self:OnReadyHide()
	--zg.playerData.remoteConfig.showedEvenZodiacTime = zg.timeMgr:GetServerTime() + TimeUtils.SecondAMin * 10
	zg.playerData.remoteConfig.showedEvenZodiacTime = TimeUtils.GetTimeStartDayFromSec(zg.timeMgr:GetServerTime()) + TimeUtils.SecondADay
	zg.playerData:SaveRemoteConfig()
end

function UIEventZodiacView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

--- @param data {callbackClose : function}
function UIEventZodiacView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.isReloadingData = false
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	self.isOpen = self.eventModel:IsOpening()
	if self.isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	self.model:InitListSubEvent(self.eventModel.timeData)
	self:SetEndEventTime(self:_GetEventEndTime(), function()
		self:_OnEventTimeEnded()
	end)
	self:InitEventButtons()
end

function UIEventZodiacView:SelectTab(eventZodiacTab)
	self:CheckAllNotificationTab()
	self:GetLayout(eventZodiacTab)
	self.layout:OnShow(self)
	self.config.backGroundCover:SetActive(true)
end

function UIEventZodiacView:OnClickSelectTab(eventZodiacTab)
	self:SelectTab(eventZodiacTab)
end

--- @param eventZodiacTab EventZodiacTab
function UIEventZodiacView:GetLayout(eventZodiacTab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(eventZodiacTab)
	if self.layout == nil then
		if eventZodiacTab == EventZodiacTab.BUNDLE then
			require "lua.client.scene.ui.home.uiEventZodiac.layout.bundle.UIEventZodiacMultiBundleLayout"
			self.layout = UIEventZodiacMultiBundleLayout(self, eventZodiacTab, self.config.bundleAnchor)
		elseif eventZodiacTab == EventZodiacTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventZodiac.layout.exchange.UIEventZodiacExchangeLayout"
			self.layout = UIEventZodiacExchangeLayout(self, eventZodiacTab, self.config.exchangeAnchor)
		elseif eventZodiacTab == EventZodiacTab.QUEST then
			require "lua.client.scene.ui.home.uiEventZodiac.layout.quest.UIEventZodiacQuestLayout"
			self.layout = UIEventZodiacQuestLayout(self, eventZodiacTab, self.config.questAnchor)
		elseif eventZodiacTab == EventZodiacTab.CONSTELLATIONS then
			require "lua.client.scene.ui.home.uiEventZodiac.layout.constellation.UIEventZodiacConstellationLayout"
			self.layout = UIEventZodiacConstellationLayout(self, eventZodiacTab, self.config.constellationAnchor)
		else
			return nil
		end
		self.layoutDict:Add(eventZodiacTab, self.layout)
	end
end

function UIEventZodiacView:DisableCommon()
	self:HideCurrentLayout()
end

function UIEventZodiacView:OnClickHelpInfo()
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_zodiac_info"))
end

--- @param eventZodiacTab EventZodiacTab
function UIEventZodiacView:_GetEventName(eventZodiacTab)
	if eventZodiacTab == EventZodiacTab.CONSTELLATIONS then
		return LanguageUtils.LocalizeCommon("zodiac_constellations")
	elseif eventZodiacTab == EventZodiacTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("zodiac_exchange")
	elseif eventZodiacTab == EventZodiacTab.QUEST then
		return LanguageUtils.LocalizeCommon("zodiac_quest")
	elseif eventZodiacTab == EventZodiacTab.BUNDLE then
		return LanguageUtils.LocalizeCommon("zodiac_bundle")
	else
		return LanguageUtils.LocalizeCommon("disband")
	end
end

--- @param eventZodiacTab EventZodiacTab
function UIEventZodiacView:_GetEventNotification(eventZodiacTab)
	return self.eventModel:IsTabNotified(eventZodiacTab)
end

function UIEventZodiacView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

--- @param eventZodiacTab EventZodiacTab
function UIEventZodiacView:UpdateNotificationByTab(eventZodiacTab)
	--- @type UIEventSubButtonItem
	local objTab = self.eventTabDict:Get(eventZodiacTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventZodiacView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventZodiacView:CheckAllNotificationTab()
	--- @param v EventZodiacTab
	--- @param v UIEventSubButtonItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventZodiacView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventZodiacModel
			local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
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

function UIEventZodiacView:Hide()
	UIBaseView.Hide(self)

	self:RemoveListener()
	self:RemoveUpdateTime()

	self:HideCurrentLayout()
end

function UIEventZodiacView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventZodiacView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

function UIEventZodiacView:_GetEventEndTime()
	return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventZodiacView:SetEndEventTime(endTime, onEventTimeEnded)
	self.endTime = endTime
	self.onEventTimeEnded = onEventTimeEnded
	self:StartUpdateTime()
end

function UIEventZodiacView:StartUpdateTime()
	zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventZodiacView:RemoveUpdateTime()
	zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventZodiacView:SetTimeRefresh()
	self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventZodiacView:InitUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			self:SetTimeRefresh()
		else
			self.timeRefresh = self.timeRefresh - 1
		end
		self.config.textEventTime.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_end_in"),
				UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
		if self.timeRefresh <= 0 then
			self:RemoveUpdateTime()
			if self.onEventTimeEnded then
				self.onEventTimeEnded()
			end
		end
	end
end