require "lua.client.scene.ui.home.uiNewServerWeek2.UINewServerWeekModel2"
local pivotTab = U_Vector2(0.865, 0.5)
--- @class UINewServerWeekView2 : UIBaseView
UINewServerWeekView2 = Class(UINewServerWeekView2, UIBaseView)

--- @param model UINewServerWeekModel2
function UINewServerWeekView2:Ctor(model)
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
	--- @type EventNewServerWeekModel2
	self.eventNewServerWeekModel = nil
	UIBaseView.Ctor(self, model)
	--- @type UINewServerWeekModel2
	self.model = model
	---@type List
	self.listSubTabEvent = List()
end

function UINewServerWeekView2:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()

	self:_InitScrollTab()
end

function UINewServerWeekView2:InitButtons()

	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.help.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickHelpInfo()
	end)

end

function UINewServerWeekView2:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
	self:OnReadyHide()
end


function UINewServerWeekView2:OnReadyHide()
	PopupMgr.HidePopup(self.model.uiName)
	PopupMgr.ShowPopup(UIPopupName.UIMainArea)
end


function UINewServerWeekView2:_InitScrollTab()
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
function UINewServerWeekView2:_GetEventNotification(newServerWeek)
	return self.eventNewServerWeekModel:IsTabNotified(newServerWeek)
end

function UINewServerWeekView2:CheckEventTabNoti() --hoangpl
	for tabEnum ,spinTab in pairs (self.eventTabDict:GetItems()) do
		if  (spinTab ~= nil) then
			spinTab:SetNotificationFunction(function()
				return self:_GetEventNotification(tabEnum)
			end)
		end
	end
end


function UINewServerWeekView2:_GetEventEndTime(newServerWeek)
	if (newServerWeek == NewServerWeekTab2.ARENA_3V3_BOOT) then
		local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA_3V3)
		return eventModel.timeData.endTime
	end
	return self.eventNewServerWeekModel.timeData.endTime
end

function UINewServerWeekView2:_OnEventTimeEnded()
	self:OnReadyShow()
	--RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventNewServerWeekModel:GetType(), ["isAdded"] = false })
end

--- @param newServerWeekTab NewServerWeekTab
function UINewServerWeekView2:_GetEventIcon(tabId)
	return ResourceLoadUtils.LoadEventNewServerWeek2(tabId)
end

--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView2:_GetEventName(newServerWeek)
	if newServerWeek == NewServerWeekTab2.GROW_UP then
		return LanguageUtils.LocalizeCommon("event_grow_up")
	elseif newServerWeek == NewServerWeekTab2.TOWER_BOOTCAMP then
		return LanguageUtils.LocalizeCommon("event_tower_bootcamp")
	elseif newServerWeek == NewServerWeekTab2.ARENA_3V3_BOOT then
		return LanguageUtils.LocalizeCommon("event_arena_3v3_boot")
	elseif newServerWeek == NewServerWeekTab2.DUNGEON then
		return LanguageUtils.LocalizeCommon("dungeon")
	elseif newServerWeek == NewServerWeekTab2.BUNDLE then
		return LanguageUtils.LocalizeCommon("event_bundle_new_server_week")
	else
		return LanguageUtils.LocalizeCommon("event_grow_up")
	end
end

function UINewServerWeekView2:OnClickSelectTab(newServerWeek)
	if self:_IsTabChosen(newServerWeek) then
		return
	end
	self:CheckEventTabNoti()
	self:SelectTab(newServerWeek)
end


--- @param newServerWeek NewServerWeekTab2
function UINewServerWeekView2:UpdateNotificationByTab(newServerWeek)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(newServerWeek)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UINewServerWeekView2:SelectTab(newServerWeek)

	self:GetLayout(newServerWeek)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView2:GetLayout(newServerWeek)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(newServerWeek)
	if self.layout == nil then
		if newServerWeek == NewServerWeekTab2.GROW_UP then
			require "lua.client.scene.ui.home.uiNewServerWeek2.uiNewServerWeekLayout.EventGrowUp.UIGrowUpLayout2"
			self.layout = UIGrowUpLayout2(self, newServerWeek, self.config.growUp)
		elseif newServerWeek == NewServerWeekTab2.TOWER_BOOTCAMP then
			require "lua.client.scene.ui.home.uiNewServerWeek2.uiNewServerWeekLayout.EventTowerBootcamp.UITowerBootcampLayout"
			self.layout = UITowerBootcampLayout(self, newServerWeek, self.config.towerBootcamp)
		elseif newServerWeek == NewServerWeekTab2.DUNGEON then
			require "lua.client.scene.ui.home.uiNewServerWeek2.uiNewServerWeekLayout.EventDungeon.UIDungeonLayout"
			self.layout = UIDungeonLayout(self, newServerWeek, self.config.dungeon)
		elseif newServerWeek == NewServerWeekTab2.ARENA_3V3_BOOT then
			require "lua.client.scene.ui.home.uiNewServerWeek2.uiNewServerWeekLayout.EventArena3V3Boot.UIArena3V3BootLayout"
			self.layout = UIArena3V3BootLayout(self, newServerWeek, self.config.arena3v3Boot)
		elseif newServerWeek == NewServerWeekTab2.BUNDLE then
			require "lua.client.scene.ui.home.uiNewServerWeek2.uiNewServerWeekLayout.Bundle.UINewServerWeekBundle2Layout"
			self.layout = UINewServerWeekBundle2Layout(self, newServerWeek, self.config.bundle)
		else
			XDebug.Error("Missing layout type " .. newServerWeek)
			return nil
		end
		self.layoutDict:Add(newServerWeek, self.layout)
	end
end


function UINewServerWeekView2:DisableCommon()
	self:HideCurrentLayout()
	self.config.growUp.gameObject:SetActive(false)
	self.config.towerBootcamp.gameObject:SetActive(false)
	self.config.dungeon.gameObject:SetActive(false)
	self.config.arena3v3Boot.gameObject:SetActive(false)
	self.config.bundle.gameObject:SetActive(false)
end


--- @param newServerWeek NewServerWeekTab
function UINewServerWeekView2:_IsTabChosen(newServerWeek)
	return self.layout ~= nil and self.layout.newServerWeekTabId == newServerWeek
end


function UINewServerWeekView2:InitLocalization()
	if (self.layoutDict ~= nil) then
		for k, v in pairs(self.layoutDict:GetItems()) do
			if (v ~= nil) then
				v:InitLocalization()
			end
		end
	end
end

--- @param groupID number
function UINewServerWeekView2:OnSelectTabByType(groupID)
	if self.model:IsCurrentTab(groupID) == false then
		self:EnableSelectTabState(self.model.currentTab, false) -- toggle tab selected display
		self:HideLayout()
		self.model:SetTab(groupID)
		self:ShowCurrentTab() -- set hide old layout and show new layout
	end
end

function UINewServerWeekView2:EnableSelectTabState(groupID, isEnabled)
	if groupID == nil then
		return
	end
	--- @type UIFlashSalePackageTabItem
	local eventPackageTabItem = self.eventTabDict:Get(groupID)
	if eventPackageTabItem ~= nil then
		eventPackageTabItem:SetSelectState(isEnabled)
	end
end
function UINewServerWeekView2:ShowCurrentTab()
	self:GetLayout( self.model.currentTab)
	self.layout:OnShow()
	self.currentTab = self.model.currentTab
	self:EnableSelectTabState( self.model.currentTab, true)
end
function UINewServerWeekView2:HideLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end
--- @param data {callbackClose : function}
function UINewServerWeekView2:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.eventNewServerWeekModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_2)
	local isOpen = self.eventNewServerWeekModel:IsOpening()
	if isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	--self:CheckEndSeasonDisplay()
	self:InitListSubTabEvent()
	if self.listSubTabEvent:Count() > 0 then
		self:SelectTab(self.listSubTabEvent:Get(NewServerWeekTab2.GROW_UP))
		self.scrollLoopTab:Resize(self.listSubTabEvent:Count())
		--self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UINewServerWeekView2:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventNewServerWeekModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_2)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				--zg.playerData.remoteConfig.lastTimeDurationBlackFriday = nil
				--zg.playerData:SaveRemoteConfig()
				if PopupUtils.IsPopupShowing(UIPopupName.UINewServerWeek2) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UINewServerWeek2)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UINewServerWeekView2:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

function UINewServerWeekView2:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UINewServerWeekView2:OnUpdatePurchase()
	--self:SetCommon()
	if (self.layout ~= nil) then
		self.layout:GetDataAndUpdateView()
	end
end

function UINewServerWeekView2:InitListSubTabEvent()
	self.listSubTabEvent:Clear()
	local  eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_2)
	local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
	if  isOpening then
		self.listSubTabEvent:Add(NewServerWeekTab2.GROW_UP)
		self.listSubTabEvent:Add(NewServerWeekTab2.TOWER_BOOTCAMP)
		self.listSubTabEvent:Add(NewServerWeekTab2.DUNGEON)
		self.listSubTabEvent:Add(NewServerWeekTab2.BUNDLE)
	end
	local eventModelArena = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SERVER_OPEN_ARENA_3V3)
	local isOpeningArena = eventModelArena ~= nil and eventModelArena.timeData:IsOpening()
	if isOpeningArena then
		XDebug.Log("OPENING ARENA")
		self.listSubTabEvent:Add(NewServerWeekTab2.ARENA_3V3_BOOT)
	else
		XDebug.Log("close ARENA")
	end
end

function UINewServerWeekView2:OnClickHelpInfo()
	local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("help_new_server_week_2"),
			LanguageUtils.LocalizeCommon("event_grow_up"),
			LanguageUtils.LocalizeCommon("event_tower_bootcamp"),
			LanguageUtils.LocalizeCommon("dungeon"),
			LanguageUtils.LocalizeCommon("event_arena_3v3_boot"),
			LanguageUtils.LocalizeCommon("event_bundle_new_server_week")
	)
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

