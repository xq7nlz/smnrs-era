
--- @class UIEventBlackFridayNewVersionView : UIBaseView
UIEventBlackFridayNewVersionView = Class(UIEventBlackFridayNewVersionView, UIBaseView)

--- @param model UIEventBlackFridayNewVersionModel
function UIEventBlackFridayNewVersionView:Ctor(model)
	--- @type UIEventBlackFridayNewVersionConfig
	self.config = nil
	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type
	self.layout = nil
	--- @type EventBlackFridayNewVersionModel
	self.eventModel = nil
	---@type EventBlackFridayNewVersionConfig
	self.eventConfig = nil

	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY_SALE
	--- @type boolean
	self.isReloadingData = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventBlackFridayNewVersionModel
	self.model = model
end

function UIEventBlackFridayNewVersionView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
end

function UIEventBlackFridayNewVersionView:InitButtons()
	self.config.close.onClick:RemoveAllListeners()
	self.config.close.onClick:AddListener(function()
		self:Hide()
		self:DisableCommon()
	end)
end

function UIEventBlackFridayNewVersionView:InitLocalization()

end

--- @param data {callbackClose : function}
function UIEventBlackFridayNewVersionView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	self.isOpen = self.eventModel:IsOpening()
	self.model:InitListSubEvent()

	if self.isOpen then
		if self.model.listSubEvent:Count() > 0 then
			if data ~= nil and data.tab ~= nil then
				self:OnClickSelectTab(data.tab)
			else
				if self.eventModel.listCustomizePack:Count() > 0 then
					if self.eventModel.listCustomizePack:Get(1).listOfSelectedItem:Count() > 0 then
						self:SelectTab(self.model.listSubEvent:Get(2))
					else
						self:SelectTab(self.model.listSubEvent:Get(1))
					end
				else
					self:SelectTab(self.model.listSubEvent:Get(1))
				end
			end
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			self:OnReadyHide()
		end
	else
		self:SelectTab(self.model.listSubEvent:Get(1))
	end
end

function UIEventBlackFridayNewVersionView:OnClickSelectTab(eventBlackFridayNewTab)
	if self:IsTabChosen(eventBlackFridayNewTab) then
		return
	end
	self:SelectTab(eventBlackFridayNewTab)
end

--- @param eventBlackFridayNewTab EventBlackFridayNewVersionTab
function UIEventBlackFridayNewVersionView:IsTabChosen(eventBlackFridayNewTab)
	return self.layout ~= nil and self.layout.eventTab == eventBlackFridayNewTab
end

function UIEventBlackFridayNewVersionView:SelectTab(eventBlackFridayNewTab)
	self:GetLayout(eventBlackFridayNewTab)
	self.layout:OnShow()
end

--- @param eventBlackFridayNewTab EventBlackFridayNewVersionTab
function UIEventBlackFridayNewVersionView:GetLayout(eventBlackFridayNewTab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(eventBlackFridayNewTab)
	if self.layout == nil then
		if eventBlackFridayNewTab == EventBlackFridayNewVersionTab.SELECT_ITEM then
			require "lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.select_item_layout.UIEventBlackFridayNewCustomizeBundleLayout"
			self.layout = UIEventBlackFridayNewCustomizeBundleLayout(self, eventBlackFridayNewTab, self.config.select_item_anchor)
		elseif eventBlackFridayNewTab == EventBlackFridayNewVersionTab.SUPER_DEAL then
			require "lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.super_deal_layout.UIEventBlackFridayNewSuperDealLayout"
			self.layout = UIEventBlackFridayNewSuperDealLayout(self, eventBlackFridayNewTab, self.config.super_deal_anchor)
		else
			require "lua.client.scene.ui.home.uiEventBlackFridayNewVersion.eventLayout.select_item_layout.UIEventBlackFridayNewCustomizeBundleLayout"
			self.layout = UIEventBlackFridayNewCustomizeBundleLayout(self, eventBlackFridayNewTab, self.config.select_item_anchor)
		end
		self.layoutDict:Add(eventBlackFridayNewTab, self.layout)
	end
end

function UIEventBlackFridayNewVersionView:DisableCommon()
	self:HideCurrentLayout()
	self.config.select_item_anchor.gameObject:SetActive(false)
	self.config.super_deal_anchor.gameObject:SetActive(false)
end

function UIEventBlackFridayNewVersionView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end
