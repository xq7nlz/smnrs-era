--- @class UIEventHeroBossView : UIBaseView
UIEventHeroBossView = Class(UIEventHeroBossView, UIBaseView)

--- @param model UIEventHeroBossModel
function UIEventHeroBossView:Ctor(model)
	--- @type UIEventHeroBossConfig
	self.config = nil
	UIBaseView.Ctor(self, model)
	--- @type UIEventHeroBossModel
	self.model = model
	--- @type number
	self.heroId = 20006
	--- @type ListSkillView
	self.listSkillView = nil
	--- @type EventFindeBossChallengeConfig
	self.eventConfig = nil
	--- @type number
	self.bossFactionId = nil
end

function UIEventHeroBossView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self.listSkillView = ListSkillView(self.config.iconSkillSystem, U_Vector2(0.5, 0), self.config.iconSkillPreview)
	self:InitButtons()
	self:InitScroll()
end

function UIEventHeroBossView:InitScroll()
	local onCreateItem = function(obj, index)
		---@type  BossChallengeRewardMilestoneData
		local bossMilestoneReward = self.eventConfig.listBossDamageRewardConfig:Get(index + 1)
		obj:SetIconData(bossMilestoneReward.listInstantReward, bossMilestoneReward.listAllReward, index + 1)
	end
	self.scrollReward = UILoopScroll(self.config.scroll, UIPoolType.ChestFindeItemView, onCreateItem)
end

function UIEventHeroBossView:InitButtons()
	self.config.buttonChallenge.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickButtonChallenge()
	end)
	self.config.buttonBack.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnReadyHide()
	end)
	self.config.buttonBuyTurn.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickBuyTurn()
	end)
	self.config.buttonLeaderBoard.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickLeaderBoard()
	end)
	self.config.buttonHelp.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		self:OnClickHelpInfo()
	end)

end

function UIEventHeroBossView:UpdateLocalization()
	local dataId = self.eventModel.timeData.dataId
	self.config.textEventName.text = LanguageUtils.LocalizeCommon("event_hero_boss_title_"..dataId)
	self.config.textEventDesc.text = LanguageUtils.LocalizeCommon("event_hero_boss_des_"..dataId)
	self.config.textRewardTitle.text = LanguageUtils.LocalizeCommon("reward")
	self.config.textButton.text = LanguageUtils.LocalizeCommon("challenge")
	self.config.heroNameTxt.text = LanguageUtils.LocalizeNameHero(self.heroId)
	self.config.textTicket.text = LanguageUtils.LocalizeCommon("remaining_attempts")
end

--- @param data {callbackClose : function}
function UIEventHeroBossView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_FINDE_BOSS)
	--- @type EventFindeBossChallengeConfig
	self.eventConfig = self.eventModel:GetConfig()
	self.staminaInBound = self.eventConfig.challengePriceList:Get(1)
	self.scrollReward:Resize(self.eventConfig.listBossDamageRewardConfig:Count())
	self:UpdateBossUIByDataId()
	self:UpdateLocalization()
	self:StartUpdateTime()
	self:ShowUiTurn()
	self:InitHero()
end

function UIEventHeroBossView:UpdateBossUIByDataId()
	self.heroId = self.eventConfig:GetBossHeroId()
	self.bossFactionId = ClientConfigUtils.GetFactionIdByHeroId(self.heroId)
	local dataId = self.eventModel.timeData.dataId

	local bg = ResourceLoadUtils.LoadTexture("BgEventHeroBoss", tostring(dataId), ComponentName.UnityEngine_Sprite)
	self.config.factionIcon.sprite = ResourceLoadUtils.LoadFactionIcon(self.bossFactionId)
	self.config.backgroundGlowText.color = ClientConfigUtils.GetColorGlowByFaction(self.bossFactionId)
	if bg ~= nil then
		self.config.backgroundBoss.sprite = bg
	end
end

function UIEventHeroBossView:GetModelConfig()
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_FINDE_BOSS)
	--- @type EventFindeBossChallengeConfig
	self.eventConfig = self.eventModel:GetConfig()
end

function UIEventHeroBossView:InitHero()
	self.listSkillView:SetDataHero(HeroResource.CreateInstance(nil, self.heroId, 13, 1), false)

	if self.worldSpaceHeroView == nil then
		---@type UnityEngine_Transform
		local trans = SmartPool.Instance:SpawnTransform(AssetType.Battle, "world_space_hero_view")
		self.worldSpaceHeroView = WorldSpaceHeroView(trans)
		local renderTexture = U_RenderTexture(1000, 1000, 24, U_RenderTextureFormat.ARGB32)
		self.config.iconHero.texture = renderTexture
		self.worldSpaceHeroView:Init(renderTexture)
	end
	local heroResource = HeroResource()
	local heroItem = Dictionary()
	--heroItem:Add(7, self.skinId)
	heroResource:SetData(-1, self.heroId, 13, 1, heroItem)
	self.worldSpaceHeroView:ShowHero(heroResource)
	self.worldSpaceHeroView.config.heroAnchor.localScale = U_Vector3(1, 1, 1)
	self.worldSpaceHeroView.config.heroAnchor.localPosition = U_Vector3(0, -1.77, 0)
	self.worldSpaceHeroView.config.bg:SetActive(false)
end

function UIEventHeroBossView:ShowUiTurn()
	self.config.textTurnLeft.text = string.format("%s/%s",
			InventoryUtils.Get(ResourceType.Money, self.staminaInBound.id),
			self.eventConfig.defaultStamina)
end

function UIEventHeroBossView:OnClickButtonChallenge()
	if InventoryUtils.IsEnoughSingleResourceRequirement(self.staminaInBound, false) then
		self:ShowFormation()
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("out_of_turn"))
	end
end

--- @return void
function UIEventHeroBossView:ShowFormation()
	---@type DefenderTeamData
	local dataStage = self.eventConfig:GetDefenderTeamData()
	---@type BattleTeamInfo
	local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
	--- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
	local result = {}
	result.gameMode = GameMode.EVENT_FINDE_BOSS
	result.battleTeamInfo = battleTeamInfo
	result.powerDefenderTeam = dataStage:GetPowerTeam()
	result.callbackClose = function()
		PopupMgr.HidePopup(UIPopupName.UIFormation)
		PopupMgr.ShowPopup(self.model.uiName)
	end
	result.callbackPlayBattle = function(uiFormationTeamData, callback)
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			self:GetModelConfig()
			require "lua.client.core.network.event.eventXmasModel.ChristmasChallengeBossInBound"
			--- @type ChristmasChallengeBossInBound
			self.eventModel.eventBossChallengeInBound = ChristmasChallengeBossInBound(buffer)
		end
		local callbackSuccess = function()
			InventoryUtils.SubSingleRewardInBound(self.staminaInBound)
			zg.playerData.rewardList = RewardInBound.GetItemIconDataList(self.eventModel.eventBossChallengeInBound.listReward)
			zg.playerData:AddListRewardToInventory()
			zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
			if callback ~= nil then
				callback()
			end
		end
		NetworkUtils.RequestAndCallback(OpCode.EVENT_FINDE_BOSS_CHALLENGE,
				BattleFormationOutBound(uiFormationTeamData),
				callbackSuccess,
				SmartPoolUtils.LogicCodeNotification, onBufferReading)
	end
	PopupMgr.HidePopup(self.model.uiName)
	PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

--- @return void
function UIEventHeroBossView:OnClickLeaderBoard()
	PopupMgr.ShowPopup(UIPopupName.UIEventHeroBossLeaderboard)
end

function UIEventHeroBossView:OnClickHelpInfo()
	local helpText = LanguageUtils.LocalizeHelpInfo("event_hero_boss_help_"..self.eventModel.timeData.dataId)
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, helpText)
end

--- @return void
function UIEventHeroBossView:GetModelConfig()
	--- @type EventFindeBossModel
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_FINDE_BOSS)
end

function UIEventHeroBossView:OnClickBuyTurn()
	self:GetModelConfig()
	local maxCountBuyTurn = self.eventConfig.maxNumberBuy - self.eventModel.numberBuyBossTurn
	if maxCountBuyTurn > 0 then
		local callback = function(numberReturn, priceTotal)
			local callback = function(result)
				local onSuccess = function()
					InventoryUtils.Sub(self.eventConfig.staminaPrice.type, self.eventConfig.staminaPrice.id, priceTotal)
					InventoryUtils.Add(ResourceType.Money, self.staminaInBound.id, numberReturn)
					self.eventModel:BuyBossTurnSuccess(numberReturn)
					self:ShowUiTurn()
				end
				local onFailed = function(logicCode)
					SmartPoolUtils.LogicCodeNotification(logicCode)
				end
				NetworkUtils.ExecuteResult(result, nil, onSuccess, onFailed)
			end
			NetworkUtils.Request(OpCode.EVENT_FINDE_STAMINA_BUY, UnknownOutBound.CreateInstance(PutMethod.Byte, numberReturn), callback)
		end
		---@type PopupBuyItemData
		local dataPurchase = PopupBuyItemData()
		dataPurchase:SetData(ResourceType.Money, self.eventConfig.staminaPrice.id, 1, 1, maxCountBuyTurn,
				self.eventConfig.staminaPrice.id, self.eventConfig.staminaPrice.number,
				callback, LanguageUtils.LocalizeCommon("buy_turn"),
				LanguageUtils.LocalizeCommon("buy"), false)

		PopupMgr.ShowPopup(UIPopupName.UIPopupBuyItemString, dataPurchase)
	else
		SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_buy_turn_daily"))
		zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
	end
end

function UIEventHeroBossView:StartUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			self:SetTimeRefresh()
		else
			self.timeRefresh = self.timeRefresh - 1
		end
		local text = LanguageUtils.LocalizeCommon("will_end_in") .." ".. TimeUtils.GetDeltaTime(self.timeRefresh)
		local timeText = UIUtils.SetColorString(UIUtils.green_light,text)
		self.config.timeCountDown.text = timeText
		if self.timeRefresh <= 0 then
			self:RemoveUpdateTime()
		end
	end
	zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventHeroBossView:SetTimeRefresh()
	local svTime = zg.timeMgr:GetServerTime()
	self.timeRefresh = self.eventModel.timeData.endTime - svTime
end

function UIEventHeroBossView:RemoveUpdateTime()
	if self.updateTime ~= nil then
		zg.timeMgr:RemoveUpdateFunction(self.updateTime)
		self.updateTime = nil
	end
end

function UIEventHeroBossView:Hide()
	UIBaseView.Hide(self)
	self.scrollReward:Hide()
	self.listSkillView:ReturnPool()
	if self.worldSpaceHeroView ~= nil then
		self.worldSpaceHeroView.config.heroAnchor.localScale = U_Vector3(1.3, 1.3, 1)
		self.worldSpaceHeroView.config.heroAnchor.localPosition = U_Vector3(0, -1.28, 0)
		self.worldSpaceHeroView:OnHide()
		self.worldSpaceHeroView = nil
	end
	self:RemoveUpdateTime()
end

function UIEventHeroBossView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIEventHeroBoss)
end