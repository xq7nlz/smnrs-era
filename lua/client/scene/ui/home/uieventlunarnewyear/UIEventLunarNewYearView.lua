require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.UIEventLunarNewYearLayout"

--- @class UIEventLunarNewYearView : UIBaseView
UIEventLunarNewYearView = Class(UIEventLunarNewYearView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

function UIEventLunarNewYearView:Ctor(model)
	--- @type UIEventLunarNewYearConfig
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

	--- @type EventLunarNewYearModel
	self.eventModel = nil

	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_LUNAR_NEW_YEAR_2022
	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventLunarNewYearModel
	self.model = model
end

function UIEventLunarNewYearView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventLunarNewYearView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventNewYearLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventLunarNewYearView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventLunarNewYearView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type LunarNewYearTab
		local newYearTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(newYearTab))
		obj:SetSelectState(self:_IsTabChosen(newYearTab))
		obj:SetIcon(self:_GetEventIcon(newYearTab))
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(newYearTab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(newYearTab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(newYearTab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(newYearTab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type LunarNewYearTab
		local newYearTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(newYearTab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param newYearTab LunarNewYearTab
function UIEventLunarNewYearView:_IsTabChosen(newYearTab)
	return self.layout ~= nil and self.layout.newYearTab == newYearTab
end

function UIEventLunarNewYearView:OnReadyShow()
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
			self:SelectTab(self.model.listSubEvent:Get(1))
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

function UIEventLunarNewYearView:CheckEndSeasonDisplay()
	--self.config.VerticalScrollTab.gameObject:SetActive(self.isOpen)
end

function UIEventLunarNewYearView:CheckResourceOnSeason()
	local endTime = self.eventModel.timeData.endTime
	local savedEndSeason = zg.playerData.remoteConfig.eventLunarNewYearEnd or endTime
	if savedEndSeason ~= endTime then
		self:ClearMoneyType()
	end
	zg.playerData.remoteConfig.eventLunarNewYearEnd = endTime
	zg.playerData:SaveRemoteConfig()
end

function UIEventLunarNewYearView:ClearMoneyType()
	local clearResource = function(moneyType)
		local currentValue = InventoryUtils.Get(ResourceType.Money, moneyType)
		InventoryUtils.Sub(ResourceType.Money, moneyType, currentValue)
	end
end

function UIEventLunarNewYearView:SelectTab(newYearTab)
	self:GetLayout(newYearTab)
	self.layout:OnShow()
	self:CheckAllNotificationTab()
	self.scrollLoopTab:RefreshCells()
end

function UIEventLunarNewYearView:OnClickSelectTab(newYearTab)
	if self:_IsTabChosen(newYearTab) then
		return
	end
	self:SelectTab(newYearTab)
end

--- @param newYearTab LunarNewYearTab
function UIEventLunarNewYearView:GetLayout(newYearTab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(newYearTab)
	if self.layout == nil then
		if newYearTab == LunarNewYearTab.CHECK_IN then
			require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.dailyCheckin.UIEventLunarDailyCheckinLayout"
			self.layout = UIEventLunarDailyCheckinLayout(self, newYearTab, self.config.checkinAnchor)
		elseif newYearTab == LunarNewYearTab.SPRING_BOX then
			require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.springBox.UIEventLunarNewYearSpringBoxLayout"
			self.layout = UIEventLunarNewYearSpringBoxLayout(self, newYearTab, self.config.springBoxAnchor)
		elseif newYearTab == LunarNewYearTab.LION_DANCE then
			require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.lionDance.UIEventLunarNewYearLionDanceLayout"
			self.layout = UIEventLunarNewYearLionDanceLayout(self, newYearTab, self.config.lionDanceAnchor)
		elseif newYearTab == LunarNewYearTab.SPRING_BUNDLE then
			require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.springBundle.UIEventLunarNewYearSpringBundleLayout"
			self.layout = UIEventLunarNewYearSpringBundleLayout(self, newYearTab, self.config.springBundleAnchor)
		elseif newYearTab == LunarNewYearTab.LUNAR_BUNDLE then
			--TODO: 1 offer
			--require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.lunarBundle.UIEventLunarNewYearLunarBundleLayout"
			--self.layout = UIEventLunarNewYearLunarBundleLayout(self, newYearTab, self.config.lunarBundleAnchor,1)
			--TODO: Multiple offer
			require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.lunarBundle.UIEventLunarBundleDoubleOfferLayout"
			self.layout = UIEventLunarBundleDoubleOfferLayout(self, newYearTab, self.config.lunarBundleAnchor)
		elseif newYearTab == LunarNewYearTab.TIGER_PATH then
			require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.tigerPath.UIEventLunarNewYearTigerPathLayout"
			self.layout = UIEventLunarNewYearTigerPathLayout(self, newYearTab, self.config.tigerPathAnchor,1)
		else
			XDebug.Error("Missing layout type " .. newYearTab)
			return nil
		end
			self.layoutDict:Add(newYearTab, self.layout)
		end
end

function UIEventLunarNewYearView:DisableCommon()
	self:HideCurrentLayout()
	self.config.checkinAnchor.gameObject:SetActive(false)
	self.config.springBoxAnchor.gameObject:SetActive(false)
	self.config.tigerPathAnchor.gameObject:SetActive(false)
	self.config.lionDanceAnchor.gameObject:SetActive(false)
	self.config.lunarBundleAnchor.gameObject:SetActive(false)
end

function UIEventLunarNewYearView:OnClickHelpInfo()
	local helpText = LanguageUtils.LocalizeHelpInfo("event_lunar_new_year_2022_info")
	helpText =string.gsub(helpText, "{1}",LanguageUtils.LocalizeCommon("event_lunar_new_year_login"))
	helpText =string.gsub(helpText, "{2}",LanguageUtils.LocalizeCommon("event_lunar_new_year_spring_bundle"))
	helpText =string.gsub(helpText, "{3}",LanguageUtils.LocalizeCommon("event_lunar_new_year_exclusive_bundle"))
	helpText =string.gsub(helpText, "{4}",LanguageUtils.LocalizeCommon("event_lunar_new_year_spring_box"))
	helpText =string.gsub(helpText, "{5}",LanguageUtils.LocalizeCommon("event_lunar_new_year_tiger_path"))
	helpText =string.gsub(helpText, "{6}",LanguageUtils.LocalizeCommon("event_lunar_new_year_lion_dance"))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, helpText)
end

--- @param newYearTab LunarNewYearTab
function UIEventLunarNewYearView:_GetEventName(newYearTab)
	if newYearTab == LunarNewYearTab.CHECK_IN then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_login")
	elseif newYearTab == LunarNewYearTab.SPRING_BOX then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_spring_box")
	elseif newYearTab == LunarNewYearTab.TIGER_PATH then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_tiger_path")
	elseif newYearTab == LunarNewYearTab.LION_DANCE then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_lion_dance")
	elseif newYearTab == LunarNewYearTab.LUNAR_BUNDLE then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_exclusive_bundle")
	elseif newYearTab == LunarNewYearTab.SPRING_BUNDLE then
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_spring_bundle")
	else
		return LanguageUtils.LocalizeCommon("event_lunar_new_year_login")
	end
end

--- @param newYearTab LunarNewYearTab
function UIEventLunarNewYearView:_GetEventIcon(newYearTab)
	return ResourceLoadUtils.LoadEventLunarNewYear(newYearTab)
end



function UIEventLunarNewYearView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventModel:GetType(), ["isAdded"] = false })
end



function UIEventLunarNewYearView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

function UIEventLunarNewYearView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventLunarNewYearView:CheckAllNotificationTab()
	local updateModel = function()
		self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	end

	EventInBound.ValidateEventModel(updateModel)
	--- @param v LunarNewYearTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

--- @param newYearTab LunarNewYearTab
function UIEventLunarNewYearView:UpdateNotificationByTab(newYearTab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(newYearTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

--- @param newYearTab LunarNewYearTab
function UIEventLunarNewYearView:_GetEventNotification(newYearTab)
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	return self.eventModel:IsTabNotified(newYearTab)
end

function UIEventLunarNewYearView:_GetEventEndTime(newYearTab)
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventLunarNewYearView:OnEventStateChange(data)
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

function UIEventLunarNewYearView:Hide()
	UIBaseView.Hide(self)

	self:RemoveListener()

	self:HideCurrentLayout()

	self:HideScrollTab()
end

function UIEventLunarNewYearView:HideScrollTab()
	self.scrollLoopTab:Hide()
	self.eventTabDict:Clear()
end

function UIEventLunarNewYearView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventLunarNewYearView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end