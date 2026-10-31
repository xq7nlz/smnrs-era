require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.UIEventKazetsuLayout"

--- @class UIEventKazetsuView : UIBaseView
UIEventKazetsuView = Class(UIEventKazetsuView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

function UIEventKazetsuView:Ctor(model)
	--- @type UIEventKazetsuConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventNewYearLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventKazetsuModel
	self.eventModel = nil

	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_KAZETSU
	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventKazetsuModel
	self.model = model
end

function UIEventKazetsuView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventKazetsuView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventNewYearLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventKazetsuView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.help.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventKazetsuView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EventKazetsuTab
		local eventKazetsuTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(eventKazetsuTab))
		obj:SetSelectState(self:_IsTabChosen(eventKazetsuTab))
		obj:SetIcon(self:_GetEventIcon(eventKazetsuTab))
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(eventKazetsuTab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(eventKazetsuTab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(eventKazetsuTab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(eventKazetsuTab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EventKazetsuTab
		local eventKazetsuTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(eventKazetsuTab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.scrollTabContent, UIPoolType.EventPackageTabItem,
			onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param eventKazetsuTab EventKazetsuTab
function UIEventKazetsuView:_IsTabChosen(eventKazetsuTab)
	return self.layout ~= nil and self.layout.eventKazetsuTab == eventKazetsuTab
end

function UIEventKazetsuView:OnReadyShow(result)
	self.isReloadingData = false
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	self.isOpen = self.eventModel:IsOpening()
	if self.isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	self:CheckEndSeasonDisplay()
	self:CheckResourceOnSeason()
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.isOpen then
		if self.model.listSubEvent:Count() > 0 then
			if result ~= nil and result.tab ~= nil then
				self:OnClickSelectTab(result.tab)
			else
			self:SelectTab(self.model.listSubEvent:Get(1))
			end
			self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
			self:CheckAllNotificationTab()
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			self:OnReadyHide()
		end
	else
		self:SelectTab(self.model.listSubEvent:Get(1))
	end
end

function UIEventKazetsuView:CheckEndSeasonDisplay()
	--self.config.VerticalScrollTab.gameObject:SetActive(self.isOpen)
end

function UIEventKazetsuView:CheckResourceOnSeason()
	local endTime = self.eventModel.timeData.endTime
	local savedEndSeason = zg.playerData.remoteConfig.eventLunarNewYearEnd or endTime
	if savedEndSeason ~= endTime then
		self:ClearMoneyType()
	end
	zg.playerData.remoteConfig.eventLunarNewYearEnd = endTime
	zg.playerData:SaveRemoteConfig()
end

function UIEventKazetsuView:ClearMoneyType()
	local clearResource = function(moneyType)
		local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
		InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
	end
end

function UIEventKazetsuView:SelectTab(eventKazetsuTab)
	--- Set default state for button
	self.config.help.gameObject:SetActive(true)

	--- UIKazetsuTrailLayout already have help information button
	if eventKazetsuTab == EventKazetsuTab.TRIAL then
		self.config.help.gameObject:SetActive(false)
	end
	self:GetLayout(eventKazetsuTab)
	self.layout:OnShow()
	self:CheckAllNotificationTab()
	self.scrollLoopTab:RefreshCells()
end

function UIEventKazetsuView:OnClickSelectTab(eventKazetsuTab)
	if self:_IsTabChosen(eventKazetsuTab) then
		return
	end
	self:SelectTab(eventKazetsuTab)
end

--- @param eventKazetsuTab EventKazetsuTab
function UIEventKazetsuView:GetLayout(eventKazetsuTab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(eventKazetsuTab)
	if self.layout == nil then
		if eventKazetsuTab == EventKazetsuTab.CHECK_IN then
			require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.EventDailyLogin.UIKazetsuLoginLayout"
			self.layout = UIKazetsuLoginLayout(self, eventKazetsuTab, self.config.login)
		elseif eventKazetsuTab == EventKazetsuTab.BUNDLE then
			require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.bundle.UIKazetsuBundleLayout"
			self.layout = UIKazetsuBundleLayout(self, eventKazetsuTab, self.config.bundle)
		elseif eventKazetsuTab == EventKazetsuTab.GIFT then
			require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuGift.UIKazetsuGiftLayout"
			self.layout = UIKazetsuGiftLayout(self, eventKazetsuTab, self.config.gift)
		elseif eventKazetsuTab == EventKazetsuTab.BOSS then
			require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuBoss.UIKazetsuBossLayout"
			self.layout = UIKazetsuBossLayout(self, eventKazetsuTab, self.config.boss)
		elseif eventKazetsuTab == EventKazetsuTab.TRIAL then
			require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuTrail.UIKazetsuTrailLayout"
			self.layout = UIKazetsuTrailLayout(self, eventKazetsuTab, self.config.kazetsuTrial)
		else
			XDebug.Error("Missing layout type " .. eventKazetsuTab)
			return nil
		end
		self.layoutDict:Add(eventKazetsuTab, self.layout)
	end
end

function UIEventKazetsuView:DisableCommon()
	self:HideCurrentLayout()
	self.config.login.gameObject:SetActive(false)
end

function UIEventKazetsuView:OnClickHelpInfo()
	local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("event_kazetsu_info"),
			LanguageUtils.LocalizeCommon("event_kazetsu_check_in"),
			LanguageUtils.LocalizeCommon("event_kazetsu_bundle"),
			LanguageUtils.LocalizeCommon("event_kazetsu_gift"),
			LanguageUtils.LocalizeCommon("event_kazetsu_trial"),
			LanguageUtils.LocalizeCommon("event_kazetsu_boss"),
			LanguageUtils.LocalizeCommon("kazetsu_boss_des"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param eventKazetsuTab EventKazetsuTab
function UIEventKazetsuView:_GetEventName(eventKazetsuTab)
	if eventKazetsuTab == EventKazetsuTab.CHECK_IN then
		return LanguageUtils.LocalizeCommon("event_kazetsu_check_in")
	elseif eventKazetsuTab == EventKazetsuTab.BUNDLE then
		return LanguageUtils.LocalizeCommon("event_kazetsu_bundle")
	elseif eventKazetsuTab == EventKazetsuTab.GIFT then
		return LanguageUtils.LocalizeCommon("event_kazetsu_gift")
	elseif eventKazetsuTab == EventKazetsuTab.BOSS then
		return LanguageUtils.LocalizeCommon("event_kazetsu_boss")
	elseif eventKazetsuTab == EventKazetsuTab.TRIAL then
		return LanguageUtils.LocalizeCommon("event_kazetsu_trial")
	else
		return LanguageUtils.LocalizeCommon("event_kazetsu_check_in")
	end
end

--- @param eventKazetsuTab EventKazetsuTab
function UIEventKazetsuView:_GetEventIcon(eventKazetsuTab)
	return ResourceLoadUtils.LoadEventKazetsu(eventKazetsuTab)
end

function UIEventKazetsuView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end

function UIEventKazetsuView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

function UIEventKazetsuView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventKazetsuView:CheckAllNotificationTab()
	local updateModel = function()
		self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	end

	EventInBound.ValidateEventModel(updateModel)
	--- @param v EventKazetsuTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

--- @param eventKazetsuTab EventKazetsuTab
function UIEventKazetsuView:UpdateNotificationByTab(eventKazetsuTab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(eventKazetsuTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

--- @param eventKazetsuTab EventKazetsuTab
function UIEventKazetsuView:_GetEventNotification(eventKazetsuTab)
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	return self.eventModel:IsTabNotified(eventKazetsuTab)
end

function UIEventKazetsuView:_GetEventEndTime(eventKazetsuTab)
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventKazetsuView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventNewYearModel
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

function UIEventKazetsuView:Hide()
	UIBaseView.Hide(self)

	self:RemoveListener()

	self:HideCurrentLayout()

	self:HideScrollTab()
end

function UIEventKazetsuView:HideScrollTab()
	self.scrollLoopTab:Hide()
	self.eventTabDict:Clear()
end

function UIEventKazetsuView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventKazetsuView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end