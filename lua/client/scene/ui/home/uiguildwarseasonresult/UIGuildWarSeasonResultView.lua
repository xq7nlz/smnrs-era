
--- @class UIGuildWarSeasonResultView : UIBaseView
UIGuildWarSeasonResultView = Class(UIGuildWarSeasonResultView, UIBaseView)

--- @return void
--- @param model UIGuildWarSeasonResultModel
function UIGuildWarSeasonResultView:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIGuildWarSeasonResultModel
	self.model = model
end

--- @return void
function UIGuildWarSeasonResultView:OnReadyCreate()
	---@type UIGuildWarSeasonRewardConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()
end

--- @return void
function UIGuildWarSeasonResultView:InitButtonListener()
	self.config.buttonTapToClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonGoToMail.onClick:AddListener(function ()
		self:OnClickGoToMail()
	end)
end

--- @return void
---@param result GuildWarPreviousSeasonResultInBound
function UIGuildWarSeasonResultView:OnReadyShow(result)
	--- @type GuildRole
	local role = ClientConfigUtils.GetGuildRole()

	local ranking = result.rankingOder + 1
	self.config.point.text = tostring(result.elo)
	self.config.rank.text = tostring(ranking)

	---@type RankingRewardByRangeConfig
	local rewardRanking = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig()
			:GetGuildWarSeasonRewardConfig():GetRankingRewardByRangeConfig(ranking)
	if rewardRanking ~= nil then
		---@type List
		self.listReward = List()
		for _, v in pairs(rewardRanking:GetListRewardItemIconByGuildRole(role):GetItems()) do
			---@type IconView
			local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.content)
			iconView:SetIconData(v)
			iconView:RegisterShowInfo()
			self.listReward:Add(iconView)
		end
	end
	Coroutine.start(function ()
		local touchObject = TouchUtils.Spawn("UIGuildWarSeasonResultView")
		coroutine.waitforseconds(0.5)
		touchObject:Enable()
	end)
end

--- @return void
function UIGuildWarSeasonResultView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("season_end_reward")
	self.config.pointTitle.text = LanguageUtils.LocalizeCommon("guild_war_point")
	self.config.season.text = LanguageUtils.LocalizeCommon("guild_war_season_end")
	self.config.textReward.text = LanguageUtils.LocalizeCommon("reward")
	self.config.textTapToClose.gameObject:SetActive(false)
	self.config.textGoToMail.text = LanguageUtils.LocalizeCommon("go_to_mail")
end

--- @return void
function UIGuildWarSeasonResultView:Hide()
	UIBaseView.Hide(self)
	if self.listReward ~= nil then
		---@param v IconView
		for _, v in pairs(self.listReward:GetItems()) do
			v:ReturnPool()
		end
		self.listReward:Clear()
	end
end

--- @return void
function UIGuildWarSeasonResultView:OnClickGoToMail()
	FeatureMapping.GoToFeature(FeatureType.MAIL, false, function ()
		PopupMgr.HidePopup(self.model.uiName)
		PopupMgr.HidePopup(UIPopupName.UIGuildArea)
	end)
end