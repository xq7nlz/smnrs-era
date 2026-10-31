require "lua.client.scene.ui.common.BattleTeamView"

--- @class UIArenaTeamOpponentInfoView : UIBaseView
UIArenaTeamOpponentInfoView = Class(UIArenaTeamOpponentInfoView, UIBaseView)

--- @return void
--- @param model UIArenaTeamOpponentInfoModel
function UIArenaTeamOpponentInfoView:Ctor(model, ctrl)
	---@type UIArenaTeamOpponentInfoConfig
	self.config = nil
	--- @type VipIconView
	self.heroIconView = nil
	--- @type List
	self.listBattleTeamView = List()
	---@type boolean
	self.isBlock = false

	self.callbackBlock = nil

	-- init variables here
	UIBaseView.Ctor(self, model, ctrl)
	--- @type UIArenaTeamOpponentInfoModel
	self.model = model
end

--- @return void
function UIArenaTeamOpponentInfoView:OnReadyCreate()
	---@type UIArenaTeamOpponentInfoConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.bg.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIArenaTeamOpponentInfoView:InitLocalization()
	self.config.localizeDefensiveLineup.text = UIUtils.SetColorString(UIUtils.brown, LanguageUtils.LocalizeCommon("defense"))
end

--- @return void
function UIArenaTeamOpponentInfoView:OnReadyShow(result)
	if result ~= nil then
		self.config.textUserName.text = result.userName
		if result.playerId ~= nil then
			self.config.textUserId.gameObject:SetActive(true)
			self.config.textGuild.gameObject:SetActive(true)
			self.config.textUserId.text = UIUtils.SetColorString(UIUtils.brown, LanguageUtils.LocalizeCommon("id") .. ": ") ..
					UIUtils.SetColorString(UIUtils.color2, result.playerId)
			self.config.textGuild.text = UIUtils.SetColorString(UIUtils.brown, LanguageUtils.LocalizeFeature(FeatureType.GUILD) .. ": ") ..
					UIUtils.SetColorString(UIUtils.color2, result.guildName)
		else
			self.config.textUserId.gameObject:SetActive(false)
			self.config.textGuild.gameObject:SetActive(false)
		end
		self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.iconHero)
		self.heroIconView:SetData2(result.avatar, result.level)

		self:ReturnPoolBattleTeam()
		local ap = 0
		---@param battleTeamInfo BattleTeamInfo
		for i, battleTeamInfo in ipairs(result.listBattleTeamInfo:GetItems()) do
			if i < 3 then
				local battleTeamView = BattleTeamView(self.config.teamInfo:GetChild(i - 1))
				battleTeamView:Show()
				battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
				battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
				battleTeamView.uiTeamView:ActiveBuff(false)
				battleTeamView.uiTeamView:ActiveLinking(false)
				self.listBattleTeamView:Add(battleTeamView)
				ap = ap + ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo)
			end
		end
		self.config.textApValue.text = tostring(math.floor(ap))
	end
end

--- @return void
function UIArenaTeamOpponentInfoView:ReturnPoolBattleTeam()
	---@param battleTeamView BattleTeamView
	for i, battleTeamView in ipairs(self.listBattleTeamView:GetItems()) do
		battleTeamView:Hide()
	end
	self.listBattleTeamView:Clear()
end

--- @return void
function UIArenaTeamOpponentInfoView:Hide()
	UIBaseView.Hide(self)
	self.heroIconView:ReturnPool()
	self.heroIconView = nil
	self:ReturnPoolBattleTeam()
end