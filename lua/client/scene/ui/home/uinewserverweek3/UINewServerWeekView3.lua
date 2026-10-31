require "lua.client.scene.ui.home.uiNewServerWeek3.UINewServerWeekModel3"
require "lua.client.scene.ui.home.uiNewServerWeek.UINewServerWeekView"
local pivotTab = U_Vector2(0.865, 0.5)
--- @class UINewServerWeekView3 : UIBaseView
UINewServerWeekView3 = Class(UINewServerWeekView3, UINewServerWeekView)

--- @param model UINewServerWeekModel
function UINewServerWeekView3:Ctor(model)
	UINewServerWeekView.Ctor(self,model)
	--- @type UINewServerConfig3
	self.config = nil
end

function UINewServerWeekView3:_GetEventEndTime(newServerWeek)
	return self.eventNewServerWeekModel.timeData.endTime
end

--- @param newServerWeek NewServerWeekTab3
function UINewServerWeekView3:_GetEventName(newServerWeek)
	if newServerWeek == NewServerWeekTab3.GROW_UP then
		return LanguageUtils.LocalizeCommon("event_grow_up")
	elseif newServerWeek == NewServerWeekTab3.CAMPAIGN_BOOT then
		return LanguageUtils.LocalizeCommon("event_campaign_boot")
	elseif newServerWeek == NewServerWeekTab3.FORTRESS then
		return LanguageUtils.LocalizeCommon("fortress")
	elseif newServerWeek == NewServerWeekTab3.BUNDLE then
		return LanguageUtils.LocalizeCommon("event_bundle_new_server_week")
	else
		return LanguageUtils.LocalizeCommon("event_grow_up")
	end
end


--- @param newServerWeek NewServerWeekTab3
function UINewServerWeekView3:GetLayout(newServerWeek)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(newServerWeek)
	if self.layout == nil then
		if newServerWeek == NewServerWeekTab3.GROW_UP then
			require "lua.client.scene.ui.home.uiNewServerWeek3.uiNewServerWeekLayout.EventGrowUp.UIGrowUpLayout3"
			self.layout = UIGrowUpLayout3(self, newServerWeek, self.config.growUp)
		elseif newServerWeek == NewServerWeekTab3.CAMPAIGN_BOOT then
			require "lua.client.scene.ui.home.uiNewServerWeek3.uiNewServerWeekLayout.EventCampaignBoot.UICampaignBootLayout3"
			self.layout = UICampaignBootLayout3(self, newServerWeek, self.config.campaignBoot)
		elseif newServerWeek == NewServerWeekTab3.FORTRESS then
			require "lua.client.scene.ui.home.uiNewServerWeek3.uiNewServerWeekLayout.EventFortress.UIFortressLayout"
			self.layout = UIFortressLayout(self, newServerWeek, self.config.fortress)
		elseif newServerWeek == NewServerWeekTab3.BUNDLE then
			require "lua.client.scene.ui.home.uiNewServerWeek3.uiNewServerWeekLayout.Bundle.UINewServerWeekBundleLayout3"
			self.layout = UINewServerWeekBundle3Layout(self, newServerWeek, self.config.bundle)
		else
			XDebug.Error("Missing layout type " .. newServerWeek)
			return nil
		end
		self.layoutDict:Add(newServerWeek, self.layout)
	end
end


function UINewServerWeekView3:DisableCommon()
	self:HideCurrentLayout()
	self.config.growUp.gameObject:SetActive(false)
	self.config.campaignBoot.gameObject:SetActive(false)
	self.config.fortress.gameObject:SetActive(false)
	self.config.bundle.gameObject:SetActive(false)
end

--- @param data {callbackClose : function}
function UINewServerWeekView3:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.eventNewServerWeekModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_3)
	local isOpen = self.eventNewServerWeekModel:IsOpening()
	if isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	--self:CheckEndSeasonDisplay()
	self:InitListSubTabEvent()
	if self.listSubTabEvent:Count() > 0 then
		self:SelectTab(self.listSubTabEvent:Get(NewServerWeekTab3.GROW_UP))
		self.scrollLoopTab:Resize(self.listSubTabEvent:Count())
		--self:CheckAllNotificationTab()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
		self:OnReadyHide()
	end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UINewServerWeekView3:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventNewServerWeekModel
			local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_3)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				--zg.playerData.remoteConfig.lastTimeDurationBlackFriday = nil
				--zg.playerData:SaveRemoteConfig()
				if PopupUtils.IsPopupShowing(UIPopupName.UINewServerWeek3) == false then
					return
				end
				PopupMgr.HidePopup(UIPopupName.UINewServerWeek3)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end


function UINewServerWeekView3:InitListSubTabEvent()
	self.listSubTabEvent:Clear()
	local  eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_3)
	local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
	if  isOpening then
		self.listSubTabEvent:Add(NewServerWeekTab3.GROW_UP)
		self.listSubTabEvent:Add(NewServerWeekTab3.CAMPAIGN_BOOT)
		self.listSubTabEvent:Add(NewServerWeekTab3.FORTRESS)
		self.listSubTabEvent:Add(NewServerWeekTab3.BUNDLE)
	end
end

function UINewServerWeekView3:OnClickHelpInfo()
	local content = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeHelpInfo("help_new_server_week_3"),
			LanguageUtils.LocalizeCommon("event_grow_up"),
			LanguageUtils.LocalizeCommon("event_campaign_boot"),
			LanguageUtils.LocalizeCommon("fortress"),
			LanguageUtils.LocalizeCommon("event_bundle_new_server_week")
	)
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, content)
end

--- @param tabId NewServerWeekTab3
function UINewServerWeekView3:_GetEventIcon(tabId)
	return ResourceLoadUtils.LoadEventNewServerWeek3(tabId)
end