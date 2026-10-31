require "lua.client.scene.ui.home.uiFormation.UIFormationTeamData"
require "lua.client.scene.ui.home.uiMidAutumnArenaFormation.MidAutumnWorldFormation.MidAutumnWorldFormation"
require "lua.client.scene.ui.home.uiFormation.UIFormationView"
require "lua.client.core.network.formation.SetFormationOutBound"
require "lua.client.data.Player.PlayerSetting"
require "lua.client.scene.ui.common.heroList.HeroListView2"
--- @class UIMidAutumnArenaFormationView : UIFormationView
UIMidAutumnArenaFormationView = Class(UIMidAutumnArenaFormationView, UIFormationView)

--- @return void
--- @param model UIMidAutumnArenaFormation
function UIMidAutumnArenaFormationView:Ctor(model)
	UIFormationView.Ctor(self, model)
	--- @type UIMidAutumnArenaFormationModel
	self.model = model
	--- @type EventMidAutumnModel
	self.eventModel = nil
end

function UIMidAutumnArenaFormationView:SetHeroListData()
	--- @type List
	self.listHeroResource = List()
	if self.model.currentMode == GameMode.MID_AUTUMN_ARENA_RECORD then
		self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
		self.listHeroResource = self.eventModel:GetConfig().attackerTeamConfig:GetListHeroResourceByDay(self.day)
	elseif self.model.currentMode == GameMode.CHRISTMAS_ARENA_RECORD then
		self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
		self.listHeroResource = self.eventModel:GetConfig().attackerTeamConfig:GetListHeroResourceByDay(self.day)
	else
		--- @type DomainInBound
		local domainInBound = zg.playerData:GetMethod(PlayerDataMethod.DOMAIN)
		self.listHeroResource = domainInBound:GetTeamListHeroResource()
	end
end

--- @return void
function UIMidAutumnArenaFormationView:InitButtonListener()
	UIFormationView.InitButtonListener(self)
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

--- @start world
function UIMidAutumnArenaFormationView:InitWorldFormation()
	if self.worldFormation == nil then
		local transform = SmartPool.Instance:SpawnTransform(AssetType.UI, "world_formation")
		self.worldFormation = MidAutumnWorldFormation(transform)
	end
end

--- @return void
--- @param result {gameMode:GameMode, formationTeamData:UIFormationTeamData, rewardList:List<ItemIconData>, tittle}
function UIMidAutumnArenaFormationView:_Init(result)
	if result ~= nil then
		if result.cache == nil then
			self.model.currentMode = result.gameMode
			self.model.defenderTeamInfo = result.defenderTeamInfo
			self.model.attackerTeamInfo = result.attackerTeamInfo
		end
		self.day = result.day
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

		--if self.model.teamFormation == nil then
		self.model.teamFormation = TeamFormationInBound()
		self.model.teamFormation:SetDefaultTeam()
		--else
		--	self.model.teamFormation:CheckHeroId(self.listHeroResource)
		--	print(LogUtils.ToDetail(self.model.teamFormation))
		--end
		self:UpdateTeamFormation()
		--- @type DefenderTeamData
		self.teamData = self.eventModel:GetConfig().attackerTeamConfig:GetTeamConfigByDay(self.day)
		self.teamFormationId = self.teamData.predefineTeamData.formationId
		self.model.teamFormation.formationId = self.teamFormationId
		
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

		if self.model.attackerTeamInfo == nil then
			self.config.powerAttacker:SetActive(false)
		else
			self.config.powerAttacker:SetActive(true)

			if result.cache == nil then
				self.powerAttackerTeam = result.powerAttackerTeam
			end
			if self.powerAttackerTeam == nil then
				self.powerAttackerTeam = ClientConfigUtils.GetPowerByBattleTeamInfo(self.model.attackerTeamInfo)
			end
			self.config.textPowerAttacker.text = tostring(math.floor(self.powerAttackerTeam))
			self:UpdateLinkingDefenderTeam()
		end

		if self.canPlayMotion == true then
			self.canPlayMotion = false
		end
		self.tab:Select(self.model.teamFormation.formationId)

		self:SetUpLayout(result)
	end
end

function UIMidAutumnArenaFormationView:OnShowWorldFormation()
	for i = 1, self.listHeroResource:Count() do
		self:AddHeroToTeam(self.listHeroResource:Get(i))
	end
	self:UpdateTeamFormation()
	self.worldFormation:SetAttackerFormation(self.model.teamFormation.formationId)
	self.worldFormation:SetDefenderPredefineTeamData(self.model.defenderTeamInfo)
	self.coroutine = Coroutine.start(function()
		coroutine.waitforseconds(0.15)
		---@type DetailTeamFormation
		local detailTeamFormation = DetailTeamFormation.CreateByTeamFormationInBound(self.model.teamFormation, self.listHeroResource)
		self.worldFormation:ShowAttackerPredefineTeam(detailTeamFormation)
		self.worldFormation:ShowAttackerSummoner(self.model.attackerTeamInfo.summonerBattleInfo.summonerId, self.model.attackerTeamInfo.summonerBattleInfo.star)
	end)
end

--- @return void
function UIMidAutumnArenaFormationView:UpdateTeamFormation()
	self:UpdateLinkingTeamFormation()
	self:UpdateCompanionBuff()
end

--- @return void
function UIMidAutumnArenaFormationView:UpdateCompanionBuff()
	local companionBuff = ClientConfigUtils.GetCompanionIdBuyTeamFormationWithHeroResource(self.model.teamFormation, self.listHeroResource)
	self.config.companion1.sprite = ResourceLoadUtils.LoadCompanionBuffOnIcon(companionBuff)
end

function UIMidAutumnArenaFormationView:OnClickCompanion1()
	local data = {}
	data.companionId = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.attackerTeamInfo)
	data.summonerId = self.summonerInbound.summonerId
	data.summonerStar = self.summonerInbound.star
	PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

function UIMidAutumnArenaFormationView:OnClickCompanion2()
	local data = {}
	data.companionId = ClientConfigUtils.GetCompanionIdByBattleTeamInfo(self.model.defenderTeamInfo)
	data.summonerId = self.model.defenderTeamInfo.summonerBattleInfo.summonerId
	data.summonerStar = self.model.defenderTeamInfo.summonerBattleInfo.star
	PopupMgr.ShowPopup(UIPopupName.UICompanionCollection, data)
end

--- @return void
--- @param heroResource HeroResource
function UIMidAutumnArenaFormationView:AddHeroToTeam(heroResource)
	local isFrontLine, position = self.model.teamFormation:AddHeroInventoryId(heroResource.inventoryId)
	self.worldFormation:SetHeroAtPosition(true, isFrontLine, position, heroResource)
	self.worldFormation:ResetButtonSlot()
end

function UIMidAutumnArenaFormationView:OnClickBackOrClose()
	self:SaveFormationLocal()
	UIBaseView.OnClickBackOrClose(self)
end