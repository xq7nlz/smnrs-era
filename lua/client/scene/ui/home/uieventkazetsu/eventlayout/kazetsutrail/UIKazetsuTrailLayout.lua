require "lua.client.core.network.event.eventKazetsu.EventKazetsuRollDraftInBound"
--- @class UIKazetsuTrailLayout : UIEventKazetsuLayout
UIKazetsuTrailLayout = Class(UIKazetsuTrailLayout, UIEventKazetsuLayout)
--- @type BattleResult
--- @param view UIEventKazetsuView
--- @param newYearTab EventKazetsuTab
--- @param anchor UnityEngine_RectTransform
function UIKazetsuTrailLayout:Ctor(view, newYearTab, anchor)
	--- @type UIEventKazetsuView
	self.view = view
	--- @type EventKazetsuTab
	self.eventKazetsuTab = newYearTab
	--- @type UnityEngine_RectTransform
	self.anchor = anchor
	--- @type UIKazetsuTrailLayoutConfig
	self.layoutConfig = nil
	--- @type EventKazetsuModel
	self.eventModel = nil
	--- @type EventKazetsuConfig
	self.eventConfig = nil
	self.opCode = OpCode.EVENT_KAZETSU_DAILY_LOGIN_CLAIM
	self.eventTimeType = EventTimeType.EVENT_KAZETSU
	--- @type List
	self.listTowers = List()
	UIEventKazetsuLayout.Ctor(self, view, newYearTab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIKazetsuTrailLayout:InitLayoutConfig(objectView)
	local inst = PrefabLoadUtils.Instantiate("kazetsu_trail_layout", self.anchor)
	UIEventKazetsuLayout.InitLayoutConfig(self, inst)
	self:InitButtons()
end

function UIKazetsuTrailLayout:InitButtons()
	self.layoutConfig.buttonHelp.onClick:AddListener(
			function()
				self:OnClickHelpInfo()
				zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
			end
	)
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
	self.layoutConfig.rollButton.onClick:AddListener(
			function()
				--- Show popup roll & draft team
				local callbackNavigation = function()
					PopupMgr.ShowAndHidePopup(UIPopupName.UIRollDraftTeam,
							{ ["callbackClose"] = function()
								PopupMgr.ShowAndHidePopup(UIPopupName.UIEventKazetsu, { ["tab"] = EventKazetsuTab.TRIAL }, UIPopupName.UIRollDraftTeam)
							end },
							UIPopupName.UIEventKazetsu)
				end

				--- Check if already have team selected
				if self.eventModel.selectedHeroWithStateList:Count() > 0 then
					zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
					SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("cant_roll_after_confirm_lineup"))
					return
				else
					zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
					--- Check if already have pool roll team
					if self.eventModel.heroRandomPoolList:Count() > 0 then
						callbackNavigation()
					else
						--- If dont have pool roll team request server for team
						EventKazetsuRollDraftInBound.RequestRollHeroes(function(selectionIdRandomPoolList)
							self.eventModel.heroRandomPoolList = selectionIdRandomPoolList
							callbackNavigation()
						end
						)
					end
				end
			end
	)
end

--- @return void
function UIKazetsuTrailLayout:OnClickBattle()
	self:GetModelConfig()
	--- @type Dictionary
	local listHero = self.eventModel:ConvertHeroWithStateToDict()
	local isHaveSelectedHero = self.eventModel:ConvertHeroWithStateToDict():Count() > 0
	if isHaveSelectedHero then
		local kazetsu = listHero:Get(-1)
		if kazetsu.hpPercent <= 0 then
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("kazetsu_already_dead"))
			return
		end
		if self.eventModel.currentStage > self.eventConfig:GetTotalKazetsuTower() then
			SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("end_kazetsu_tower"))
			return
		end

		local levelConfig = self.csv:GetLevelConfig(self.currentStage)
		self.eventModel.currentStage = self.currentStage
		---@type BattleTeamInfo
		local battleTeamInfo = self.eventConfig:GetListLineupRecommendation(self.eventModel.currentStage)
		local rewardList = self.eventConfig:GetTowerRewardById(self.eventModel.currentStage)
		local result = {}
		result.gameMode = GameMode.EVENT_KAZETSU_TRIAL
		result.powerDefenderTeam = levelConfig:GetPowerTeam()
		result.battleTeamInfo = battleTeamInfo
		result.bgParams = self.eventModel.currentStage

		local data = { tab = EventKazetsuTab.TRIAL }
		result.callbackClose = function()
			PopupMgr.ShowAndHidePopup(UIPopupName.UIEventKazetsu, data, UIPopupName.UIKazetsuTrialFormation)
		end

		result.callbackSkipSuccess = function()
			PopupMgr.ShowAndHidePopup(UIPopupName.UIEventKazetsu, data, UIPopupName.UIKazetsuTrialFormation)
		end

		--- @param uiFormationTeamData UIFormationTeamData
		result.callbackPlayBattle = function(uiFormationTeamData, callback)
			--- @param logicCode LogicCode
			local onFailed = function(logicCode)
				if logicCode == LogicCode.TOWER_STAGE_INVALID then
					PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.TOWER }, result.callbackClose)
				end
			end

			---@param battleResultInBound KazetsuTowerBattleResultInBound
			local callbackSuccess = function(battleResultInBound)
				if battleResultInBound.isWin then
					zg.playerData.rewardList = rewardList
					zg.playerData:AddListRewardToInventory()
					self:GetModelConfig()
					if self.eventModel.currentStage <= self.eventConfig:GetTotalKazetsuTower() then
						self.eventModel.currentStage = self.eventModel.currentStage + 1
					end
					self.eventModel.highestStageTime = zg.timeMgr:GetServerTime()
				end
				self.eventModel.selectedHeroWithStateList:Clear()
				self.eventModel.selectedHeroWithStateList = battleResultInBound.selectedHeroWithStateList
				if callback ~= nil then
					callback(nil, nil, battleResultInBound.isWin)
				end
			end
			BattleFormationRequest.KazetsuBattleRequest(OpCode.EVENT_KAZETSU_CHALLENGE,
					uiFormationTeamData, self.eventModel.currentStage, callbackSuccess, onFailed)
		end
		PopupMgr.ShowAndHidePopup(UIPopupName.UIKazetsuTrialFormation, result, UIPopupName.UIEventKazetsu)
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("you_must_have_a_lineup"))
	end
end

function UIKazetsuTrailLayout:OnClickReturnCurrentStage()
	self.scrollTower:ScrollToCell(self.eventModel.currentStage - 1)
	self:ShowInfoKazetsuTower(self.eventModel.currentStage)
end

function UIKazetsuTrailLayout:OnClickHelpInfo()
	local helpText = LanguageUtils.LocalizeHelpInfo("kazetsu_trial")
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, helpText)
end

function UIKazetsuTrailLayout:InitLocalization()
	self.layoutConfig.textEnemyTeam.text = LanguageUtils.LocalizeCommon("enemy_team")
	self.layoutConfig.textItemReward.text = LanguageUtils.LocalizeCommon("reward")
	self.layoutConfig.textBattle.text = LanguageUtils.LocalizeCommon("battle")
	self.layoutConfig.textRoll.text = LanguageUtils.LocalizeCommon("roll")
	self.layoutConfig.textReturn.text = LanguageUtils.LocalizeCommon("back_to_current")
end

function UIKazetsuTrailLayout:SetUpLayout()
	UIEventLayout.SetUpLayout(self)
	self.anchor.gameObject:SetActive(true)
	--- @type KazetsuTowerData
	self.csv = ResourceMgr.GetKazetsuTowerConfig()
	self.total = self.eventConfig:GetTotalKazetsuTower()
	--- @param obj KazetsuTowerTrailItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local id = index + 1
		local campaignConfig = self.eventConfig:GetCampaignStageConfigById(id)
		if id == self.eventModel.currentStage then
			obj:EnableHighlight()
		end
		obj:FillData(campaignConfig)
		obj:AddListener(
				function()
					self:ShowInfoKazetsuTower(id)
					zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
				end
		)
		self.listTowers:Add(obj)
	end
	self.scrollTower = UILoopScroll(self.layoutConfig.scroll, UIPoolType.KazetsuTowerTrailItem, onCreateItem)
	--- @type LineupItemView2
	self.lineupItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.LineupItemView2, self.layoutConfig.defenderTeamAnchor)
	--- @type ItemsTableView
	self.rewardView = ItemsTableView(self.layoutConfig.rewardAnchor)
end

--- @param id number
function UIKazetsuTrailLayout:ShowInfoKazetsuTower(id)
	if id > self.eventConfig:GetTotalKazetsuTower() then
		id = self.eventConfig:GetTotalKazetsuTower()
	end
	if (self.eventModel.currentStage == id) then
		self.layoutConfig.battleButton.gameObject:SetActive(true)
		self.layoutConfig.buttonReturn.gameObject:SetActive(false)
	else
		self.layoutConfig.battleButton.gameObject:SetActive(false)
		self.layoutConfig.buttonReturn.gameObject:SetActive(true)
	end
	self.currentStage = id
	self.layoutConfig.textFloorTitle.text = LanguageUtils.LocalizeCommon("floor") .. " " .. id
	self:ShowEnemy(id)
	self:ShowReward(id)
	self:EnableHighlight(id)
end

function UIKazetsuTrailLayout:EnableHighlight(id)
	for i = 1, self.listTowers:Count() do
		---@type KazetsuTowerTrailItem
		local item = self.listTowers:Get(i)
		if item.stage == id then
			item:EnableHighlight()
		else
			item:DisableHighlight()
		end
	end

end

function UIKazetsuTrailLayout:ShowEnemy(floorId)
	local lineupRecommend = self.eventConfig:GetListLineupRecommendation(floorId)
	self.lineupItemView:SetData(lineupRecommend, floorId)
	self.layoutConfig.textCp.text = self.csv:GetLevelConfig(floorId).powerTeam
end

--- @param floorId number
function UIKazetsuTrailLayout:ShowReward(floorId)
	if self.rewardView ~= nil then
		self.rewardView:Hide()
	end
	--- @type List -- <ItemIconData>
	local rewardList = self.eventConfig:GetTowerRewardById(floorId)
	self.model.listSelectedFloorReward = rewardList
	self.rewardView:SetData(rewardList)
	if floorId < self.eventModel.currentStage then
		self.rewardView:ActiveMaskSelect(true)
	end
end

function UIKazetsuTrailLayout:SetEventBanner()
end

function UIKazetsuTrailLayout:SetEventTitle()
end

function UIKazetsuTrailLayout:SetEventDesc()
end

function UIKazetsuTrailLayout:OnShow()
	self:GetModelConfig()
	UIEventLayout.OnShow(self)

	--- Check if already have team selected
	if self.eventModel.selectedHeroWithStateList:Count() > 0 then
		self.layoutConfig.rollButton.gameObject:SetActive(false)
	else
		self.layoutConfig.rollButton.gameObject:SetActive(true)
	end
	self.scrollTower:Resize(self.eventConfig:GetTotalKazetsuTower())
	local id = self.eventModel.currentStage
	if id > self.eventConfig:GetTotalKazetsuTower() then
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("end_kazetsu_tower"))
		id = self.eventConfig:GetTotalKazetsuTower()
	end
	self:ShowInfoKazetsuTower(id)
	self.scrollTower:ScrollToCell(id - 1, 2000)
	self:InitLocalization()
	self:UpdateButtons()
end

function UIKazetsuTrailLayout:UpdateButtons()
	--self.layoutConfig.rollButton.gameObject:SetActive()
end

function UIKazetsuTrailLayout:OnHide()
	UIEventLayout.OnHide(self)
	self.scrollTower:Hide()
	self.rewardView:Hide()
	self.lineupItemView:Hide()
	self.anchor.gameObject:SetActive(false)
	self.listTowers:Clear()
end

function UIKazetsuTrailLayout:GetModelConfig()
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	if self.eventModel ~= nil then
		self.eventConfig = self.eventModel:GetConfig()
	end
end