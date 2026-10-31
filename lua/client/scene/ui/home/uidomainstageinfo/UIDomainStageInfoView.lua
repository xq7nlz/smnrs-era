--- @class UIDomainStageInfoView : UIBaseView
UIDomainStageInfoView = Class(UIDomainStageInfoView, UIBaseView)

--- @param model UIDomainStageInfoModel
function UIDomainStageInfoView:Ctor(model)
	--- @type UIDomainStageInfoConfig
	self.config = nil
	--- @type BattleTeamView
	self.battleTeamView = nil
	--- @type ItemsTableView
	self.itemsTableView = nil
	--- @type function
	self.onClickBattle = nil
	--- @type function
	self.onClickRecord = nil
	UIBaseView.Ctor(self, model)
	--- @type UIDomainStageInfoModel
	self.model = model
end

function UIDomainStageInfoView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self.itemsTableView = ItemsTableView(self.config.rewardAnchor)

	self:InitButtons()
end

function UIDomainStageInfoView:InitButtons()
	self.config.bgNone.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonBattle.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		if self.onClickBattle then
			self.onClickBattle()
		end
	end)
	self.config.buttonRecord.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		if self.onClickRecord then
			self.onClickRecord()
		end
	end)
end

function UIDomainStageInfoView:InitLocalization()
	self.config.textTeam.text = LanguageUtils.LocalizeCommon("enemy_team")
	self.config.textReward.text = LanguageUtils.LocalizeCommon("reward")
	self.config.textBattle.text = LanguageUtils.LocalizeCommon("battle")
	self.config.textRecord.text = LanguageUtils.LocalizeCommon("replay_domain")
end

--- @param data {callbackClose, predefineTeamData, listReward, stage, stageStatus}
function UIDomainStageInfoView:OnReadyShow(data)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	data = data or self.data
	UIBaseView.OnReadyShow(self, data)
	if data ~= nil then
		self.data = data
	end

	self.config.textTitle.text = LanguageUtils.LocalizeCommon("stage") .. " " .. self.data.stage

	self:SetButtonCallback(self.data)

	self:ShowRewards(self.data.listReward)

	self:ShowTeamInfo(self.data.predefineTeamData)
end

--- @param data {callbackBattle, callbackRecord}
function UIDomainStageInfoView:SetButtonCallback(data)
	self.config.buttonBattle.gameObject:SetActive(data.callbackBattle ~= nil)
	self.config.buttonRecord.gameObject:SetActive(data.callbackRecord ~= nil)

	self.onClickBattle = data.callbackBattle
	self.onClickRecord = data.callbackRecord
end

--- @param listReward List -- RewardInBound
function UIDomainStageInfoView:ShowRewards(listReward)
	if listReward == nil then
		XDebug.Error("listReward nil")
		return
	end
	self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(listReward))
end

--- @param predefineTeamData PredefineTeamData
function UIDomainStageInfoView:ShowTeamInfo( predefineTeamData)
	if predefineTeamData == nil then
		XDebug.Error("predefineTeamData nil")
		return
	end
	--- @type BattleTeamInfo
	local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeamData)
	self.battleTeamView = BattleTeamView(self.config.battleTeamAnchor)
	self.battleTeamView:Show()

	self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
	self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
	self.battleTeamView.uiTeamView:ActiveBuff(false)
	self.battleTeamView.uiTeamView:ActiveLinking(false)

	local power = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo, false)
	self.config.textCpValue.text = tostring(math.floor(power))
end

function UIDomainStageInfoView:Hide()
	UIBaseView.Hide(self)
	if self.battleTeamView ~= nil then
		self.battleTeamView:Hide()
		self.battleTeamView = nil
	end
	self.itemsTableView:Hide()
end