---COMMENT_CONFIG_HOME    require "lua.client.scene.ui.home.uiDungeonMonsterReview.UIDungeonMonsterReviewConfig"
require "lua.client.scene.ui.common.BattleTeamView"

--- @class UIDungeonMonsterReviewView : UIBaseView
UIDungeonMonsterReviewView = Class(UIDungeonMonsterReviewView, UIBaseView)

--- @return void
--- @param model UIDungeonMonsterReviewModel
function UIDungeonMonsterReviewView:Ctor(model)
	--- @type UIDungeonMonsterReviewConfig
	self.config = nil
	--- @type BattleTeamView
	self.battleTeamView = nil
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIDungeonMonsterReviewModel
	self.model = model
end

--- @return void
function UIDungeonMonsterReviewView:OnReadyCreate()
	---@type UIDungeonMonsterReviewConfig
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtonListener()
	self:InitTeamView()
end

--- @return void
function UIDungeonMonsterReviewView:InitLocalization()
	self.config.localizeTitle.text = LanguageUtils.LocalizeCommon("defense")
end

--- @return void
function UIDungeonMonsterReviewView:InitButtonListener()
	self.config.bgFog.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIDungeonMonsterReviewView:InitTeamView()
	self.battleTeamView = BattleTeamView(self.config.team)
end

--- @param battleTeamInfo BattleTeamInfo
function UIDungeonMonsterReviewView:OnReadyShow(battleTeamInfo)
	zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
	self.battleTeamView:Show()
	self.battleTeamView:SetDataDefender(UIPoolType.DungeonHeroIconView, battleTeamInfo)
	self.battleTeamView:DisableMainHero()
	self.battleTeamView.uiTeamView:ActiveBuff(false)
	self.battleTeamView.uiTeamView:ActiveLinking(false)
end

--- @return void
function UIDungeonMonsterReviewView:Hide()
	UIBaseView.Hide(self)
	self.battleTeamView:Hide()
end

