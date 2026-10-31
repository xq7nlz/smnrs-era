---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildDonateHelp.UIGuildDonateHelpConfig"

--- @class UIGuildDonateHelpView : UIBaseView
UIGuildDonateHelpView = Class(UIGuildDonateHelpView, UIBaseView)

--- @return void
--- @param model UIGuildDonateHelpModel
function UIGuildDonateHelpView:Ctor(model)
	---@type List
	self.listItem1 = List()
	---@type List
	self.listItem2 = List()
	---@type List
	self.listItemView = List()

	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIGuildDonateHelpModel
	self.model = model
end

function UIGuildDonateHelpView:OnReadyCreate()
	---@type UIGuildDonateHelpConfig
	---@type UIGuildDonateHelpConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()

	self.uiScroll1 = self:CreateScroll(self.config.loopScrollRectLeft, self.listItem1, MoneyType.EVENT_GUILD_QUEST_APPLE)
	self.uiScroll2 = self:CreateScroll(self.config.loopScrollRectRight, self.listItem2, MoneyType.EVENT_GUILD_QUEST_PEAR)
end

---@return UILoopScroll
function UIGuildDonateHelpView:CreateScroll(transform, list, moneyType)
	--- @param obj DonateHelpItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		obj:SetIconData(list:Get(index + 1), moneyType)
	end
	return UILoopScroll(transform, UIPoolType.DonateHelpItemView, onCreateItem)
end

function UIGuildDonateHelpView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_donate_help")
end

function UIGuildDonateHelpView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIGuildDonateHelpView:OnReadyShow()
	self:InitData(1)
	self:CreateItemView()
end

function UIGuildDonateHelpView:InitData(id)
	self.listItem1:Clear()
	self.listItem2:Clear()
	---@param v QuestRewardActivity
	for _, v in pairs(ResourceMgr.GetGuildQuestRewardActivityConfig():GetDataFromId(id):GetItems()) do
		if v:GetRewardMoneyType(MoneyType.EVENT_GUILD_QUEST_APPLE) ~= nil then
			self.listItem1:Add(v)
		end
		if v:GetRewardMoneyType(MoneyType.EVENT_GUILD_QUEST_PEAR) ~= nil then
			self.listItem2:Add(v)
		end
	end
end

function UIGuildDonateHelpView:CreateItemView()
	self.uiScroll1:Resize(self.listItem1:Count())
	self.uiScroll2:Resize(self.listItem2:Count())
end