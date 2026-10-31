require "lua.client.scene.ui.home.uiNewServerWeek.UINewServerWeekModel"
local pivotTab = U_Vector2(0.865, 0.5)
--- @class UINewServerWeekView : UIBaseView
UINewServerWeekView = Class(UINewServerWeekView, UIBaseView)

--- @param model UINewServerWeekModel
function UINewServerWeekView:Ctor(model)
	--- @type UINewServerConfig
	self.config = nil
	--- @type Dictionary
	self.newServerDict = Dictionary()
	self.rewardTableView = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UINewServerWeekLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()
	--UIDailyRewardModel.lua
	--UIDailyRewardView.lua
	self.currentTab = nil
	--- @type EventNewServerWeekModel
	self.eventNewServerWeekModel = nil
	UIBaseView.Ctor(self, model)
	--- @type UINewServerWeekModel
	self.model = model
	---@type List
	self.listSubTabEvent = List()
end

function UINewServerWeekView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()

	self:_InitScrollTab()
end

function UINewServerWeekView:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.help.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickHelpInfo()
	end)

end

function UINewServerWeekView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
	self:OnReadyHide()
end


function UINewServerWeekView:OnReadyHide()
	self.scrollLoopTab:Hide()
	PopupMgr.HidePopup(self.model.uiName)
	PopupMgr.ShowPopup(UIPopupName.UIMainArea)
end


function UINewServerWeekView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type NewServerWeekTab
		local newServerWeekTab = self.listSubTabEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(newServerWeekTab))
		obj:SetSelectState(self:_IsTabChosen(newServerWeekTab))
		obj:SetIcon(self:_GetEventIcon(newServerWeekTab))
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(newServerWeekTab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(newServerWeekTab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(newServerWeekTab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(newServerWeekTab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type NewServerWeekTab
		local newServerWeekTab = self.listSubTabEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(newServerWeekTab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.scrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView:_GetEventNotification(newServerWeek)
	return self.eventNewServerWeekModel:IsTabNotified(newServerWeek)
end

function UINewServerWeekView:CheckEventTabNoti() --hoangpl
	for tabEnum ,spinTab in pairs (self.eventTabDict:GetItems()) do
		if  (spinTab ~= nil) then
			spinTab:SetNotificationFunction(function()
				return self:_GetEventNotification(tabEnum)
			end)
		end
	end
end


function UINewServerWeekView:_GetEventEndTime(newServerWeek)
	if newServerWeek == NewServerWeekTab.SPIN  then
		local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_SPIN)
		return eventModel.timeData.endTime
	elseif (newServerWeek == NewServerWeekTab.ARENA_BOOT) then
		local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA)
		return eventModel.timeData.endTime
	end
	return self.eventNewServerWeekModel.timeData.endTime
end

function UINewServerWeekView:_OnEventTimeEnded()
	self:OnReadyShow()
	--RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventNewServerWeekModel:GetType(), ["isAdded"] = false })
end

--- @param newServerWeekTab NewServerWeekTab
function UINewServerWeekView:_GetEventIcon(tabId)
	return ResourceLoadUtils.LoadEventNewServerWeek(tabId)
end

--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView:_GetEventName(newServerWeek)
	if newServerWeek == NewServerWeekTab.GROW_UP then
		return LanguageUtils.LocalizeCommon("event_grow_up")
	elseif newServerWeek == NewServerWeekTab.CAMPAIGN_BOOT then
		return LanguageUtils.LocalizeCommon("event_campaign_boot")
	elseif newServerWeek == NewServerWeekTab.ARENA_BOOT then
		return LanguageUtils.LocalizeCommon("event_arena_boot")
	elseif newServerWeek == NewServerWeekTab.VIP_TREASURE then
		return LanguageUtils.LocalizeCommon("vip_treasure")
	elseif newServerWeek == NewServerWeekTab.SPIN then
		return LanguageUtils.LocalizeCommon("event_spin_new_server_week")
	elseif newServerWeek == NewServerWeekTab.DAILY then
		return LanguageUtils.LocalizeCommon("event_new_server_week_login")
	elseif newServerWeek == NewServerWeekTab.BUNDLE then
		return LanguageUtils.LocalizeCommon("event_bundle_new_server_week")
	else
		return LanguageUtils.LocalizeCommon("event_grow_up")
	end
end

function UINewServerWeekView:OnClickSelectTab(newServerWeek)
	if self:_IsTabChosen(newServerWeek) then
		return
	end
	self:CheckEventTabNoti()
	self:SelectTab(newServerWeek)
end


--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView:UpdateNotificationByTab(newServerWeek)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(newServerWeek)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UINewServerWeekView:SelectTab(newServerWeek)
	self:GetLayout(newServerWeek)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView:GetLayout(newServerWeek)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(newServerWeek)
	if self.layout == nil then
		if newServerWeek == NewServerWeekTab.GROW_UP then
			require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventGrowUp.UIGrowUpLayout"
			self.layout = UIGrowUpLayout(self, newServerWeek, self.config.growUp)
		elseif newServerWeek == NewServerWeekTab.CAMPAIGN_BOOT then
			require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventCampaignBoot.UICampaignBootLayout"
			self.layout = UICampaignBootLayout(self, newServerWeek, self.config.campaignBoot)
		elseif newServerWeek == NewServerWeekTab.SPIN then
			require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventSpin.UINewServerWeekSpinLayout"
			self.layout = UINewServerWeekSpinLayout(self, newServerWeek, self.config.spin)
		elseif newServerWeek == NewServerWeekTab.VIP_TREASURE then
			require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventVipTreasure.UIVipTreasureLayout"
			self.layout = UIVipTreasureLayout(self, newServerWeek, self.config.vipTreasure)
		elseif newServerWeek == NewServerWeekTab.ARENA_BOOT then
			require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventArenaBoot.UIArenaBootLayout"
			self.layout = UIArenaBootLayout(self, newServerWeek, self.config.arenaBoot)
		elseif newServerWeek == NewServerWeekTab.DAILY then
			require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.EventDailyLogin.UINewServerWeekLoginLayout"
			self.layout = UINewServerWeekLoginLayout(self, newServerWeek, self.config.login)
			-- Thêm BUNDLE Layout
		elseif newServerWeek == NewServerWeekTab.BUNDLE then
			require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.Bundle.UINewServerWeekBundleLayout"
			self.layout = UINewServerWeekBundleLayout(self, newServerWeek, self.config.bundle)
		else
			XDebug.Error("Missing layout type " .. newServerWeek)
			return nil
		end
		self.layoutDict:Add(newServerWeek, self.layout)
	end
end


function UINewServerWeekView:DisableCommon()
	self:HideCurrentLayout()
	self.config.growUp.gameObject:SetActive(false)
	self.config.campaignBoot.gameObject:SetActive(false)
	self.config.vipTreasure.gameObject:SetActive(false)
	self.config.spin.gameObject:SetActive(false)
	self.config.arenaBoot.gameObject:SetActive(false)
	self.config.login.gameObject:SetActive(false)
	self.config.bundle.gameObject:SetActive(false)
end


--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView:_IsTabChosen(newServerWeek)
	return self.layout ~= nil and self.layout.newServerWeekTabId == newServerWeek
end


function UINewServerWeekView:InitLocalization()
	if (self.layoutDict ~= nil) then
		for k, v in pairs(self.layoutDict:GetItems()) do
			if (v ~= nil) then
				v:InitLocalization()
			end
		end
	end
end

--- @param groupID number
function UINewServerWeekView:OnSelectTabByType(groupID)
	if self.model:IsCurrentTab(groupID) == false then
		self:EnableSelectTabState(self.model.currentTab, false) -- toggle tab selected display
		self:HideLayout()
		self.model:SetTab(groupID)
		self:ShowCurrentTab() -- set hide old layout and show new layout
	end
end

function UINewServerWeekView:EnableSelectTabState(groupID, isEnabled)
	if groupID == nil then
		return
	end
	--- @type UIFlashSalePackageTabItem
	local eventPackageTabItem = self.eventTabDict:Get(groupID)
	if eventPackageTabItem ~= nil then
		eventPackageTabItem:SetSelectState(isEnabled)
	end
end
function UINewServerWeekView:ShowCurrentTab()
	self:GetLayout( self.model.currentTab)
	self.layout:OnShow()
	self.currentTab = self.model.currentTab
	self:EnableSelectTabState( self.model.currentTab, true)
end
function UINewServerWeekView:HideLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end
--- @param data {callbackClose : function}
function UINewServerWeekView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.eventNewServerWeekModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
	if self.eventNewServerWeekModel == nil then
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
		return
	end
	local isOpen = self.eventNewServerWeekModel:IsOpening()
	if isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	--self:CheckEndSeasonDisplay()
	self:SetArrowIsActive(true)
	self:SetBackgroundIsActive(true)
	self:InitListSubTabEvent(data)
	if self.listSubTabEvent:Count() > 0 then
		self.scrollLoopTab:Resize(self.listSubTabEvent:Count())
		if data and data.tab then
			self:SelectTab(data.tab)
			self:SetArrowIsActive(false)
			self.scrollLoopTab:Hide()
			self:SetBackgroundIsActive(false)
		else
			self:SelectTab(self.listSubTabEvent:Get(NewServerWeekTab.GROW_UP))
		end
		--self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UINewServerWeekView:SetArrowIsActive(isActive)
	self.config.upArrow.gameObject:SetActive(isActive)
	self.config.downArrow.gameObject:SetActive(isActive)
end

function UINewServerWeekView:SetBackgroundIsActive(isActive)
	self.config.backGround.gameObject:SetActive(isActive)
	self.config.bgShopColumn:SetActive(isActive)
	self.config.scrollTab.gameObject:SetActive(isActive)
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UINewServerWeekView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventNewServerWeekModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				--zg.playerData.remoteConfig.lastTimeDurationBlackFriday = nil
				--zg.playerData:SaveRemoteConfig()
				if PopupUtils.IsPopupShowing(UIPopupName.UINewServerWeek) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UINewServerWeek)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UINewServerWeekView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

function UINewServerWeekView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UINewServerWeekView:OnUpdatePurchase()
	--self:SetCommon()
	if (self.layout ~= nil) then
		self.layout:GetDataAndUpdateView()
	end
end

function UINewServerWeekView:InitListSubTabEvent(data)
	self.listSubTabEvent:Clear()
	local  eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
	local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
	if  isOpening then
		if data and data.tab then
			self.listSubTabEvent:Add(data.tab)
		else
			self.listSubTabEvent:Add(NewServerWeekTab.GROW_UP)
			self.listSubTabEvent:Add(NewServerWeekTab.CAMPAIGN_BOOT)
			self.listSubTabEvent:Add(NewServerWeekTab.VIP_TREASURE)
			self.listSubTabEvent:Add(NewServerWeekTab.BUNDLE)
		end
	end
	eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA)
	isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
	if isOpening then
		self.listSubTabEvent:Add(NewServerWeekTab.ARENA_BOOT)
	end
	eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_SPIN)
	isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
	if isOpening then
		self.listSubTabEvent:Add(NewServerWeekTab.SPIN)
	end
end

function UINewServerWeekView:OnClickHelpInfo()
	local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("help_new_server_week"),
			LanguageUtils.LocalizeCommon("event_new_server_week_login"),
			LanguageUtils.LocalizeCommon("event_grow_up"),
			LanguageUtils.LocalizeCommon("event_campaign_boot"),
			LanguageUtils.LocalizeCommon("vip_treasure"),
			LanguageUtils.LocalizeCommon("event_arena_boot"),
			LanguageUtils.LocalizeCommon("event_spin_new_server_week"),
			LanguageUtils.LocalizeCommon("event_bundle_new_server_week")
	)
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end