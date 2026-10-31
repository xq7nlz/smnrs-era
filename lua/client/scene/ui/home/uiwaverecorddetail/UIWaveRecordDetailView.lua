
--- @class UIWaveRecordDetailView : UIBaseView
UIWaveRecordDetailView = Class(UIWaveRecordDetailView, UIBaseView)

--- @return void
--- @param model UIWaveRecordDetailModel
function UIWaveRecordDetailView:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIWaveRecordDetailModel
	self.model = model
end

--- @return void
function UIWaveRecordDetailView:OnReadyCreate()
	---@type UIWaveRecordDetailConfig
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()
end

function UIWaveRecordDetailView:InitLocalization()
end

function UIWaveRecordDetailView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.button.onClick:AddListener(function ()
		if self.callbackReplay ~= nil then
			self.callbackReplay()
		end
	end)
end

--- @param result {tower, wave}
function UIWaveRecordDetailView:OnReadyShow(result)
	self.config.tittle.text = string.format("%s %s - %s %s",
			LanguageUtils.LocalizeCommon("tower"), result.tower,
			LanguageUtils.LocalizeCommon("wave"), result.wave)
	self.callbackReplay = result.callbackReplay
	if self.battleTeamView == nil then
		--- @type BattleTeamView
		self.battleTeamView = BattleTeamView(self.config.formation)
	end

	self.battleTeamView:Show()
	self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, result.battleTeamInfo, nil, true)
	self.battleTeamView.uiTeamView:SetSummonerInfo(result.battleTeamInfo.summonerBattleInfo)
	self.battleTeamView.uiTeamView:ActiveBuff(false)
	self.battleTeamView.uiTeamView:ActiveLinking(false)
end

function UIWaveRecordDetailView:Hide()
	self.battleTeamView:Hide()
	self.battleTeamView = nil
	UIBaseView.Hide(self)
end