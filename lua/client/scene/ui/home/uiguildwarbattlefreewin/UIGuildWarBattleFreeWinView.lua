--- @class UIGuildWarBattleFreeWinView : UIBaseView
UIGuildWarBattleFreeWinView = Class(UIGuildWarBattleFreeWinView, UIBaseView)

--- @return void
--- @param model UIGuildWarBattleFreeWinModel
function UIGuildWarBattleFreeWinView:Ctor(model)
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIGuildWarBattleFreeWinModel
	self.model = model
end

--- @return void
function UIGuildWarBattleFreeWinView:OnReadyCreate()
	---@type UIFreeVictoryGuildWarConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	--self.config.buttonGoToMail.onClick:AddListener(function ()
	--	self:OnClickGoToMail()
	--end)
	self.config.buttonGoToMail.gameObject:SetActive(false)
end

--- @return void
function UIGuildWarBattleFreeWinView:OnClickGoToMail()
	FeatureMapping.GoToFeature(FeatureType.MAIL, false, function ()
		PopupMgr.HidePopup(self.model.uiName)
		PopupMgr.HidePopup(UIPopupName.UIGuildArea)
	end)
end

--- @return void
function UIGuildWarBattleFreeWinView:InitLocalization()
	self.config.localizeTapToClose.gameObject:SetActive(false)
	self.config.textRankingPointGuild.text = LanguageUtils.LocalizeCommon("point")
	self.config.textGoToMail.text = LanguageUtils.LocalizeCommon("go_to_mail")
end

--- @return void
function UIGuildWarBattleFreeWinView:OnReadyShow(result)
	---@type GuildWarInBound
	local guildInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR)
	if guildInBound ~= nil then
		self.config.textGuildName.text = guildInBound.guildName
		self.config.iconGuildSymbol.sprite = ResourceLoadUtils.LoadGuildIcon(guildInBound.guildAvatar)
		self.config.textRankingPoint.text = tostring(ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarEloPositionConfig():GetTotalElo())
	end

	Coroutine.start(function ()
		local touchObject = TouchUtils.Spawn("UIGuildWarBattleFreeWinView")
		coroutine.waitforseconds(0.5)
		touchObject:Enable()
	end)
	self:PlayEffect()
end

--- @return void
function UIGuildWarBattleFreeWinView:PlayEffect()
	zg.audioMgr:PlaySfxUi(SfxUiType.VICTORY)
	self:PlayVictoryAnim()

	Coroutine.start(function()
		coroutine.waitforseconds(10.0 / ClientConfigUtils.FPS)
		self:EnableFxVictory(true)
	end)
	self.config.bgPannel.sizeDelta = U_Vector2(125, 50)
	DOTweenUtils.DOSizeDelta(self.config.bgPannel, U_Vector2(2400, 50), 0.5)
end

function UIGuildWarBattleFreeWinView:PlayVictoryAnim()
	self.config.victoryAnim.AnimationState:ClearTracks()
	self.config.victoryAnim.Skeleton:SetToSetupPose()

	local trackEntry = self.config.victoryAnim.AnimationState:SetAnimation(0, "start", false)
	trackEntry:AddCompleteListenerFromLua(function()
		self.config.victoryAnim.AnimationState:SetAnimation(0, "loop", true)
		self:OnFinishAnimation()
	end)
end

--- @param isEnable boolean
function UIGuildWarBattleFreeWinView:EnableFxVictory(isEnable)
	self.config.vfxVictory:SetActive(isEnable)
end