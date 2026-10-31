require "lua.client.scene.ui.home.uiKazetsuTrialFormation.KazetsuTrialWorldFormation.KazetsuTrialWorldFormation"
require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"
require "lua.client.scene.ui.home.uiFormation.UIFormationView"
require "lua.client.core.network.formation.SetFormationOutBound"
require "lua.client.data.Player.PlayerSetting"
require "lua.client.scene.ui.common.heroList.HeroListView2"
--- @class UIKazetsuTrialFormationView : UIFormationView
UIKazetsuTrialFormationView = Class(UIKazetsuTrialFormationView, UIFormationView)

--- @return void
--- @param model UIFormationModel
function UIKazetsuTrialFormationView:Ctor(model)
	UIFormationView.Ctor(self, model)
	--- @type UIKazetsuTrialFormationModel
	self.model = model
	--- @type EventKazetsuModel
	self.kazetsuModel = nil
end

function UIKazetsuTrialFormationView:SetHeroListData()
	--- @type List
	self.listHeroResource = List()
	if self.model.currentMode == GameMode.EVENT_KAZETSU_TRIAL then
		--- @type EventKazetsuModel
		self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
		--- @type List
		local listHeroSelectionId = List()
		for i = 1, self.kazetsuModel.selectedHeroWithStateList:Count() do
			listHeroSelectionId:Add(self.kazetsuModel.selectedHeroWithStateList:Get(i).selectHeroId)
		end
		--- @type EventKazetsuModel
		self.listHeroResource = self.kazetsuModel
		                            :GetConfig()
		                            :GetHeroResourceByListSelection(listHeroSelectionId)
	else
		--- @type DomainInBound
		local domainInBound = zg.playerData:GetMethod(PlayerDataMethod.DOMAIN)
		self.listHeroResource = domainInBound:GetTeamListHeroResource()
	end
	self.heroList:SetData(self.listHeroResource, self.canPlayMotion)
end


--- @start world
function UIKazetsuTrialFormationView:InitWorldFormation()
	if self.worldFormation == nil then
		local transform = SmartPool.Instance:SpawnTransform(AssetType.UI, "world_formation")
		self.worldFormation = KazetsuTrialWorldFormation(transform)
	end
	self.worldFormation.swapCallback = function(hero1, hero2)
		self:CallbackSwapHero(hero1, hero2)
	end
	self.worldFormation.removeCallback = function(hero)
		self:CallbackRemove(hero)
	end
	self.worldFormation.selectSummonerCallback = function()
		self:CallbackSelectSummoner()
	end
end

--- @return void
function UIKazetsuTrialFormationView:InitButtonListener()
	UIFormationView.InitButtonListener(self)
	self.config.buttonBack.onClick:AddListener(function()
		local updateTeamFormation = function(result)
			self.kazetsuModel.battleTeamInfomation = self.model.teamFormation
		end
		NetworkUtils.RequestAndCallback(OpCode.EVENT_KAZETSU_FORMATION_SET,
				KazetsuTrialBattleFormationOutBound(UIFormationTeamData.CreateByTeamFormationInBoundAndListHeroResource(
						self.model.teamFormation,
						self.listHeroResource)),
				updateTeamFormation)
		self:OnClickBackOrClose()
	end)
end



--- @return void
--- @param result {gameMode:GameMode, formationTeamData:UIFormationTeamData, rewardList:List<ItemIconData>, tittle}
function UIKazetsuTrialFormationView:_Init(result)
	self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
	if result ~= nil then
		if result.cache == nil then
			self.model.currentMode = result.gameMode
			self.model.teamFormation = self.kazetsuModel.battleTeamInfomation
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

		self.model.teamFormation:KazetsuTrialCheckHeroDead(self.kazetsuModel:ConvertHeroWithStateToDict())
		--- @type EventKazetsuModel
		self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
		self.kazetsuModel.battleTeamInfomation = self.model.teamFormation
		self:UpdateTeamFormation()
		self:CheckCanSkip(result.canSkip)

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

function UIKazetsuTrialFormationView:OnShowWorldFormation()
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
function UIKazetsuTrialFormationView:OnReadyCreate()
	UIFormationView.OnReadyCreate(self)
	self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
	--- @type HeroListView2
	self.heroList = HeroListView2(self.config.heroList)
	--- @return void
	--- @param heroIndex number
	--- @param buttonHero HeroIconView
	--- @param heroResource HeroResource
	self.onUpdateIconHero = function(heroIndex, buttonHero, heroResource)
		--- @type EventKazetsuModel
		local kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
		if kazetsuModel.battleTeamInfomation:IsContainHeroInventoryId(heroResource.inventoryId)
				and kazetsuModel:ConvertHeroWithStateToDict():Get(heroResource.inventoryId).hpPercent >0   then
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
		if heroResource.heroId == HeroConstants.KAZETSU_HERO_ID
				and self.model.teamFormation:IsContainHeroInventoryId(heroResource.inventoryId) then
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("cant_unpick_kazetsu"))
			zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
			return
		end
		local isDead = self.kazetsuModel:ConvertHeroWithStateToDict():Get(heroResource.inventoryId).hpPercent <= 0
		if isDead == true then
			--- @type EventKazetsuConfig
			local config = self.kazetsuModel:GetConfig()
			if self.kazetsuModel.usedReviveTime >= config:GetTrialConfig().revivePerDay then
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_revive_turn"))
				zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
				return
			end
			local price = config:GetTrialConfig().gemRevive
			local currentGem = InventoryUtils.Get(ResourceType.Money, MoneyType.GEM)
			if currentGem >= price then
				PopupUtils.ShowPopupNotificationUseResource(MoneyType.GEM, price, function()
					InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, price)
					self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
					self:ReviveHero(heroResource, buttonHero)
				end)
			else
				local data = RewardInBound()
				data.type = ResourceType.Money
				data.id = MoneyType.GEM
				data.number = price
				InventoryUtils.IsEnoughSingleResourceRequirement(data, true)
			end
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
function UIKazetsuTrialFormationView:UpdateTeamFormation()
	self:UpdateLinkingTeamFormation()
	self:UpdatePowerAttacker()
	self:UpdateCompanionBuff()
end

--- @return void
function UIKazetsuTrialFormationView:UpdateCompanionBuff()
	local companionBuff = ClientConfigUtils.GetCompanionIdBuyTeamFormationWithHeroResource(self.model.teamFormation, self.listHeroResource)
	self.config.companion1.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
end

--- @return void
function UIKazetsuTrialFormationView:UpdatePowerAttacker()
	---@type BattleTeamInfo
	local battleTeamInfo = ClientConfigUtils.GetBattleTeamInfoByTeamFormationInBoundKazetsuTrial(
			self.model.teamFormation, self.listHeroResource)

	self.powerAttacker = math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo))
	self.config.textPowerAttacker.text = tostring(self.powerAttacker)
end

--- @return void
function UIKazetsuTrialFormationView:OnReadyShow(result)
	UIFormationView.OnReadyShow(self, result)
	local reviveLeft = self.kazetsuModel:GetConfig():GetTrialConfig().revivePerDay - self.kazetsuModel.usedReviveTime
	self.config.textReviveTime.text = LanguageUtils.LocalizeCommon("revive_time") .. ": " .. reviveLeft
	self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
	self:_InitMoneyBar()
	if self.heroList.choseKazetsu ~= nil then
		if self.model.teamFormation:CheckHeroInventoryId(-1) == true then
			return
		end
		self.heroList.choseKazetsu()
	end
end

function UIKazetsuTrialFormationView:ReviveHero(heroResource, buttonHero)
	local onSuccess = function()
		self.kazetsuModel:ReviveHero(heroResource.inventoryId)
		self.heroList.uiScroll:Resize(self.kazetsuModel.selectedHeroWithStateList:Count())
		local reviveLeft = self.kazetsuModel:GetConfig():GetTrialConfig().revivePerDay - self.kazetsuModel.usedReviveTime
		self.config.textReviveTime.text = LanguageUtils.LocalizeCommon("revive_time") .. " :" .. reviveLeft
	end
	NetworkUtils.RequestAndCallback(OpCode.EVENT_KAZETSU_TRIAL_REVIVE,UnknownOutBound.CreateInstance(PutMethod.Int,heroResource.inventoryId),onSuccess)
end

function UIKazetsuTrialFormationView:OnReadyHide()

	if self.cacheResult ~= nil and self.cacheResult.callbackSkipSuccess ~= nil then
		self.cacheResult.callbackSkipSuccess()
		return
	end
	if self.gemBarView then
		self.gemBarView:ReturnPool()
		self.gemBarView = nil
	end
	UIBaseView.OnReadyHide(self)
end

--- @return void
--- @param heroResource HeroResource
function UIKazetsuTrialFormationView:AddHeroToTeam(heroResource)
	local isFrontLine, position = self.model.teamFormation:AddHeroInventoryId(heroResource.inventoryId)
	self.worldFormation:SetHeroAtPosition(true, isFrontLine, position, heroResource)
	self.worldFormation:ResetButtonSlot()
end

--- @param hero {isFrontLine, positionId}
--- @return boolean
function UIKazetsuTrialFormationView:CallbackRemove(hero)
	----- @type HeroFormationInBound
	--local hero = self.model.teamFormation:GetHeroPosition(hero)
	--if self.:Get hero.heroInventoryId == -1 then
	--	SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("cant_unpick_kazetsu"))
	--	return false
	--end
	self.model.teamFormation:RemoveHeroPosition(hero)
	self.heroList.uiScroll:RefreshCells()
	self:UpdateTeamFormation()
	return true
end

---@return void
function UIKazetsuTrialFormationView:OnClickBattle(isSkip)
	if self.model.teamFormation ~= nil and self.model.teamFormation:IsContainHeroInFormation() then
		self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
		local heroStateDict = self.kazetsuModel:ConvertHeroWithStateToDict()
		local callbackSuccess = function(defenderTeamInfoOverride, isSkipResult, isWin, otherCondition)
			zg.battleMgr.gameMode = self.model.currentMode
			self:SaveFormationLocal()
			if defenderTeamInfoOverride ~= nil then
				self.model.defenderTeamInfo = defenderTeamInfoOverride
			end
			if isSkipResult ~= true then
				---@type BattleTeamInfo
				local attackerBattleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(self.model.currentMode,
						self.listHeroResource)
				local listHeroInfo = attackerBattleTeamInfo.listHeroInfo
				local inventoryId, heroState
				--print("TRUOC SAU BATTLE")
				for i = 1, listHeroInfo:Count() do
					--- @type HeroBattleInfo
					local heroInfo = listHeroInfo:Get(i)
					heroInfo.positionId = heroInfo.position
					inventoryId = self.model.teamFormation:GetHeroPosition(heroInfo).heroInventoryId
					heroState = heroStateDict:Get(inventoryId)
					heroInfo:SetState(heroState.hpPercent, heroState.power)
					if inventoryId ~= nil then
						--print("selectHeroId :" .. inventoryId .. " hpPercent :".. heroState.hpPercent .. " power :" .. heroState.power)
					end
				end

				if isSkip == true then
					zg.battleMgr:RunVirtualBattle(attackerBattleTeamInfo,
							self.model.defenderTeamInfo, self.model.currentMode, nil, RunMode.FASTEST)
					local data = {}
					data.gameMode = self.model.currentMode
					data.result = ClientBattleData.battleResult
					data.clientLogDetail = ClientBattleData.clientLogDetail
					local isWin = data.gameMode == GameMode.EVENT_VALENTINE_BOSS
							or data.gameMode == GameMode.EVENT_CHRISTMAS
							or data.gameMode == GameMode.EVENT_KAZETSU_BOSS
							or data.gameMode == GameMode.EVENT_BIRTHDAY_BOSS
							or data.gameMode == GameMode.EVENT_FINDE_BOSS
							or data.gameMode == GameMode.EVENT_SEASONAL_ROYAL_CHALLENGE
							or ClientBattleData.battleResult.winnerTeam == BattleConstants.ATTACKER_TEAM_ID
					if isWin == true then
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
							PopupMgr.HidePopup(UIPopupName.UIFormation)
							if popupName == UIPopupName.UIHeroCollection then
								PopupMgr.ShowPopup(UIPopupName.UIMainArea)
							end
							PopupMgr.ShowPopup(popupName)
						end
						PopupMgr.ShowPopup(UIPopupName.UIDefeat, data)
					end
				else
					zg.battleMgr:RunCalculatedBattleScene(attackerBattleTeamInfo, self.model.defenderTeamInfo, self.model.currentMode)
				end
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
			elseif self.model.currentMode == GameMode.EVENT_KAZETSU_TRIAL then
				self.kazetsuModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
				self.kazetsuModel.battleTeamInfomation = self.model.teamFormation
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

--- @return void
function UIKazetsuTrialFormationView:_InitMoneyBar()
	if self.gemBarView == nil then
		self.gemBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.config.gemAnchor)
	end
	self.gemBarView:SetIconData(MoneyType.GEM)
end

function UIKazetsuTrialFormationView:OnClickCompanion1()
	local data = {}
	data.companionId = ClientConfigUtils.GetCompanionIdBuyTeamFormationWithHeroResource(self.model.teamFormation, self.listHeroResource)
	data.summonerId = self.summonerInbound.summonerId
	data.summonerStar = self.summonerInbound.star
	PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIKazetsuTrialFormationView:OnClickCompanion2()
	local data = {}
	data.companionId = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
	data.summonerId = self.model.defenderTeamInfo.summonerBattleInfo.summonerId
	data.summonerStar = self.model.defenderTeamInfo.summonerBattleInfo.star
	PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIKazetsuTrialFormationView:OnClickBackOrClose()
	UIBaseView.OnClickBackOrClose(self)
end