require "lua.client.scene.ui.home.uiEventBossChallengeFormation.bossChallengeWorldFormation.BossChallengeWorldFormation"
require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"
require "lua.client.scene.ui.home.uiFormation.UIFormationView"
require "lua.client.core.network.formation.SetFormationOutBound"
require "lua.client.data.Player.PlayerSetting"
require "lua.client.scene.ui.common.heroList.HeroListView3"
require "lua.client.scene.ui.common.UIBarPercentView"

--- @class UIEventBossChallengeFormationView : UIFormationView
UIEventBossChallengeFormationView = Class(UIEventBossChallengeFormationView, UIFormationView)

--- @param model UIEventBossChallengeFormationModel
function UIEventBossChallengeFormationView:Ctor(model)
	UIFormationView.Ctor(self, model)
	--- @type UIEventBossChallengeFormationModel
	self.model = model
	--- @type EventBossChallengeModel
	self.eventModel = nil
	---@type UIEventBossChallengeFormationConfig
	self.config = nil
	---@type List
	self.rewardOfStageWinsList = List()
	---@type boolean
	self.isLoseFirstTimeWhenSkipBattle = false
end

function UIEventBossChallengeFormationView:SetHeroListData()
	--- @type List
	self.listHeroResource = List()
	if self.model.currentMode == GameMode.EVENT_BOSS_CHALLENGE then
		--- @type EventBossChallengeModel
		self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
		----- @type EventBossChallengeConfig
		self.eventConfig = self.eventModel:GetConfig()
		--- @type EventBossChallengeModel
		self.listHeroResource = self.eventConfig:GetHeroResourceByDay(self.eventModel.loginData.eventCurrentDay)
	else
		--- @type DomainInBound
		local domainInBound = zg.playerData:GetMethod(PlayerDataMethod.DOMAIN)
		self.listHeroResource = domainInBound:GetTeamListHeroResource()
	end
	self.heroList:SetData(self.listHeroResource, self.canPlayMotion)
end

--- @return void
function UIEventBossChallengeFormationView:InitButtonListener()
	UIFormationView.InitButtonListener(self)
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.quickBattleButton.onClick:AddListener(function()
		if self.eventModel.isBoughtPremiumPass == true then
			self:OnClickQuickBattle()
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_buy_boss_premium_pass"))
		end
	end)
	self.config.quickBattleButtonNotSkip.onClick:AddListener(function()
		if self.eventModel.isBoughtPremiumPass == true then
			self:OnClickQuickBattle()
		else
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("need_buy_boss_premium_pass"))
		end
	end)
end

--- @return void
function UIEventBossChallengeFormationView:InitLocalization()
	UIFormationView.InitLocalization(self)
	local localizeBattle = LanguageUtils.LocalizeCommon("quick_battle")
	self.config.textQuickBattle.text = localizeBattle
	self.config.textQuickBattle2.text = localizeBattle
end

--- @return void
--- @param result {gameMode:GameMode, formationTeamData:UIFormationTeamData, rewardList:List<ItemIconData>, tittle}
function UIEventBossChallengeFormationView:_Init(result)
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
	if result ~= nil then
		if result.cache == nil then
			self.model.currentMode = result.gameMode
			self.model.teamFormation = self.eventModel.battleTeamInfomation
			self.model.defenderTeamInfo = result.battleTeamInfo
			self.callbackPlayBattle = result.callbackPlayBattle
		end

		self.worldFormation = result.worldFormation
		if result.returnWorldFormation ~= nil then
			self.cacheWorldFormation = true
			result.returnWorldFormation = function()
				return self.worldFormation
			end
		end

		if result.tittle ~= nil then
			self.config.localizeBattle.text = result.tittle
		else
			self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
		end
		self:SetHeroListData()
		if self.model.teamFormation.frontLine:Count() == 0 and self.model.teamFormation.backLine:Count() == 0  then
			self.model.teamFormation = TeamFormationInBound()
			self.model.teamFormation:SetDefaultTeam()
		else
			self.model.teamFormation:CheckHeroId(self.listHeroResource)
		end

		--self.model.teamFormation:KazetsuTrialCheckHeroDead(self.eventModel:ConvertHeroWithStateToDict())
		--- @type EventBossChallengeModel
		self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
		self.eventModel.battleTeamInfomation = self.model.teamFormation
		self:UpdateTeamFormation()
		self:CheckCanSkip(result.canSkip)

		UIUtils.SetActiveColorByMaterial(self.config.quickBattleButtonNotSkip.gameObject, self.eventModel.isBoughtPremiumPass == true, "ui_gray_mat")
		UIUtils.SetActiveColorByMaterial(self.config.quickBattleButton.gameObject, self.eventModel.isBoughtPremiumPass == true, "ui_gray_mat")

		if self.model.defenderTeamInfo == nil then
			self.config.powerDefender:SetActive(false)
		else
			self.config.powerDefender:SetActive(true)

			if result.cache == nil then
				self.powerDefenderTeam = result.powerDefenderTeam
			end
			if self.powerDefenderTeam == nil then
				self.powerDefenderTeam = ClientConfigUtils.GetPowerByBattleTeamInfo(self.model.defenderTeamInfo)
			end
			self.config.textPowerDefender.text = tostring(math.floor(self.powerDefenderTeam))
			self:UpdateLinkingDefenderTeam()
		end

		if self.canPlayMotion == true then
			self.canPlayMotion = false
		end
		self.tab:Select(self.model.teamFormation.formationId)

		self:SetUpLayout(result)
	end
end

function UIEventBossChallengeFormationView:OnShowWorldFormation()
	self.worldFormation:SetAttackerFormation(self.model.teamFormation.formationId)
	self.worldFormation:SetDefenderPredefineTeamData(self.model.defenderTeamInfo)
	self.coroutine = Coroutine.start(function()
		coroutine.waitforseconds(0.15)
		---@type DetailTeamFormation
		local detailTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(self.model.teamFormation,
				self.listHeroResource)
		self.worldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
		self.worldFormation.attackerWorldFormation:EnableSummonerSlot(false)
	end)
end

--- @return void
function UIEventBossChallengeFormationView:OnReadyCreate()
	UIFormationView.OnReadyCreate(self)
	self.bossHp = UIBarPercentView(self.config.bossHp)
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
	--- @type HeroListView3
	self.heroList = HeroListView3(self.config.heroList)
	--- @return void
	--- @param heroIndex number
	--- @param buttonHero HeroIconView
	--- @param heroResource HeroResource
	self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
		if self.eventModel.battleTeamInfomation:IsContainHeroInventoryId(heroResource.inventoryId)
				and self.eventModel:ConvertHeroWithStateToDict():Get(heroResource.inventoryId).hpPercent > 0   then
			buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
			buttonHero:EnableButton(true)
		else
			buttonHero:ActiveMaskSelect(false)
			buttonHero:EnableButton(true)
		end
	end

	--- @return void
	--- @param heroIndex number
	--- @param buttonHero HeroIconView
	--- @param heroResource HeroResource
	self.buttonListener = function(heroIndex, buttonHero, heroResource)
		local isDead = self.eventModel:ConvertHeroWithStateToDict():Get(heroResource.inventoryId).hpPercent <= 0
		if isDead == true then
			return
		end
		if self.model.teamFormation:IsContainHeroInventoryId(heroResource.inventoryId) then
			self:RemoveHeroFromTeam(heroResource.inventoryId)
			buttonHero:ActiveMaskSelect(false)
			buttonHero:EnableButton(true)
			self:UpdateTeamFormation()
		else
			if self.model.teamFormation:IsFull() == false then
				self:AddHeroToTeam(heroResource)
				buttonHero:ActiveMaskSelect(true, UIUtils.sizeItem)
				buttonHero:EnableButton(true)
				self:UpdateTeamFormation()
			else
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("noti_full_hero"))
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			end
		end
	end
	self.heroList:Init(self.buttonListener,
			nil, nil,
			nil, nil, self.onUpdateIconHero, self.onUpdateIconHero)

end

--- @return void
function UIEventBossChallengeFormationView:UpdateTeamFormation()
	self:UpdateLinkingTeamFormation()
	self:UpdatePowerAttacker()
	self:UpdateCompanionBuff()
end

--- @return void
function UIEventBossChallengeFormationView:UpdateCompanionBuff()
	local companionBuff = ClientConfigUtils.GetCompanionIdBuyTeamFormationWithHeroResource(self.model.teamFormation, self.listHeroResource)
	self.config.companion1.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
end

--- @return void
function UIEventBossChallengeFormationView:UpdatePowerAttacker()
	---@type BattleTeamInfo
	local battleTeamInfo = ClientConfigUtils.GetBattleTeamInfoByTeamFormationInBoundKazetsuTrial(
			self.model.teamFormation, self.listHeroResource)

	self.powerAttacker = math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo))
	self.config.textPowerAttacker.text = tostring(self.powerAttacker)
end

--- @return void
function UIEventBossChallengeFormationView:OnReadyShow(result)
	UIFormationView.OnReadyShow(self, result)
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
	if self.eventModel ~= nil then
		self.eventConfig = self.eventModel:GetConfig()
	end
	self.isLoseFirstTimeWhenSkipBattle = true
	self:_InitMoneyBar()
	self:UpdateHp()
	self.config.floorText.text = string.format("%s %s", LanguageUtils.LocalizeCommon("floor"), self.eventModel.currentStage)
	self.rewardOfStageWinsList:Clear()
end

function UIEventBossChallengeFormationView:UpdateHp()
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
	self.bossHp.gameObject:SetActive(true)
end

function UIEventBossChallengeFormationView:OnReadyHide()
	if self.cacheResult ~= nil and self.cacheResult.callbackSkipSuccess ~= nil then
		self.cacheResult.callbackSkipSuccess()
		return
	end
	if self.gemBarView then
		self.gemBarView:ReturnPool()
		self.gemBarView = nil
	end

	self.bossHp:SetActive(false)
	UIBaseView.OnReadyHide(self)
end

--- @return boolean
--- @param value ItemIconData
--- @param list List
function UIEventBossChallengeFormationView:IsContainReward(list, value)
	for i = 1,list:Count() do
		--- @type ItemIconData
		local item = list:Get(i)
		if item.itemId == value.itemId then
			return true
		end
	end

	return false
end

--- @start world
function UIEventBossChallengeFormationView:CheckCanSkip(canSkip)
	local enableSkip = false
	local featureType = ClientConfigUtils.GetFeatureTypeByGameMode(self.model.currentMode)
	if self.model.currentMode == GameMode.RAID
			and ClientConfigUtils.CheckUnlockMajorFeatureAndNotification(featureType, false) == true then
		enableSkip = true
	else
		---@type {level, stage}
		local require = ResourceMgr.GetMinorFeatureLock().dict:Get(MinorFeatureType.BATTLE_SKIP)
		local vip = ResourceMgr.GetVipConfig():GetCurrentBenefits()
		local playerLevel = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO).level
		enableSkip = (vip.battleUnlockSkip == true or
				(require.level <= playerLevel and require.stage < zg.playerData:GetCampaignData().stageNext)) or canSkip == true
	end
	self.config.canSkip:SetActive(enableSkip)
	self.config.battleButtonNotSkip.gameObject:SetActive(not enableSkip)
	self.config.quickBattleButtonNotSkip.gameObject:SetActive(not enableSkip)
end

---@return void
function UIEventBossChallengeFormationView:OnClickQuickBattle()
	local canBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_BOSS_CHALLENGE_TICKET, 1))
	if canBattle then
		if self.model.teamFormation ~= nil and self.model.teamFormation:IsContainHeroInFormation() then
			local data = {}
			data.callbackQuickBattle = function(value)
				self:CallbackQuickBattle(value)
			end
			PopupMgr.ShowPopup(UIPopupName.UIBossChallengeQuickBattle,data)
		else
			zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
		end
	end
end

---@return void
function UIEventBossChallengeFormationView:CallbackQuickBattle(value)
	if value >= self.eventConfig:GetChallengeConfig().avgWinTicker then
		local beforeStage = self.eventModel.currentStage
		--- @type List
		local rewardList = nil
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			self.eventModel.currentFinalStageTeamId = buffer:GetInt()
			self.eventModel.currentStage = buffer:GetInt() + 1
			rewardList = NetworkUtils.GetRewardInBoundList(buffer)
		end
		local onSuccess = function()
			InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_BOSS_CHALLENGE_TICKET, value - 1)
			if self.eventModel.isBoughtPremiumPass == true then
				for i = beforeStage, self.eventModel.currentStage - 1 do
					self.eventModel:AddPremiumPassClaimedStageList(i)
				end
			end
			self:OnClickBattle(true, true, rewardList)
		end
		local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, value - 1)

		local onFailed = function(logicCode)
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
			SmartPoolUtils.ShowShortNotification(logicCode)
		end
		NetworkUtils.RequestAndCallback(OpCode.EVENT_BOSS_CHALLENGE_QUICK_BATTLE, outBound, onSuccess, onFailed, onBufferReading)
	else
		self:OnClickBattle(true)
	end
end

---@return void
function UIEventBossChallengeFormationView:OnClickBattle(isSkip, isQuickBattle, rewards)
	local canBattle = InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_BOSS_CHALLENGE_TICKET, 1))
	if canBattle then
		if self.model.teamFormation ~= nil and self.model.teamFormation:IsContainHeroInFormation() then
			self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
			local heroStateDict = self.eventModel:ConvertHeroWithStateToDict()
			--- @param battleResultInbound BossChallengeTowerBattleResultInBound
			local callbackSuccess = function(battleResultInbound)
				zg.battleMgr.gameMode = self.model.currentMode
				self:SaveFormationLocal()
				---@type BattleTeamInfo
				local attackerBattleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(self.model.currentMode,
						self.listHeroResource)
				local listHeroInfo = attackerBattleTeamInfo.listHeroInfo
				local inventoryId,heroState
				local listHeroIdString = ""
				local listHeroPositionString = ""
				for i = 1,listHeroInfo:Count() do
					--- @type HeroBattleInfo
					local heroInfo = listHeroInfo:Get(i)
					heroInfo.positionId = heroInfo.position
					inventoryId = self.model.teamFormation:GetHeroPosition(heroInfo).heroInventoryId
					heroState = heroStateDict:Get(inventoryId)
					heroInfo:SetState(heroState.hpPercent,heroState.power)
					if i == listHeroInfo:Count() then
						listHeroIdString = listHeroIdString .. tostring(heroInfo.heroId)
						listHeroPositionString = listHeroPositionString .. tostring(heroInfo.position)
					else
						listHeroIdString = listHeroIdString .. tostring(heroInfo.heroId) .. ","
						listHeroPositionString = listHeroPositionString .. tostring(heroInfo.position) .. ","
					end
				end

				TrackingUtils.AddFirebaseEventWithArgs(FBEvents.ZITGA_BATTLE,
						FBEvents.BATTLE_ID, battleResultInbound.seedInBound.seed,
						FBEvents.STAGE_ID, self.eventModel.currentStage,
						FBEvents.MODE, "event_boss_challenge",
						FBEvents.FACTION_BUFF, ClientConfigUtils.GetCompanionIdBuyTeamFormationWithHeroResource(self.model.teamFormation, self.listHeroResource),
						FBEvents.SUMMONER_ID, self.summonerInbound.summonerId,
						FBEvents.FORMATION, self.model.teamFormation.formationId,
						FBEvents.BATTLE_POWER, self.powerAttacker,
						FBEvents.WIN, battleResultInbound.isWin,
						FBEvents.IS_ATTACKER, 1)

				TrackingUtils.AddFirebaseEventWithArgs(FBEvents.ZITGA_HERO,
						FBEvents.BATTLE_ID, battleResultInbound.seedInBound.seed,
						FBEvents.HERO_ID, listHeroIdString,
						FBEvents.POSITION, listHeroPositionString,
						FBEvents.FORMATION_ID, self.model.teamFormation.formationId,
						FBEvents.IS_ATTACKER, 1)

				if isSkip == true then
					local data = {}
					data.gameMode = self.model.currentMode
					data.isSkip = isSkip

					--- @type BossChallengeTowerBattleResultInBound
					local bossChallengeTowerBattleInbound = self.eventModel.bossChallengeResultInBound

					if bossChallengeTowerBattleInbound.listBattleLogs:Count() > 1 or isQuickBattle == true  then
						local beforeStage = self.eventModel.currentStage
						if self.eventModel.currentStage < self.eventConfig:GetTotalBossChallengeTower() + 1 and bossChallengeTowerBattleInbound.listBattleLogs:Count() > 1 then
							self.eventModel.currentStage = self.eventModel.currentStage + (bossChallengeTowerBattleInbound.listBattleLogs:Count() - 1)
						end
						if self.eventModel.isBoughtPremiumPass == true then
							for i = beforeStage, self.eventModel.currentStage - 1 do
								self.eventModel:AddPremiumPassClaimedStageList(i)
							end
						end

						self.eventModel.bossChallengeDetailDict:Add(self.eventModel.currentStage, self.eventModel.defenderHeroState)
						--- @type List
						local rewardList = nil

						if isQuickBattle == true then
							rewardList = RewardInBound.GetItemIconDataList(rewards)
						end

						for i = 1 ,bossChallengeTowerBattleInbound.listBattleLogs:Count() do
							--- @type BossChallengeBattleLogInBound
							local battleLogInbound = bossChallengeTowerBattleInbound.listBattleLogs:Get(i)
							if battleLogInbound.listReward:Count() > 0 then
								if rewardList == nil then
									rewardList = RewardInBound.GetItemIconDataList(battleLogInbound.listReward)
								else
									for i = 1,rewardList:Count() do
										---@type ItemIconData
										local item = rewardList:Get(i)
										local rewardList2 = RewardInBound.GetItemIconDataList(battleLogInbound.listReward)
										for j = 1,rewardList2:Count() do
											---@type ItemIconData
											local item1 = rewardList2:Get(j)
											if self:IsContainReward(rewardList, item1) then
												if item1.itemId == item.itemId then
													item.quantity = item.quantity + item1.quantity
												end
											else
												rewardList:Add(item1)
											end
										end
									end
								end
							end
						end
						--
						--if bossChallengeTowerBattleInbound.listBattleLogs:Count() > 1 then
						--	zg.playerData.rewardList = rewardList
						--	zg.playerData:AddListRewardToInventory()
						--	data.rewardList = rewardList
						--end

						zg.playerData.rewardList = rewardList
						zg.playerData:AddListRewardToInventory()
						data.rewardList = rewardList

						data.callbackClose = function()
							PopupMgr.HidePopup(UIPopupName.UIVictory)
							self:OnReadyHide()
						end
						PopupMgr.ShowPopup(UIPopupName.UIVictory, data)
					else
						data.callbackClose = function()
							PopupMgr.HidePopup(UIPopupName.UIDefeat)
							self:OnReadyHide()
						end
						data.callbackUpgrade = function(popupName)
							PopupMgr.HidePopup(UIPopupName.UIDefeat)
							PopupMgr.HidePopup(UIPopupName.UIEventBossChallengeFormation)
							if popupName == UIPopupName.UIHeroCollection then
								PopupMgr.ShowPopup(UIPopupName.UIMainArea)
							end
							PopupMgr.ShowPopup(popupName)
						end
						PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
					end
				else
					zg.battleMgr:RunCalculatedBattleScene(attackerBattleTeamInfo,self.model.defenderTeamInfo,self.model.currentMode,nil,nil,battleResultInbound.listBattleLogs:Get(battleResultInbound:GetBattleIndex()).battleLog)
				end
			end
			if self.callbackPlayBattle ~= nil then
				if self.model.currentMode == GameMode.FRIEND_BATTLE
						or self.model.currentMode == GameMode.GUILD_DUNGEON
						or self.model.currentMode == GameMode.GUILD_BOSS then
					self:SaveFormationServer(nil, false)
				end
				if self.model.currentMode == GameMode.DOMAINS then
					zg.playerData:GetFormationInBound():AddTeamFormationInBound(self.model.currentMode,
							self.model.teamFormation)
					self.callbackPlayBattle(UIFormationTeamData.CreateByTeamFormationInBoundAndListHeroResource(
							self.model.teamFormation,
							self.listHeroResource),
							callbackSuccess,
							self.powerAttacker)
				elseif self.model.currentMode == GameMode.EVENT_BOSS_CHALLENGE then
					self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
					self.eventModel.battleTeamInfomation = self.model.teamFormation
					self.callbackPlayBattle(UIFormationTeamData.CreateByTeamFormationInBound(self.model.teamFormation,
							self.listHeroResource),
							callbackSuccess,
							self.powerAttacker)
				else
					self.callbackPlayBattle(UIFormationTeamData.CreateByTeamFormationInBound(self.model.teamFormation),
							callbackSuccess,
							self.powerAttacker)
				end
			end
		else
			zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("insert_least_one_hero"))
		end
	end

end

--- @return void
function UIEventBossChallengeFormationView:_InitMoneyBar()
	if self.gemBarView == nil then
		self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.gemAnchor)
	end
	self.gemBarView:SetIconData(MoneyType.EVENT_BOSS_CHALLENGE_TICKET)
	self.gemBarView.config.buttonInfo.interactable = true
	self.gemBarView.config.buttonInfo.onClick:RemoveAllListeners()
	self.gemBarView:SetSize(0, 0)
	self.gemBarView.config.buttonInfo.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self.gemBarView:ShowInfo()
	end)
end

function UIEventBossChallengeFormationView:OnClickCompanion1()
	local data = {}
	data.companionId = ClientConfigUtils.GetCompanionIdBuyTeamFormationWithHeroResource(self.model.teamFormation, self.listHeroResource)
	data.summonerId = self.summonerInbound.summonerId
	data.summonerStar = self.summonerInbound.star
	PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIEventBossChallengeFormationView:OnClickCompanion2()
	local data = {}
	data.companionId = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
	data.summonerId = self.model.defenderTeamInfo.summonerBattleInfo.summonerId
	data.summonerStar = self.model.defenderTeamInfo.summonerBattleInfo.star
	PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIEventBossChallengeFormationView:OnClickBackOrClose()
	UIBaseView.OnClickBackOrClose(self)
end
