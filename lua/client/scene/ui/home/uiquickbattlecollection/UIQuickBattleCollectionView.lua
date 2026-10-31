---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiQuickBattleCollection.UIQuickBattleCollectionConfig"

--- @class UIQuickBattleCollectionView : UIBaseView
UIQuickBattleCollectionView = Class(UIQuickBattleCollectionView, UIBaseView)

--- @return void
--- @param model UIQuickBattleCollectionModel
function UIQuickBattleCollectionView:Ctor(model)
	self.resourceType = nil
	self.resourceId = nil
	self.listQuickBattleTicket = List()
	---@type UILoopScroll
	self.uiScroll = nil

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIQuickBattleCollectionModel
	self.model = model
end

--- @return void
function UIQuickBattleCollectionView:OnReadyCreate()
	---@type UIQuickBattleCollectionConfig
	---@type UIQuickBattleCollectionConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)

	--- @param obj QuickBattleItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		obj:SetIconData(self.listQuickBattleTicket:Get(index + 1))
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.QuickBattleItemView, onCreateItem)
end

--- @return void
function UIQuickBattleCollectionView:OnReadyShow(result)
	self.resourceType = result.resourceType
	self.resourceId = result.resourceId
	self.listQuickBattleTicket = ResourceMgr.GetCampaignQuickBattleTicketConfig():GetListQuickBattle(self.resourceType, self.resourceId)
	self.uiScroll:Resize(self.listQuickBattleTicket:Count())

	self.config.gold:SetActive(false)
	self.config.magicPotion:SetActive(false)
	self.config.exp:SetActive(false)
	if self.resourceType == ResourceType.SummonerExp then
		self.config.exp:SetActive(true)
	else
		if self.resourceId == MoneyType.GOLD then
			self.config.gold:SetActive(true)
		elseif self.resourceId == MoneyType.MAGIC_POTION then
			self.config.magicPotion:SetActive(true)
		end
	end
end

function UIQuickBattleCollectionView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("quick_battle")
end

--- @return void
function UIQuickBattleCollectionView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end