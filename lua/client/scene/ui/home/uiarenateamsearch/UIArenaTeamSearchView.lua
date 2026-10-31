
--- @class UIArenaTeamSearchView : UIBaseView
UIArenaTeamSearchView = Class(UIArenaTeamSearchView, UIBaseView)

--- @return void
--- @param model UIArenaTeamSearchModel
function UIArenaTeamSearchView:Ctor(model)
	--- @type UIArenaChooseRivalConfig
	self.config = nil
	--- @type List
	self.listArenaItemView = List()
	--- @type ArenaData
	self.arenaData = nil
	---@type PlayerSummonerInBound
	self.summonerInbound = nil
	---@type boolean
	self.unlockSkip = false
	---@type boolean
	self.needRequestArena = false
	-- init variables here
	UIBaseView.Ctor(self, model)
	--- @type UIArenaTeamSearchModel
	self.model = model
end

--- @return void
function UIArenaTeamSearchView:OnReadyCreate()
	---@type UIArenaTeamSearchConfig
	self.config = UIBaseConfig(self.uiTransform)

	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonChange.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickChangeFormation()
	end)
	self.config.buttonRefresh.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickRefresh()
	end)
	self.config.buttonSkip.onClick:AddListener(function()
		self:OnClickSkip()
	end)
end

function UIArenaTeamSearchView:OnClickChangeFormation()
	local result = {}
	result.callbackUpdateFormation = self.callbackUpdateFormation
	PopupMgr.ShowPopup(UIPopupName.UIChangeFormationArenaTeam, result)
end

--- @return void
function UIArenaTeamSearchView:OnReadyShow(result)
	self.callbackUpdateFormation = result.callbackUpdateFormation
	self.summonerInbound = zg.playerData:GetMethod(PlayerDataMethod.SUMMONER)
	self.arenaData = zg.playerData:GetArenaData()
	if self.cache ~= true then
		self:CreateListOpponent()
	end
	self.unlockSkip = ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.BATTLE_SKIP_PRE, false)
	self.config.buttonSkip.gameObject:SetActive(true)
	self:UpdateSkip()

	self.subscriptionRefresh = RxMgr.arenaChooseRivalRefresh:Subscribe(function()
		self:OnClickRefresh()
	end)
end

--- @return void
function UIArenaTeamSearchView:InitLocalization()
	self.config.titleChooseRival.text = LanguageUtils.LocalizeCommon("choose_rival")
	self.config.localizeChange.text = LanguageUtils.LocalizeCommon("defense_your_team")
	self.config.localizeRefresh.text = LanguageUtils.LocalizeCommon("refresh")
	self.config.localizeSkipBattle.text = LanguageUtils.LocalizeCommon("skip_battle")
	self.config.textTapToClose.gameObject:SetActive(false)
end

--- @return void
function UIArenaTeamSearchView:CreateListOpponent()
	---@type ArenaTeamOpponentInBound
	local arenaOpponentInBound = zg.playerData.arenaTeamOpponentInBound
	---@type List
	local listOpponent = List()
	---@param v ArenaOpponentInfo
	for i, v in pairs(arenaOpponentInBound.listArenaTeamOpponent:GetItems()) do
		listOpponent:Add(v)
	end
	---@param v ArenaBotOpponentInfo
	for i, v in pairs(arenaOpponentInBound.listArenaTeamBot:GetItems()) do
		listOpponent:Add(v)
	end
	local count = math.min(listOpponent:Count(), 3)
	for _ = 1, count do
		---@type ArenaTeamOpponentItemView
		local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ArenaTeamOpponentItemView, self.config.content)
		local randomNumber = math.random(1, listOpponent:Count())
		item:SetData(listOpponent:Get(randomNumber))
		listOpponent:RemoveByIndex(randomNumber)
		item.callbackClickBattle = function()
			self:OnClickBattle(item)
		end
		self.listArenaItemView:Add(item)
	end
end

--- @return void
function UIArenaTeamSearchView:ClearListOpponent()
	---@param v ArenaBattleItemView
	for _, v in pairs(self.listArenaItemView:GetItems()) do
		v:ReturnPool()
	end
	self.listArenaItemView:Clear()
end

--- @return void
function UIArenaTeamSearchView:CheckRefreshArena(callbackSuccess)
	if self.needRequestArena then
		PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.ARENA_TEAM }, function()
			RxMgr.arenaRefresh:Next()
			if callbackSuccess ~= nil then
				callbackSuccess()
			end
		end, nil, true, true)
		self.needRequestArena = false
	elseif callbackSuccess ~= nil then
		callbackSuccess()
	end
end

--- @return void
function UIArenaTeamSearchView:OnClickBackOrClose()
	self.cache = nil
	self:CheckRefreshArena(function()
		UIBaseView.OnClickBackOrClose(self)
	end)
end

--- @return void
function UIArenaTeamSearchView:Hide()
	UIBaseView.Hide(self)
	if self.cache ~= true then
		self:ClearListOpponent()
	end
	if self.subscriptionRefresh ~= nil then
		self.subscriptionRefresh:Unsubscribe()
	end
	self.needRequestArena = false
end

--- @return void
function UIArenaTeamSearchView:OnClickChange()
	local data = {}
	data.gameMode = GameMode.ARENA
	data.callbackClose = function()
		PopupMgr.ShowAndHidePopup(UIPopupName.UIArena2, nil, UIPopupName.UIFormation2)
		PopupMgr.ShowPopup(UIPopupName.UIArenaChooseRival)
	end
	data.callbackPlayBattle = function(uiFormationTeamData, callback, power)
		ArenaRequest.SetFormationArena(uiFormationTeamData, function()
			UIArena2View.OverridePower(power)
			PopupMgr.ShowAndHidePopup(UIPopupName.UIArena2, nil, UIPopupName.UIFormation2)
			PopupMgr.ShowPopup(UIPopupName.UIArenaChooseRival)
			--self:ShowBattle()
		end)
	end
	self.cache = true
	PopupMgr.ShowAndHidePopup(UIPopupName.UIFormation2, data, UIPopupName.UIArenaChooseRival, UIPopupName.UIArena2)
end

--- @return void
---@param arenaBattleItemView ArenaTeamOpponentItemView
function UIArenaTeamSearchView:OnClickBattle(arenaBattleItemView)
	local canClackBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.ARENA_TEAM_TICKET, 1))
	if canClackBattle then
		local isSkip = self:IsSkipBattle()
		local resultBattleClose = function()
			RxMgr.arenaChooseRivalRefresh:Next()
		end
		---@param arenaChallengeRewardInBound ArenaChallengeRewardInBound
		---@param battleTeamInfo BattleTeamInfo
		local battleSuccess = function(arenaChallengeRewardInBound, battleTeamInfo)
			self.needRequestArena = true
			---@type ArenaData
			local arenaData = zg.playerData:GetArenaData()
			if arenaData.arenaTeamRecordDataInBound ~= nil then
				arenaData.arenaTeamRecordDataInBound.needRequest = true
			end
			self.cache = nil
			ArenaRequest.RequestArenaOpponent()
		end
		arenaBattleItemView.arenaOpponentInfo:RequestBattle(battleSuccess, nil, isSkip, resultBattleClose)
		zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
	end
end

--- @return void
function UIArenaTeamSearchView:OnClickRefresh()
	self:ClearListOpponent()
	self:CreateListOpponent()
end

--- @return boolean
function UIArenaTeamSearchView:IsSkipBattle()
	return self.unlockSkip and PlayerSettingData.isSkipArena == true
end

--- @return void
function UIArenaTeamSearchView:UpdateSkip()
	self.config.iconTickSkip:SetActive(self:IsSkipBattle())
end

--- @return void
function UIArenaTeamSearchView:OnClickSkip()
	if ClientConfigUtils.CheckUnlockMinorFeatureAndNotification(MinorFeatureType.BATTLE_SKIP_PRE, true) then
		if PlayerSettingData.isSkipArena == true then
			PlayerSettingData.isSkipArena = false
		else
			PlayerSettingData.isSkipArena = true
		end
		PlayerSetting.SaveData()
		self:UpdateSkip()
	end
end