require("lua.client.scene.ui.home.uiEventBossChallenge.eventLayout.UIEventBossChallengeLayout")
require "lua.client.scene.ui.common.UIBarPercentView"

--- @class UIBossChallengeTowerLayout : UIEventBossChallengeLayout
UIBossChallengeTowerLayout = Class(UIBossChallengeTowerLayout, UIEventBossChallengeLayout)
--- @type BattleResult
--- @param view UIEventBossChallengeView
--- @param tab EventBossChallengeTab
--- @param anchor UnityEngine_RectTransform
function UIBossChallengeTowerLayout:Ctor(view, tab, anchor)
	--- @type UIEventBossChallengeView
	self.view = view
	--- @type EventBossChallengeTab
	self.eventBossChallengeTab = tab
	--- @type UnityEngine_RectTransform
	self.anchor = anchor
	--- @type UIBossChallengeTowerLayoutConfig
	self.layoutConfig = nil
	--- @type EventBossChallengeModel
	self.eventModel = nil
	--- @type EventBossChallengeConfig
	self.eventConfig = nil
	self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
	--- @type List
	self.listTowers = List()
	UIEventBossChallengeLayout.Ctor(self, view, tab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIBossChallengeTowerLayout:InitLayoutConfig(objectView)
	local inst = PrefabLoadUtils.Instantiate("event_boss_challenge_tower_layout", self.anchor)
	UIEventBossChallengeLayout.InitLayoutConfig(self, inst)
	self:InitButtons()
	self.bossHp = UIBarPercentView(self.layoutConfig.bossHp)
end

--- @return void
function UIBossChallengeTowerLayout:_InitMoneyBar()
	if self.gemBarView == nil then
		---@type MoneyBarView
		self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.gemAnchor)
	end
	self.gemBarView:SetIconData(MoneyType.EVENT_BOSS_CHALLENGE_TICKET)
	self.gemBarView.config.buttonInfo.interactable = true
	self.gemBarView.config.buttonInfo.onClick:RemoveAllListeners()
	self.gemBarView:SetSize(0, 0)
	self.gemBarView.config.buttonInfo.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self.gemBarView:ShowInfo()
	end)
	self.gemBarView:RemoveAllListeners()
	self.gemBarView:AddListener(function()
		self.view:SelectTab(EventBossChallengeTab.BOSS_PACK)
	end)
end

function UIBossChallengeTowerLayout:InitButtons()
	self.layoutConfig.battleButton.onClick:AddListener(
			function()
				self:OnClickBattle()
				zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
			end)
	self.layoutConfig.buttonReturn.onClick:AddListener(
			function()
				self:OnClickReturnCurrentStage()
				zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
			end)
	self.layoutConfig.rewardAnchor2:GetChild(2):GetComponent(ComponentName.UnityEngine_UI_Button).onClick:AddListener(
			function()
				self:OnClickShowReward()
			end
	)
end

function UIBossChallengeTowerLayout:OnClickShowReward()
	local rewardLoopDict = Dictionary()
	rewardLoopDict = self.eventConfig:GetAllTowerLoopRewardById()
	local listRewardLoop = List()
	---@param v List
	for k,v in pairs(rewardLoopDict:GetItems()) do
		local reward = v:Get(3)
		listRewardLoop:Add(reward)
	end

	local data = {}
	--- @type List
	data.listRewardIconData = listRewardLoop
	PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPool, data)
end

--- @return void
function UIBossChallengeTowerLayout:OnClickBattle()
	self:GetModelConfig()

	---@type BattleTeamInfo
	local battleTeamInfo = nil
	if self.eventModel.currentStage > self.eventConfig:GetTotalBossChallengeTower() then
		battleTeamInfo = self.eventConfig:GetListLineupLoopRecommendation(self.eventModel.currentFinalStageTeamId)
	else
		battleTeamInfo = self.eventConfig:GetListLineupRecommendation(self.eventModel.currentStage)
	end

	local stageDetailData = self.eventModel.bossChallengeDetailDict:Get(self.eventModel.currentStage)
	if stageDetailData ~= nil then
		--- @param v HeroStateInBound
		for _, v in pairs(stageDetailData:GetItems()) do
			battleTeamInfo:SetState(GameMode.EVENT_BOSS_CHALLENGE, v.isFrontLine, v.position, v.hp, v.power)
		end
	end

	local result = {}
	result.gameMode = GameMode.EVENT_BOSS_CHALLENGE
	result.battleTeamInfo = battleTeamInfo
	result.currentStage = self.eventModel.currentStage

	local data = { tab = EventBossChallengeTab.CHALLENGE_TOWER }
	result.callbackClose = function()
		PopupMgr.ShowAndHidePopup(UIPopupName.UIEventBossChallenge, data, UIPopupName.UIEventBossChallengeFormation)
	end

	result.callbackSkipSuccess = function()
		PopupMgr.ShowAndHidePopup(UIPopupName.UIEventBossChallenge, data, UIPopupName.UIEventBossChallengeFormation)
	end

	--- @param uiFormationTeamData UIFormationTeamData
	result.callbackPlayBattle = function(uiFormationTeamData, callback)
		--- @param logicCode LogicCode
		local onFailed = function(logicCode)
			if logicCode == LogicCode.TOWER_STAGE_INVALID then
				PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.TOWER }, result.callbackClose)
			end
		end

		---@param battleResultInBound BossChallengeTowerBattleResultInBound
		local callbackSuccess = function(battleResultInBound)
			self.eventModel.defenderHeroState = battleResultInBound.defenderHeroState
			self.eventModel.bossChallengeDetailDict:Add(self.eventModel.currentStage, self.eventModel.defenderHeroState)
			self.eventModel.currentFinalStageTeamId = battleResultInBound.currentFinalStageTeamId

			InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_BOSS_CHALLENGE_TICKET, 1)
			if callback ~= nil then
				callback(battleResultInBound)
			end
		end
		BattleFormationRequest.EventBossChallengeBattleRequest(OpCode.EVENT_BOSS_CHALLENGE_BATTLE,
				uiFormationTeamData, self.eventModel.currentStage, callbackSuccess, onFailed)
	end
	PopupMgr.ShowAndHidePopup(UIPopupName.UIEventBossChallengeFormation, result, UIPopupName.UIEventBossChallenge)
end

function UIBossChallengeTowerLayout:OnClickReturnCurrentStage()
	--self.scrollTower:ScrollToCell(self.eventModel.currentStage - 1)
	self:ResizeScroll()
	self:ShowInfoBossChallengeTower(self.eventModel.currentStage)
end

function UIBossChallengeTowerLayout:SetUpLayout()
	UIEventLayout.SetUpLayout(self)
	self.anchor.gameObject:SetActive(true)
	--- @param obj BossChallengeTowerItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local id = index + 1
		if id == self.eventModel.currentStage then
			obj:EnableHighlight()
		end
		obj:FillData(id)
		obj:AddListener(
				function()
					self:ShowInfoBossChallengeTower(id)
					zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
				end
		)
		self.listTowers:Add(obj)
	end
	self.scrollTower = UILoopScroll(self.layoutConfig.scroll, UIPoolType.BossChallengeTowerItem, onCreateItem)
	--- @type LineupBossChallengeItemView
	self.lineupItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.LineupBossChallengeItemView, self.layoutConfig.defenderTeamAnchor)
	--- @type ItemsTableView
	self.rewardView = ItemsTableView(self.layoutConfig.rewardAnchor)
	--- @type ItemsTableView
	self.rewardView2 = ItemsTableView(self.layoutConfig.rewardAnchorVip)
end

--- @param id number
function UIBossChallengeTowerLayout:ShowInfoBossChallengeTower(id)
	if id > self.eventConfig:GetTotalBossChallengeTower() then
		id = self.eventConfig:GetTotalBossChallengeTower() + 1
	end

	self.layoutConfig.buttonReturn.gameObject:SetActive(self.eventModel.currentStage ~= id)

	if zg.timeMgr:GetRemainingTime() >= self.eventConfig:GetChallengeConfig().blockDuration and self.eventModel.currentStage == id then
		self.layoutConfig.battleButton.gameObject:SetActive(true)
	else
		self.layoutConfig.battleButton.gameObject:SetActive(false)
	end

	self.layoutConfig.textFloorTitle.text = LanguageUtils.LocalizeCommon("floor") .. " " .. id
	self:ShowEnemy(id)
	self:ShowReward(id)
	self:EnableHighlight(id)
	self:UpdateHp(id)
end

function UIBossChallengeTowerLayout:UpdateHp(id)
	if id < self.eventModel.currentStage then
		self.bossHp:SetPercent(0)
	elseif id > self.eventModel.currentStage then
		self.bossHp:SetPercent(1)
	else
		---@type BattleTeamInfo
		local battleTeamInfo = nil
		if self.eventModel.currentStage > self.eventConfig:GetTotalBossChallengeTower() then
			battleTeamInfo = self.eventConfig:GetListLineupLoopRecommendation(self.eventModel.currentFinalStageTeamId)
		else
			battleTeamInfo = self.eventConfig:GetListLineupRecommendation(self.eventModel.currentStage)
		end

		local stageDetailData = self.eventModel.bossChallengeDetailDict:Get(self.eventModel.currentStage)

		if stageDetailData ~= nil then
			--- @param v HeroStateInBound
			for _, v in pairs(stageDetailData:GetItems()) do
				battleTeamInfo:SetState(GameMode.EVENT_BOSS_CHALLENGE, v.isFrontLine, v.position, v.hp, v.power)
			end
			local percent = ClientConfigUtils.GetPercentHpBattle(battleTeamInfo, stageDetailData)
			self.bossHp:SetPercent(percent)
		else
			self.bossHp:SetPercent(1)
		end
	end
end

function UIBossChallengeTowerLayout:EnableHighlight(id)
	for i = 1, self.listTowers:Count() do
		---@type BossChallengeTowerItem
		local item = self.listTowers:Get(i)
		if item.stage == id then
			item:EnableHighlight()
		else
			item:DisableHighlight()
		end
	end

end

function UIBossChallengeTowerLayout:ShowEnemy(floorId)
	---@type BattleTeamInfo
	local battleTeamInfo = nil
	if floorId > self.eventConfig:GetTotalBossChallengeTower() then
		battleTeamInfo = self.eventConfig:GetListLineupLoopRecommendation(self.eventModel.currentFinalStageTeamId)
	else
		battleTeamInfo = self.eventConfig:GetListLineupRecommendation(floorId)
	end

	if battleTeamInfo ~= nil then
		self.lineupItemView:SetData(battleTeamInfo, floorId)
		self.powerDefenderTeam = ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo)
		self.layoutConfig.textCp.text = tostring(math.floor(self.powerDefenderTeam))
	end

	if self.eventModel.currentStage <= self.eventConfig:GetTotalBossChallengeTower() then
		if floorId == self.eventConfig:GetTotalBossChallengeTower() + 1 then
			self.lineupItemView:SetDataLoopTower()
			self.layoutConfig.textCp.text = 0
		end
	end
end

--- @param floorId number
function UIBossChallengeTowerLayout:ShowReward(floorId)
	self.layoutConfig.lock.gameObject:SetActive(false)

	if self.rewardView ~= nil then
		self.rewardView:Hide()
	end

	if self.rewardView2 ~= nil then
		self.rewardView2:Hide()
	end

	self.layoutConfig.rewardAnchor2.gameObject:SetActive(false)

	local rewardList = nil
	local rewardPremiumList = nil
	if floorId > self.eventConfig:GetTotalBossChallengeTower() then
		rewardList = self.eventConfig:GetTowerLoopRewardById(self.eventModel.currentFinalStageTeamId)
	else
		rewardList = self.eventConfig:GetTowerRewardById(floorId)
	end

	rewardPremiumList = self.eventConfig:GetTowerRewardPremiumPassById(floorId)

	self.rewardView:SetData(rewardList)
	self.rewardView2:SetData(rewardPremiumList)

	if self.eventModel.isBoughtPremiumPass == false then
		self.rewardView2:ActiveMask(true)
		self.layoutConfig.lock.gameObject:SetActive(true)
	else
		self.rewardView2:ActiveEffectHeroIcon(true)
		if floorId < self.eventModel.currentStage and self.eventModel.premiumPassClaimedStageList:IsContainValue(floorId) then
			self.rewardView2:ActiveMaskSelect(true)
		end
	end

	if floorId < self.eventModel.currentStage then
		self.rewardView:ActiveMaskSelect(true)
	end

	if self.eventModel.currentStage <= self.eventConfig:GetTotalBossChallengeTower() then
		if floorId == self.eventConfig:GetTotalBossChallengeTower() + 1 then
			if self.rewardView ~= nil then
				self.rewardView:Hide()
				self.layoutConfig.rewardAnchor2.gameObject:SetActive(true)
			end
		end
	end
end

function UIBossChallengeTowerLayout:OnShow()
	self:GetModelConfig()
	UIEventLayout.OnShow(self)

	self.layoutConfig.textItemReward.text = LanguageUtils.LocalizeCommon("item_reward")
	self.layoutConfig.textItemVip.text = LanguageUtils.LocalizeCommon("item_reward_premium")
	local id = self.eventModel.currentStage
	self:ResizeScroll()
	self:_InitMoneyBar()
	self:ShowInfoBossChallengeTower(id)
end

function UIBossChallengeTowerLayout:ResizeScroll()
	local id = self.eventModel.currentStage

	local offset = nil

	if id > self.eventConfig:GetTotalBossChallengeTower() - 2 then
		id = self.eventConfig:GetTotalBossChallengeTower() + 1
		offset = id - 3
	else
		offset = id - 1
	end

	self.scrollTower:Resize(self.eventConfig:GetTotalBossChallengeTower() + 1, math.max(0, offset))
end


function UIBossChallengeTowerLayout:OnHide()
	UIEventLayout.OnHide(self)
	if self.gemBarView then
		self.gemBarView:ReturnPool()
		self.gemBarView = nil
	end
	self.scrollTower:Hide()
	self.rewardView:Hide()
	self.rewardView2:Hide()
	self.lineupItemView:ReturnPool()
	self.anchor.gameObject:SetActive(false)
	self.listTowers:Clear()
end

function UIBossChallengeTowerLayout:GetModelConfig()
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	if self.eventModel ~= nil then
		self.eventConfig = self.eventModel:GetConfig()
	end
end



