---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiPopupRewardArena.UIPopupRewardArenaConfig"
--- @class UIPopupRewardArenaView : UIBaseView
UIPopupRewardArenaView = Class(UIPopupRewardArenaView, UIBaseView)

--- @return void
--- @param model UIPopupRewardArenaModel
function UIPopupRewardArenaView:Ctor(model)
	---@type List
	self.listReward = List()
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIPopupRewardArenaModel
	self.model = model
end

--- @return void
function UIPopupRewardArenaView:OnReadyCreate()
	---@type UIPopupRewardArenaConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()
end

--- @return void
function UIPopupRewardArenaView:InitButtonListener()
	self.config.buttonTapToClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonGoToMail.onClick:AddListener(function ()
		self:OnClickGoToMail()
	end)
end

--- @return void
---@param result ArenaPreviousSeasonInBound
function UIPopupRewardArenaView:OnReadyShow(result)
	self.featureType = result.featureType
	if result ~= nil then
		self.callbackGotoMail = result.callbackGotoMail
		self.config.textPoint.text = string.format(self.localizeResetElo, ResourceMgr.GetArenaResetConfig():GetEloReset(result.rankingType))
		local rank = result.rankingOder + 1
		if rank == 1 then
			self.config.textChampion.text = self.localizeChampion
		else
			self.config.textChampion.text = StringUtils.FormatLocalizeStart1(self.localizeTop, rank)
		end
		self.config.icon.sprite = ClientConfigUtils.GetIconRankingArenaByRankType(
				result.rankingType, rank, self.featureType)
		self.config.icon:SetNativeSize()
		---@type ArenaRewardRankingConfig
		local rewardRanking = ResourceMgr.GetArenaRewardRankingConfig():GetArenaRewardRankingConfigByRankType(result.rankingType,
				rank, self.featureType)
		if rewardRanking ~= nil then
			for _, v in pairs(rewardRanking.listRewardItem:GetItems()) do
				---@type IconView
				local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.content)
				iconView:SetIconData(v)
				iconView:RegisterShowInfo()
				self.listReward:Add(iconView)
			end
		end
	end
end

--- @return void
function UIPopupRewardArenaView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("season_end_reward")
	self.config.textReward.text = LanguageUtils.LocalizeCommon("reward_area_end")
	self.config.textTapToClose.gameObject:SetActive(false)
	self.localizeResetElo = LanguageUtils.LocalizeCommon("arena_point_reset")
	self.localizeTop = LanguageUtils.LocalizeCommon("top_x")
	self.localizeChampion = LanguageUtils.LocalizeCommon("champion")
	self.config.textGoToMail.text = LanguageUtils.LocalizeCommon("go_to_mail")
end

--- @return void
function UIPopupRewardArenaView:Hide()
	UIBaseView.Hide(self)
	---@param v IconView
	for _, v in pairs(self.listReward:GetItems()) do
		v:ReturnPool()
	end
	self.listReward:Clear()
end

--- @return void
function UIPopupRewardArenaView:OnClickGoToMail()
	FeatureMapping.GoToFeature(FeatureType.MAIL, false, function ()
		PopupMgr.HidePopup(UIPopupName.UIPopupRewardArena)
		if self.callbackGotoMail ~= nil then
			self.callbackGotoMail()
		end
	end)
end