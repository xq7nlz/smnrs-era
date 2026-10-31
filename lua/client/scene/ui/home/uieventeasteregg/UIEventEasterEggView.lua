require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.UIEventEasterEggLayout"

--- @class UIEventEasterEggView : UIBaseView
UIEventEasterEggView = Class(UIEventEasterEggView, UIBaseView)

local pivotTab = U_Vector2(0.865, 0.5)

--- @param model UIEventEasterEggModel
function UIEventEasterEggView:Ctor(model)
	--- @type UIEventEasterEggConfig
	self.config = nil
	--- @type UILoopScroll
	self.scrollLoopTab = nil
	--- @type UILoopScroll
	self.scrollLoopContent = nil
	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventEasterEggLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventEasterEggModel
	self.eventModel = nil
	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventEasterEggModel
	self.model = model
end

function UIEventEasterEggView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
	self:_InitScrollTab()
end

function UIEventEasterEggView:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickHelpInfo()
	end)
end

function UIEventEasterEggView:_InitScrollTab()
	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EasterEggTab
		local easterEggTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetText(self:_GetEventName(easterEggTab))
		obj:SetSelectState(self:_IsTabChosen(easterEggTab))
		obj:SetIcon(self:_GetEventIcon(easterEggTab))
		obj:SetNotificationFunction(function()
			return self:_GetEventNotification(easterEggTab)
		end)
		obj:SetEndEventTime(self:_GetEventEndTime(easterEggTab), function()
			self:_OnEventTimeEnded()
		end)
		obj:AddOnSelectListener(function()
			self:OnClickSelectTab(easterEggTab)
		end)
		obj:SetPivot(pivotTab)
		self.eventTabDict:Add(easterEggTab, obj)
	end

	--- @param obj UIEventPackageTabItem
	--- @param index number
	local onUpdateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type EasterEggTab
		local EasterEggTab = self.model.listSubEvent:Get(dataIndex)
		obj:SetSelectState(self:_IsTabChosen(EasterEggTab))
	end
	self.scrollLoopTab = UILoopScroll(self.config.VerticalScrollTab, UIPoolType.EventPackageTabItem, onCreateItem, onUpdateItem)
	self.scrollLoopTab:SetUpMotion(MotionConfig(nil, nil, nil, 0.02))
end

--- @param easterEggTab EasterEggTab
function UIEventEasterEggView:_IsTabChosen(easterEggTab)
	return self.layout ~= nil and self.layout.easterEggTab == easterEggTab
end

function UIEventEasterEggView:InitLocalization()
	if self.layoutDict ~= nil then
		--- @param v UIEventEasterEggLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end
end

function UIEventEasterEggView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

function UIEventEasterEggView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventEasterEggView:OnClickHelpInfo()
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_easter_egg"))
end

--- @param data {callbackClose : function}
function UIEventEasterEggView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)

	self.isReloadingData = false
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	self.eventModel:CheckResourceOnSeason()
	self.isOpen = self.eventModel:IsOpening()
	if self.isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	self.model:InitListSubEvent()
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
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

function UIEventEasterEggView:SelectTab(easterEggTab)
	self:GetLayout(easterEggTab)
	self.layout:OnShow()
	self.scrollLoopTab:RefreshCells()
end

function UIEventEasterEggView:OnClickSelectTab(easterEggTab)
	if self:_IsTabChosen(easterEggTab) then
		return
	end
	self:SelectTab(easterEggTab)
end

--- @param easterEggTab EasterEggTab
function UIEventEasterEggView:GetLayout(easterEggTab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(easterEggTab)
	if self.layout == nil then
		if easterEggTab == EasterEggTab.CHECK_IN then
			require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.dailyCheckin.UIEventEasterEggCheckinLayout"
			self.layout = UIEventEasterEggCheckinLayout(self, easterEggTab, self.config.loginAnchor)
		elseif easterEggTab == EasterEggTab.DICE then
				require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.Dice.UIEventEasterEggDiceLayout"
				self.layout = UIEventEasterEggDiceLayout(self, easterEggTab, self.config.diceAnchor)
		elseif easterEggTab == EasterEggTab.BUNNY_CARD then
			require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.BunnyCardLayout.UIEventEasterBunnyCardLayout"
			self.layout = UIEventEasterBunnyCardLayout(self, easterEggTab, self.config.bunnyCardAnchor)
		elseif easterEggTab == EasterEggTab.EXCLUSIVE_BUNDLE then
			require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.ExclusiveBundle.UIEventEasterExclusiveDoubleOfferBundle"
			self.layout = UIEventEasterExclusiveDoubleOfferBundle(self, easterEggTab, self.config.limitedOfferAnchor, 1)
		--elseif easterEggTab == EasterEggTab.LIMITED_OFFER then
			--require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.LimitedOfferLayout.UIEventEasterLimitedOfferLayout"
			--self.layout = UIEventEasterLimitedOfferLayout(self, easterEggTab, self.config.limitedOfferAnchor)
		--elseif easterEggTab == EasterEggTab.HUNT then
		--	require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.EggHun.UIEggHunLayout"
		--	self.layout = UIEggHunLayout(self, easterEggTab, self.config.huntAnchor)
		elseif easterEggTab == EasterEggTab.BREAK then
			require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.SmashEgg.UISmashEggLayout"
			self.layout = UISmashEggLayout(self, easterEggTab, self.config.breakAnchor)
		elseif easterEggTab == EasterEggTab.EASTER_BUNDLE then
			require "lua.client.scene.ui.home.uiEventEasterEgg.UIEventEasterEggLayout.Bundle.UIEventEasterBundleLayout"
			self.layout = UIEventEasterBundleLayout(self, easterEggTab, self.config.bundleAnchor)
		else
			XDebug.Error("Missing layout type " .. easterEggTab)
			return nil
		end
		self.layoutDict:Add(easterEggTab, self.layout)
	end
end

function UIEventEasterEggView:DisableCommon()
	self:HideCurrentLayout()
end

function UIEventEasterEggView:OnClickHelpInfo()
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_easter_egg_info"))
end

--- @param easterEggTab EasterEggTab
function UIEventEasterEggView:_GetEventName(easterEggTab)
	if easterEggTab == EasterEggTab.CHECK_IN then
		return LanguageUtils.LocalizeCommon("easter_egg_check_in")
	elseif easterEggTab == EasterEggTab.DICE then
		return LanguageUtils.LocalizeCommon("easter_egg_dice_game")
	elseif easterEggTab == EasterEggTab.BUNNY_CARD then
		return LanguageUtils.LocalizeCommon("easter_egg_bunny_card")
	elseif easterEggTab == EasterEggTab.EXCLUSIVE_BUNDLE then
		return LanguageUtils.LocalizeCommon("easter_egg_exclusive_bundle")
	elseif easterEggTab == EasterEggTab.EASTER_BUNDLE then
		return LanguageUtils.LocalizeCommon("easter_egg_bundle")
	elseif easterEggTab == EasterEggTab.HUNT then
		return LanguageUtils.LocalizeCommon("easter_egg_hunt")
	elseif easterEggTab == EasterEggTab.BREAK then
		return LanguageUtils.LocalizeCommon("easter_egg_break")
	else
		return LanguageUtils.LocalizeCommon("easter_egg_check_in")
	end
end

--- @param easterEggTab EasterEggTab
function UIEventEasterEggView:_GetEventIcon(easterEggTab)
	return ResourceLoadUtils.LoadEventEasterEggIcon(easterEggTab)
end

--- @param easterEggTab EasterEggTab
function UIEventEasterEggView:_GetEventNotification(easterEggTab)
	return self.eventModel:IsTabNotified(easterEggTab)
end

function UIEventEasterEggView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

--- @param easterEggTab EasterEggTab
function UIEventEasterEggView:UpdateNotificationByTab(easterEggTab)
	--- @type UIEventPackageTabItem
	local objTab = self.eventTabDict:Get(easterEggTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventEasterEggView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	self:OnReadyHide()
end

function UIEventEasterEggView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventEasterEggView:CheckAllNotificationTab()
	--- @param v EasterEggTab
	--- @param v UIEventPackageTabItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

function UIEventEasterEggView:_GetEventEndTime(easterEggTab)
	return self.eventModel.timeData.endTime
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventEasterEggView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventMergeServerModel
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

function UIEventEasterEggView:Hide()
	UIBaseView.Hide(self)

	self:RemoveListener()

	self:HideCurrentLayout()

	self:HideScrollTab()
end

function UIEventEasterEggView:HideScrollTab()
	self.scrollLoopTab:Hide()
	self.eventTabDict:Clear()
end

function UIEventEasterEggView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventEasterEggView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

