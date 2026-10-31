---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiGuildDonateHistory.UIGuildDonateHistoryConfig"

--- @class UIGuildDonateHistoryView : UIBaseView
UIGuildDonateHistoryView = Class(UIGuildDonateHistoryView, UIBaseView)

--- @return void
--- @param model UIGuildDonateHistoryModel
function UIGuildDonateHistoryView:Ctor(model)
	--- @type UILoopScroll
	self.uiScroll = nil

	---@type List
	self.listDonate = List()

	UIBaseView.Ctor(self, model)
	--- @type UIGuildDonateHistoryModel
	self.model = model
end

function UIGuildDonateHistoryView:OnReadyCreate()
	---@type UIGuildDonateHistoryConfig
	---@type UIGuildDonateHistoryConfig
	self.config = UIBaseConfig(self.uiTransform)

	--- @param obj GuildDonateHistoryItemView
	--- @param index number
	local onCreateItem = function(obj, index)
		obj:SetIconData(self.listDonate:Get(index + 1))
	end
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.GuildDonateHistoryItemView, onCreateItem)

	self:InitButtonListener()
end

function UIGuildDonateHistoryView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_donate_history")
end

function UIGuildDonateHistoryView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBg.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIGuildDonateHistoryView:OnReadyShow(result)
	--- @param buffer UnifiedNetwork_ByteBuf
	local onBufferReading = function(buffer)
		require "lua.client.core.network.playerData.guildQuest.GuildQuestData"
		self.guildQuestModel = GuildQuestData(buffer)
		if self.guildQuestModel.dictUserDonate ~= nil then
			self.listDonate:Clear()
			---@param v EventGuildQuestDonationBoardInBound
			for i, v in pairs(self.guildQuestModel.dictUserDonate:GetItems()) do
				v.playerId = i
				self.listDonate:Add(v)
			end
		end
		self.uiScroll:Resize(self.listDonate:Count())
		self.config.empty.gameObject:SetActive(self.listDonate:Count() < 1)
	end
	NetworkUtils.RequestAndCallback(OpCode.EVENT_GUILD_QUEST_DATA_GET,nil, nil,nil,onBufferReading)

end