
--- @class UIGuildWarSelectedSwapMemberView : UIBaseView
UIGuildWarSelectedSwapMemberView = Class(UIGuildWarSelectedSwapMemberView, UIBaseView)

--- @return void
--- @param model UIGuildWarSelectedSwapMemberModel
function UIGuildWarSelectedSwapMemberView:Ctor(model)
	--- @type UIGuildWarSelectedSwapMemberConfig
	self.config = nil
	--- @type BattleTeamView
	self.battleTeamView = nil
	--- @type function
	self.onClickSwapButton = nil
	--- @type VipIconView
	self.iconVip = nil
	UIBaseView.Ctor(self, model)
	--- @type UIGuildWarSelectedSwapMemberModel
	self.model = model
end

--- @return void
function UIGuildWarSelectedSwapMemberView:OnReadyCreate()
	UIBaseView.OnReadyCreate(self)
	--- @type UIGuildWarSelectedSwapMemberConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:_InitButtonListener()
end

function UIGuildWarSelectedSwapMemberView:InitLocalization()
	self.config.textCancel.text = LanguageUtils.LocalizeCommon("cancel")
	self.config.textSwapMember.text = LanguageUtils.LocalizeCommon("swap_member")
end

function UIGuildWarSelectedSwapMemberView:_InitButtonListener()
	self.config.buttonCancel.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBackOrClose()
	end)
	self.config.buttonSwapMember.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickSwapMember()
	end)
	self.config.bgNone.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBackOrClose()
	end)
end

--- @param data	{}
function UIGuildWarSelectedSwapMemberView:OnReadyShow(data)
	local guildWarPlayerInBound = data.guildWarPlayerInBound
	self.onClickSwapButton = data.onClickSwapButton
	self.config.buttonSwapMember.gameObject:SetActive(self.onClickSwapButton ~= nil)

	self:SetMemberData(guildWarPlayerInBound, data.medal)
end

--- @param guildWarPlayerInBound GuildWarPlayerInBound
function UIGuildWarSelectedSwapMemberView:SetMemberData(guildWarPlayerInBound, medal)
	local compactPlayerInfo = guildWarPlayerInBound.compactPlayerInfo
	self.config.playerName.text = compactPlayerInfo.playerName
	self.config.textMedal.text = medal
	self.config.textSlot.text = guildWarPlayerInBound.positionInGuildWarBattle

	if self.iconVip == nil then
		self.iconVip = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.avatarAnchor)
	end
	self.iconVip:SetData2(compactPlayerInfo.playerAvatar, compactPlayerInfo.playerLevel)

	self:ShowTeamInfo(compactPlayerInfo)
end

--- @param compactPlayerInfo OtherPlayerInfoInBound
function UIGuildWarSelectedSwapMemberView:ShowTeamInfo(compactPlayerInfo)
	--- @type SummonerBattleInfo
	local summonerBattleInfo = compactPlayerInfo.summonerBattleInfoInBound.summonerBattleInfo
	--- @type BattleTeamInfo
	local battleTeamInfo = compactPlayerInfo:CreateBattleTeamInfo(compactPlayerInfo.playerLevel)

	self.battleTeamView = BattleTeamView(self.config.defenderTeamAnchor)
	self.battleTeamView:Show()

	self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
	self.battleTeamView.uiTeamView:SetSummonerInfo(summonerBattleInfo)
	self.battleTeamView.uiTeamView:ActiveBuff(false)
	self.battleTeamView.uiTeamView:ActiveLinking(false)

	--self.battleTeamView:SetSummonerTransform(U_Vector3(-554, 109, 0), U_Vector3.one * 1.45)

	local power = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo, false)
	self.config.textCpValue.text = tostring(math.floor(power))
	self.config.guildNameText.text = LanguageUtils.LocalizeFeature(FeatureType.GUILD) .. " " .. UIUtils.SetColorString(UIUtils.color2, compactPlayerInfo.guildName)
end

function UIGuildWarSelectedSwapMemberView:OnClickSwapMember()
	self:OnReadyHide()
	if self.onClickSwapButton ~= nil then
		self.onClickSwapButton()
	end
end

function UIGuildWarSelectedSwapMemberView:Hide()
	UIBaseView.Hide(self)
	if self.battleTeamView ~= nil then
		self.battleTeamView:Hide()
		self.battleTeamView = nil
	end
	if self.iconVip ~= nil then
		self.iconVip:ReturnPool()
		self.iconVip = nil
	end
end

