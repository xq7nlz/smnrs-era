require "lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.UIEventPieceAdventureLayout"

--- @class UIEventPieceAdventureView : UIBaseView
UIEventPieceAdventureView = Class(UIEventPieceAdventureView, UIBaseView)
local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventPieceAdventureModel
function UIEventPieceAdventureView:Ctor(model)
	--- @type UIEventPieceAdventureConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil

	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventPieceAdventureLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventPieceAdventureModel
	self.eventModel = nil
	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_PIECE_ADVENTURE
	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventPieceAdventureModel
	self.model = model
end

function UIEventPieceAdventureView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:_InitButtonListener()
	self:_InitScrollTab()
end

function UIEventPieceAdventureView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventNewYearLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventPieceAdventureView:_InitButtonListener()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventPieceAdventureView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EventPieceAdventureTab
		local pieceAdventureTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(pieceAdventureTab))
		obj:SetSelectState(self:_IsTabChosen(pieceAdventureTab))
		obj:SetIcon(self:_GetEventIcon(pieceAdventureTab))
		if pieceAdventureTab == EventPieceAdventureTab.PIECE_STORE then
			obj.config.icon.rectTransform.localScale = U_Vector3.one * 0.75
		end
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(pieceAdventureTab)
		end)
		obj:SetEndEventTime(self.eventModel.timeData.endTime, function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(pieceAdventureTab)
		end)
		--obj:SetPivot(pivotTab)
		self.eventTabDict:Add(pieceAdventureTab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EventPieceAdventureTab
		local pieceAdventureTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(pieceAdventureTab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

function UIEventPieceAdventureView:OnReadyShow(result)
	self.isReloadingData = false
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	self.model:InitListSubEvent(self.eventModel.timeData)
	if self.eventModel:IsOpening() == false then
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
		return
	elseif result ~= nil and result.tab ~= nil then
		self:OnClickSelectTab(result.tab)
	else
		if self.model.listSubEvent:Count() > 0 then
			self:SelectTab(self.model.listSubEvent:Get(1))
			self.scrollLoopTab:Resize(self.model.listSubEvent:Count())
			self:CheckAllNotificationTab()
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			self:OnReadyHide()
		end
	end
end

function UIEventPieceAdventureView:OnClickHelpInfo()
	---@type EventTimeData
	local timeData = self.eventModel.timeData
	local dayStart = TimeUtils.GetDateMonthYearFromTimestamp(timeData.startTime)
	local dayEnd = TimeUtils.GetDateMonthYearFromTimestamp(timeData.endTime)
	local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("event_piece_adventure_info", dayStart, dayEnd))
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param pieceAdventureTab EventPieceAdventureTab
function UIEventPieceAdventureView:_GetEventName(pieceAdventureTab)
	if pieceAdventureTab == EventPieceAdventureTab.PIECE_ADVENTURE then
		return LanguageUtils.LocalizeCommon("piece_adventure_card")
	elseif pieceAdventureTab == EventPieceAdventureTab.DAILY_QUEST then
		return LanguageUtils.LocalizeCommon("piece_adventure_quest")
	elseif pieceAdventureTab == EventPieceAdventureTab.EXCHANGE then
		return LanguageUtils.LocalizeCommon("piece_adventure_exchange")
	elseif pieceAdventureTab == EventPieceAdventureTab.PIECE_STORE then
		return LanguageUtils.LocalizeCommon("piece_adventure_store")
	else
		return LanguageUtils.LocalizeCommon("piece_adventure_card")
	end
end

--- @param pieceAdventureTab EventPieceAdventureTab
function UIEventPieceAdventureView:_IsTabChosen(pieceAdventureTab)
	return self.layout ~= nil and self.layout.pieceAdventureTab == pieceAdventureTab
end

--- @param pieceAdventureTab EventPieceAdventureTab
function UIEventPieceAdventureView:_GetEventIcon(pieceAdventureTab)
	return ResourceLoadUtils.LoadEventPieceAdventure(pieceAdventureTab)
end

--- @param pieceAdventureTab EventPieceAdventureTab
function UIEventPieceAdventureView:_GetEventNotification(pieceAdventureTab)
	return self.eventModel:IsTabNotified(pieceAdventureTab)
end

function UIEventPieceAdventureView:_OnEventTimeEnded()
	if self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventPieceAdventureModel
			local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				--self:RemoveListener()
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

function UIEventPieceAdventureView:OnClickSelectTab(pieceAdventureTab)
	if self:_IsTabChosen(pieceAdventureTab) then
		return
	end
	self:SelectTab(pieceAdventureTab)
end

function UIEventPieceAdventureView:SelectTab(pieceAdventureTab)
	self:GetLayout(pieceAdventureTab)
	self.layout:OnShow()
	self:CheckAllNotificationTab()
	self.scrollLoopTab:RefreshCells()
end

--- @param pieceAdventureTab EventPieceAdventureTab
function UIEventPieceAdventureView:GetLayout(pieceAdventureTab)
	self:DisableCommon()
	if pieceAdventureTab == EventPieceAdventureTab.PIECE_ADVENTURE then
		self.config.backGround.gameObject:SetActive(true)
		self.config.backGround1.gameObject:SetActive(false)
	else
		self.config.backGround.gameObject:SetActive(false)
		self.config.backGround1.gameObject:SetActive(true)
	end
	self.layout = self.layoutDict:Get(pieceAdventureTab)
	if self.layout == nil then
		if pieceAdventureTab == EventPieceAdventureTab.PIECE_ADVENTURE then
			require "lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.EventPieceAdventure.UIEventPieceAdventureOpenCardLayout"
			self.layout = UIEventPieceAdventureOpenCardLayout(self, pieceAdventureTab, self.config.cardAnchor)
		elseif pieceAdventureTab == EventPieceAdventureTab.DAILY_QUEST then
			require "lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.Quest.UIEventPieceAdventureQuestLayout"
			self.layout = UIEventPieceAdventureQuestLayout(self, pieceAdventureTab, self.config.questAnchor)
		elseif pieceAdventureTab == EventPieceAdventureTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.Exchange.UIEventPieceAdventureExchangeLayout"
			self.layout = UIEventPieceAdventureExchangeLayout(self, pieceAdventureTab, self.config.exchangeAnchor)
		elseif pieceAdventureTab == EventPieceAdventureTab.PIECE_STORE then
			require "lua.client.scene.ui.home.uiEventPieceAdventure.uiEventPieceAdventureLayout.Shop.UIEventPieceAdventureShopLayout"
			self.layout = UIEventPieceAdventureShopLayout(self, pieceAdventureTab, self.config.bundleAnchor)
		else
			XDebug.Error("Missing layout type " .. pieceAdventureTab)
			return nil
		end
		self.layoutDict:Add(pieceAdventureTab, self.layout)
	end


end

function UIEventPieceAdventureView:DisableCommon()
	self:HideCurrentLayout()
	self.config.cardAnchor.gameObject:SetActive(false)
	self.config.questAnchor.gameObject:SetActive(false)
	self.config.exchangeAnchor.gameObject:SetActive(false)
	self.config.bundleAnchor.gameObject:SetActive(false)
end

function UIEventPieceAdventureView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

function UIEventPieceAdventureView:Hide()
	UIBaseView.Hide(self)
	self:HideCurrentLayout()
end

function UIEventPieceAdventureView:CheckAllNotificationTab()
	local updateModel = function()
		self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	end

	EventInBound.ValidateEventModel(updateModel)
	--- @param v EventPieceAdventureTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

--- @param pieceAdventureTab EventPieceAdventureTab
function UIEventPieceAdventureView:UpdateNotificationByTab(pieceAdventureTab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(pieceAdventureTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventPieceAdventureView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end
